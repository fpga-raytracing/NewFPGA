// intersection modules

`define FIP_ONE 32'sh00010000
`define FIP_MIN 32'sh80000000
`define FIP_MAX 32'sh7fffffff


// pipelined intersection, accepts new inputs every cycle

typedef logic signed [31:0] fip;


// pipelined intersection
module intersection #(
    parameter signed MIN_T = 0
) (
    input i_clk,
    input i_rstn,
    input i_en,
    input signed [31:0] i_tri [0:2][0:2], // i_tri[0]: vertex 0
    input signed [31:0] i_ray [0:1][0:2], // i_ray[0]: origin(E), i_ray[1]: direction(D)
    output logic signed [31:0] o_t,
    output logic o_result,
    output logic o_valid // pipeline stage valid
);

    // procedure of intersection:
    // sub -> det -> add -> div
    // {sub} -> {det} -> {add, div}
    logic [0:1] valid; // stage valid bit
    logic i_valid; // submodule output

    // stage1: preprocess
    logic signed [31:0] e_t [0:2], t1 [0:2], t2 [0:2], _d [0:2];

    always_comb begin
        e_t = '{i_ray[0][0] - i_tri[0][0], i_ray[0][1] - i_tri[0][1], i_ray[0][2] - i_tri[0][2]};
        t1 = '{i_tri[1][0] - i_tri[0][0], i_tri[1][1] - i_tri[0][1], i_tri[1][2] - i_tri[0][2]};
        t2 = '{i_tri[2][0] - i_tri[0][0], i_tri[2][1] - i_tri[0][1], i_tri[2][2] - i_tri[0][2]};
        _d = '{32'b0 - i_ray[1][0], 32'b0 - i_ray[1][1], 32'b0 - i_ray[1][2]};
    end

    // stage1 reg
    logic signed [31:0] rout_e_t [0:2], rout_t1 [0:2], rout_t2 [0:2], rout__d [0:2];

    // stage2 (multi): det
    logic signed [31:0] coef, det_a, det_b, det_t;
    logic [0:2] drop; // all 4 det modules are working parallelly, so keep only one o_valid
    fip_32_3b3_det det_c_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(valid[0]),
                               .i_array('{rout_t1, rout_t2, rout_e_t}), .o_det(coef), .o_valid(i_valid));
    fip_32_3b3_det det_a_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(valid[0]),
                               .i_array('{rout_e_t, rout_t2, rout__d}), .o_det(det_a), .o_valid(drop[0]));
    fip_32_3b3_det det_b_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(valid[0]),
                               .i_array('{rout_t1, rout_e_t, rout__d}), .o_det(det_b), .o_valid(drop[1]));
    fip_32_3b3_det det_t_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(valid[0]),
                               .i_array('{rout_t1, rout_t2, rout__d}), .o_det(det_t), .o_valid(drop[2]));

    // stage3: result
    logic signed [31:0] a, b, t;
    fip_32_div #(.SAT(1)) div_a_inst (.i_x(det_a), .i_y(coef), .o_z(a));
    fip_32_div #(.SAT(1)) div_b_inst (.i_x(det_b), .i_y(coef), .o_z(b));
    fip_32_div #(.SAT(1)) div_t_inst (.i_x(det_t), .i_y(coef), .o_z(t));
    logic signed [31:0] anb;
    fip_32_add_sat add_sat_inst (.i_x(a), .i_y(b), .o_z(anb));
    logic result;
    always_comb begin
        result = 1'b0;
        if (coef != 0 && a[31] == 0 && b[31] == 0 && anb <= `FIP_ONE && t >= MIN_T) result = 1'b1;
    end

    // stage3 reg
    logic signed [31:0] rout_t;
    logic rout_result;

    // stage control
    always_ff@(posedge i_clk) begin: pipeline
        if (!i_rstn) begin
            rout_e_t <= '{3{32'b0}};
            rout_t1 <= '{3{32'b0}};
            rout_t2 <= '{3{32'b0}};
            rout__d <= '{3{32'b0}};
            rout_t <= 'b0;
            rout_result <= 'b0;
            valid <= 'b0;
        end else begin
            rout_e_t <= e_t;
            rout_t1 <= t1;
            rout_t2 <= t2;
            rout__d <= _d;
            rout_result <= result;
            rout_t <= t;

            // valid[0] goes to i_valid in det submodules
            valid[1] <= i_valid;
        end
        if (i_en) valid[0] <= 1'b1;
        else valid[0] <= 1'b0;
    end

    // output
    assign o_t = rout_t;
    assign o_result = rout_result;
    assign o_valid = valid[1];

endmodule: intersection


// basic intersection (without pipeline)
module bs_intersection #(
    parameter signed MIN_T = 0
) (
    input i_clk,
    input i_rstn,
    input i_en,
    input signed [31:0] i_tri [0:2][0:2], // i_tri[0]: vertex 0
    input signed [31:0] i_ray [0:1][0:2], // i_ray[0]: origin(E), i_ray[1]: direction(D)
    output logic signed [31:0] o_t,
    output logic o_result,
    output logic o_valid // pipeline stage valid
);

    /*
    T1 = i_tri[1] - i_tri[0]
    T2 = i_tri[2] - i_tri[0]

    |T1[0], T2[0], -D[0]|   |a|
    |T1[1], T2[1], -D[1]| x |b| = E - i_tri[0]
    |T1[2], T2[2], -D[2]|   |t|

    coef = det(T1, T2, E - i_tri[0])
    a = det(E - i_tri[0], T2, -D)/coef
    b = det(T1, E - i_tri[0], -D)/coef
    t = det(T1, T2, -D)/coef

    check: coef != 0, a >= 0, b >= 0, a + b <= 1, t >= MIN_T
    normal: T1 x T2 (normalized)
    */

    // preprocess
    logic signed [31:0] e_t [0:2], t1 [0:2], t2 [0:2], _d [0:2];

    always_comb begin
        e_t = '{i_ray[0][0] - i_tri[0][0], i_ray[0][1] - i_tri[0][1], i_ray[0][2] - i_tri[0][2]};
        t1 = '{i_tri[1][0] - i_tri[0][0], i_tri[1][1] - i_tri[0][1], i_tri[1][2] - i_tri[0][2]};
        t2 = '{i_tri[2][0] - i_tri[0][0], i_tri[2][1] - i_tri[0][1], i_tri[2][2] - i_tri[0][2]};
        _d = '{32'b0 - i_ray[1][0], 32'b0 - i_ray[1][1], 32'b0 - i_ray[1][2]};
    end

    // det
    logic signed [31:0] coef, det_a, det_b, det_t;
    logic [0:3] drop; // not using pipeline
    fip_32_3b3_det det_c_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en),
                               .i_array('{t1, t2, e_t}), .o_det(coef), .o_valid(drop[0]));
    fip_32_3b3_det det_a_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en),
                               .i_array('{e_t, t2, _d}), .o_det(det_a), .o_valid(drop[1]));
    fip_32_3b3_det det_b_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en),
                               .i_array('{t1, e_t, _d}), .o_det(det_b), .o_valid(drop[2]));
    fip_32_3b3_det det_t_inst (.i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en),
                               .i_array('{t1, t2, _d}), .o_det(det_t), .o_valid(drop[3]));

    logic signed [31:0] a, b, t;
    fip_32_div #(.SAT(1)) div_a_inst (.i_x(det_a), .i_y(coef), .o_z(a));
    fip_32_div #(.SAT(1)) div_b_inst (.i_x(det_b), .i_y(coef), .o_z(b));
    fip_32_div #(.SAT(1)) div_t_inst (.i_x(det_t), .i_y(coef), .o_z(t));

    logic signed [31:0] anb;
    fip_32_add_sat add_sat_inst (.i_x(a), .i_y(b), .o_z(anb));

    // result
    always_comb begin
        o_t = t;
        o_result = 1'b0;
        if (coef != 0 && a[31] == 0 && b[31] == 0 && anb <= `FIP_ONE && t >= MIN_T) o_result = 1'b1;
    end

endmodule: bs_intersection


// fake intersection, for test only
module dummy_intersection #(
    parameter signed MIN_T = 0
) (
    input i_clk,
    input i_rstn,
    input i_en,
    input signed [31:0] i_tri [0:2][0:2], // i_tri[0]: vertex 0
    input signed [31:0] i_ray [0:1][0:2], // i_ray[0]: origin(E), i_ray[1]: direction(D)
    output logic signed [31:0] o_t,
    output logic o_result,
    output logic o_valid // pipeline stage valid
);

    assign o_t = 'h00010002;
    assign o_result = 'b1;
    assign o_valid = 'b1;

endmodule: dummy_intersection


/*
module ray_intersect_box#(
    parameter SAT = 1,
    parameter FRA_BITS = 16
)(  
    input signed [31:0] i_ray [0:1][0:2], // i_ray[0] for origin(E), i_ray[1] for direction(D)
    input signed [31:0] pbbox [0:1][0:2], // pbbox[0] for min, pbbox[1] for max
    output logic intersects
);
    logic signed [31:0] t_entry;
    logic signed [31:0] t_exit;

    wire signed [31:0] t_min[0:2];
    wire signed [31:0] t_max[0:2];
    
    // Intermediate signals for division operation results
    wire signed [31:0] div_results[0:5];

    // Instantiate division modules for each axis and boundary
    // Computing t_min and t_max for X-axis
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_x_min(.i_x(pbbox[0][0] - i_ray[0][0]), .i_y(i_ray[1][0]), .o_z(div_results[0]));
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_x_max(.i_x(pbbox[1][0] - i_ray[0][0]), .i_y(i_ray[1][0]), .o_z(div_results[1]));
    
    // Computing t_min and t_max for Y-axis
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_y_min(.i_x(pbbox[0][1] - i_ray[0][1]), .i_y(i_ray[1][1]), .o_z(div_results[2]));
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_y_max(.i_x(pbbox[1][1] - i_ray[0][1]), .i_y(i_ray[1][1]), .o_z(div_results[3]));

    // Computing t_min and t_max for Z-axis
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_z_min(.i_x(pbbox[0][2] - i_ray[0][2]), .i_y(i_ray[1][2]), .o_z(div_results[4]));
    fip_32_div #(.SAT(SAT), .FRA_BITS(FRA_BITS)) div_z_max(.i_x(pbbox[1][2] - i_ray[0][2]), .i_y(i_ray[1][2]), .o_z(div_results[5]));

    
    always_comb begin
    
        t_entry = FIP_MAX;
        t_exit = FIP_MIN;

        // For each max min check, perform all comparisons

        // X-axis check
        if (i_ray[1][0] != 0) begin
            t_entry = max(t_entry, min(t_min_x, t_max_x));
            t_exit = min(t_exit, max(t_min_x, t_max_x));
        end

        // Y-axis check
        if (i_ray[1][1] != 0) begin
            t_entry = max(t_entry, min(t_min_y, t_max_y));
            t_exit = min(t_exit, max(t_min_y, t_max_y));
        end

        // Z-axis check
        if (i_ray[1][2] != 0) begin
            t_entry = max(t_entry, min(t_min_z, t_max_z));
            t_exit = min(t_exit, max(t_min_z, t_max_z));
        end

        intersects = (t_exit >= t_entry) && (t_entry >= 0);
    end

    function signed [31:0] max(signed [31:0] a, signed [31:0] b);
        max = a > b ? a : b;
    endfunction

    function signed [31:0] min(signed [31:0] a, signed [31:0] b);
        min = a < b ? a : b;
    endfunction

endmodule: ray_intersect_box
*/



module tri_insector(
    input clk,
    input reset,
    input ivalid,  // enable, should be one cycle
    input [31:0] baseaddr, // const in one batch
    input [32*6-1:0] i_ray, // const in one batch
    input [31:0] i_tri_cnt, // sampled on ivalid

    output logic o_hit, // if there is any hit
    output logic signed [31:0] o_t, // min distance, if there is any hit
    output logic [31:0] o_tri_index, // triangle index of min distance
    output logic o_finish, // batch finish, high for one cycle

    // AVMM interface, SDRAM controller <-> reader <-> avalon_sdr
    output logic         avm_m0_read,
    output logic [31:0]  avm_m0_address,
    input  [15:0]        avm_m0_readdata,
    input                avm_m0_readdatavalid,
    output logic [1:0]   avm_m0_byteenable,
    input                avm_m0_waitrequest
);

    logic reader_en, reader_ready, reader_valid;
    logic [32*9-1:0] reader_data;
    logic [31:0] reg_tri_cnt_in;
    reader #(
        .NDWORDS(9)
    ) tri_reader_inst (
        .clk(clk),
        .reset(reset),

        .baseaddr(baseaddr),
        .index(reg_tri_cnt_in),
        .read(reader_en),
        .data(reader_data),
        .ovalid(reader_valid),
        .iready(reader_ready),

        .avm_m0_read(avm_m0_read),
        .avm_m0_address(avm_m0_address),
        .avm_m0_readdata(avm_m0_readdata),
        .avm_m0_readdatavalid(avm_m0_readdatavalid),
        .avm_m0_byteenable(avm_m0_byteenable),
        .avm_m0_waitrequest(avm_m0_waitrequest)
    );

    logic signed [31:0] reader_tri [0:2][0:2];
    genvar i, j;
    generate begin: unflatten_reader_data
        for (i=0; i<3; ++i) begin: reader_data0
            for (j=0; j<3; ++j) begin: reader_data1
                assign reader_tri[i][j] = reader_data[32*(3*i+j+1)-1 : 32*(3*i+j)];
            end
        end
    end endgenerate

    logic signed [31:0] ray [0:1][0:2];
    generate begin: unflatten_ray_data
        for (i=0; i<2; ++i) begin: ray0
            for (j=0; j<3; ++j) begin: ray1
                assign ray[i][j] = i_ray[32*(2*i+j+1)-1 : 32*(2*i+j)];
            end
        end
    end endgenerate

    logic inter_valid;
    logic signed [31:0] t;
    logic hit;
    intersection #(
        .MIN_T(0)
    ) intersection_inst (
        .i_clk(clk),
        .i_rstn(!reset),
        .i_en(reader_valid),
        .i_tri(reader_tri),
        .i_ray(ray),
        .o_t(t),
        .o_result(hit),
        .o_valid(inter_valid)
    );

    logic [31:0] reg_tri_cnt_out, reg_tri_idx_min;
    logic signed [31:0] reg_t_min;
    logic reg_hit;
    always_ff@(posedge clk) begin
        o_finish <= 1'b0;
        reader_en = 1'b0;
        if(reset) begin
            reg_tri_cnt_in <= 'b0;
            reg_tri_cnt_out <= 'b0;
            reg_tri_idx_min <= 'b0;
            reg_t_min <= 'b0;
            reg_hit <= 1'b0;
        end else if (ivalid) begin
            reg_tri_cnt_in <= i_tri_cnt-1;
            reg_tri_cnt_out <= i_tri_cnt-1;
            reg_t_min <= `FIP_MAX;
            reg_hit <= 1'b0;
        end else begin
            // decrease reg_tri_cnt_in and set reader_en if reader_ready
            // decrease reg_tri_cnt_out if inter_valid
            // and update reg_t_min , reg_tri_idx_min and reg_hit
            // set o_finish when reg_tri_cnt_out == 0
            if (reader_ready && !reg_tri_cnt_in) begin
                reg_tri_cnt_in <= reg_tri_cnt_in-1;
                reader_en <= 1'b1;
            end
            if (inter_valid && !o_finish) begin
                if (hit && t < reg_t_min) begin
                    reg_t_min <= t;
                    reg_tri_idx_min <= reg_tri_cnt_out;
                    reg_hit <= 1'b1;
                end

                if (reg_tri_cnt_out) begin
                    reg_tri_cnt_out <= reg_tri_cnt_out-1;
                end else begin
                    o_finish <= 1'b1;
                end
            end
        end
    end

    assign o_hit = reg_hit;
    assign o_t = reg_t_min;
    assign o_tri_index = reg_tri_idx_min;

endmodule: tri_insector
