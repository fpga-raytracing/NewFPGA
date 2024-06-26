module avalon_sdr_write #(parameter MAX_NWRITE = 64)
(
    input  logic         clk,
    input  logic         reset,

    // AVMM interface
    output logic         avm_m0_write,
    output logic [15:0]  avm_m0_address,
    input  logic [15:0]  avm_m0_writedata,
    input  logic         avm_m0_waitrequest,

    // external interface
    input  logic [31:0]  sdr_baseaddr,
    input  logic [29:0]  sdr_nelems,
    input  logic [32*MAX_NWRITE-1:0] sdr_writedata,
    input  logic         sdr_writestart,
    output logic        sdr_writeend
);

    localparam INIT = 3'd0,          
                  WRITE_ASSERT = 3'd1,
                  WRITE_WAIT = 3'd2;

    logic [2:0] cur_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) 
            cur_state <= INIT;
        else 
            cur_state <= next_state;
    end

    wire reg_reset;
    assign reg_reset = reset || (cur_state == INIT);

    reg offset_en;
    reg [30:0] offset;

    always_ff @(posedge clk) begin
        if (reg_reset)
            offset <= 31'd0;
        else if (offset_en)
            offset++;
        else 
            offset <= offset;
    end

    wire [31:0] offset_addr;
    assign offset_addr = sdr_baseaddr + (2*offset);

    wire [30:0] max_offset;
    assign max_offset = 2*sdr_nelems - 1;

    reg [30:0] wroffset;

    always_ff @(posedge clk) begin
        if (reg_reset)
            wroffset <= 'b0;
        else if (avm_m0_waitrequest) begin
            wroffset <= wroffset + 31'd1;
        end
        else begin
            wroffset <= wroffset;
        end
    end

    always @* begin
        avm_m0_write <= 1'b0;
        avm_m0_address <= 32'd0;
        sdr_writeend <= 1'b0;
        offset_en <= 1'b0;
    
        case (cur_state)
            INIT: 
            begin
                if (sdr_writestart)
                    next_state <= WRITE_ASSERT;
                else 
                    next_state <= cur_state;
            end
        
            WRITE_ASSERT: 
            begin
                avm_m0_write <= 1'b1;
                avm_m0_address <= offset_addr;
                avm_m0_writedata <= sdr_writedata[16*wroffset +: 16];
                offset_en <= !avm_m0_waitrequest;
            
                if (!avm_m0_waitrequest && offset >= max_offset)
                    next_state <= WRITE_WAIT;
                else 
                    next_state <= WRITE_ASSERT;
            end
        
            WRITE_WAIT:
            begin
                if (wroffset > max_offset) begin
                    sdr_writeend <= 1'b1;
                    next_state <= INIT;
                end
                else 
                    next_state <= WRITE_WAIT;           
            end
        endcase
    end
     
endmodule

module avalon_sdr_read #(parameter MAX_NREAD = 64)
(
    input  logic         clk,
    input  logic         reset,

    // AVMM interface
    output logic         avm_m0_read,
    output logic [15:0]  avm_m0_address,
    input  logic [15:0]  avm_m0_readdata,
    input  logic         avm_m0_readdatavalid,
    input  logic         avm_m0_waitrequest,

    // external interface
    input  logic [31:0]  sdr_baseaddr,
    input  logic [29:0]  sdr_nelems,
    output logic [32*MAX_NREAD-1:0] sdr_readdata,
    input  logic         sdr_readstart,
    output logic        sdr_readend
);

    localparam INIT = 3'd0,          
                  READ_ASSERT = 3'd1,
                  READ_WAIT = 3'd2;

    logic [2:0] cur_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) 
            cur_state <= INIT;
        else 
            cur_state <= next_state;
    end

    wire reg_reset;
    assign reg_reset = reset || (cur_state == INIT);

    reg offset_en;
    reg [30:0] offset;

    always_ff @(posedge clk) begin
        if (reg_reset)
            offset <= 31'd0;
        else if (offset_en)
            offset++;
        else 
            offset <= offset;
    end

    wire [31:0] offset_addr;
    assign offset_addr = sdr_baseaddr + (2*offset);

    wire [30:0] max_offset;
    assign max_offset = 2*sdr_nelems - 1;

    reg [30:0] rdoffset;
    reg [32*MAX_NREAD-1:0] readdata;

    always_ff @(posedge clk) begin
        if (reg_reset)
            rdoffset <= 'b0;
        else if (avm_m0_readdatavalid) begin
            readdata[16*rdoffset +: 16] <= avm_m0_readdata;
            rdoffset <= rdoffset + 31'd1;
        end
        else begin
            readdata <= readdata;
            rdoffset <= rdoffset;
        end
    end

    assign sdr_readdata = readdata;

    always @* begin
        avm_m0_read <= 1'b0;
        avm_m0_address <= 32'd0;
        sdr_readend <= 1'b0;
        offset_en <= 1'b0;
    
        case (cur_state)
            INIT: 
            begin
                if (sdr_readstart)
                    next_state <= READ_ASSERT;
                else 
                    next_state <= cur_state;
            end
        
            READ_ASSERT: 
            begin
                avm_m0_read <= 1'b1;
                avm_m0_address <= offset_addr;
                offset_en <= !avm_m0_waitrequest;
            
                if (!avm_m0_waitrequest && offset >= max_offset)
                    next_state <= READ_WAIT;
                else 
                    next_state <= READ_ASSERT;
            end
        
            READ_WAIT:
            begin
                if (rdoffset > max_offset) begin
                    sdr_readend <= 1'b1;
                    next_state <= INIT;
                end
                else 
                    next_state <= READ_WAIT;           
            end
        endcase
    end
     
endmodule