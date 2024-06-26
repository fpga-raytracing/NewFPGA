#pragma once

// compiling for Cyclone V
#pragma PART "5CSEMA5F31C6"

#include "intN_t.h"
#include "uintN_t.h"

#define STR(s) #s
#define XSTR(s) STR(s)

#define TRIS_ELEM_SIZE 3
#define VERTS_ELEM_SIZE 3
#define MATS_ELEM_SIZE 13
#define LIGHTS_ELEM_SIZE 6

// Max words readable/writable at a time.
// This is a pipelinec limitation, avalon_sdr technically 
// allows for much larger sizes (upto 2048 words, not bits).
#define MAX_NREAD 64
#define MAX_NWRITE 64
#define MAX_NREAD_BITS 2048
#define MAX_NWRITE_BITS 2048

#define FIP_POINT_5 0x00008000
#define FIP_ALMOST_ONE 0x0000ffff // largest below 1
#define FIP_ONE 0x00010000 // 1
#define FIP_MIN (-2147483647 - 1) // -32768.0 (min)
#define FIP_MAX 2147483647 // 32767.99998 (max)

#define ABS(x) (((x) > 0) ? (x) : -(x))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))


#define AVSDR_RDDATA_T uint2048_t
#define AVSDR_WRDATA_T uint2048_t

// Input from SDRAM controller in Qsys
typedef struct avmm_in
{
    uint1_t reset; 
    uint16_t readdata;
    uint1_t readdatavalid;
    uint1_t waitrequest;
} 
avmm_in;

// Output to SDRAM controller in Qsys
typedef struct avmm_out
{
    uint1_t read;
    uint1_t write;
    uint32_t address;
    uint2_t byteenable;
    uint16_t writedata;
} 
avmm_out;

typedef struct avsdr_in
{
    avmm_in av;
    uint1_t readstart;
    uint1_t writestart;
    uint32_t baseaddr;
    uint30_t nelems;
    AVSDR_WRDATA_T writedata;
}
avsdr_in;

typedef struct avsdr_out
{
    avmm_out av;
    uint1_t readend;
    uint1_t writeend;
    AVSDR_RDDATA_T readdata;
}
avsdr_out;



typedef struct avsdr_out2
{
    uint1_t readstart;
    uint1_t writestart;
    uint32_t baseaddr;
    uint30_t nelems;
    AVSDR_WRDATA_T writedata;
}
avsdr_out2;

typedef struct avsdr_in2
{
    uint1_t readend;
    uint1_t writeend;
    AVSDR_RDDATA_T readdata;
}
avsdr_in2;

typedef struct Triangle_t
{
    int32_t v1[3];
    int32_t v2[3];
    int32_t v3[3];

} Triangle_t;
// ray intersect tri out

typedef struct bv_t
{
    int32_t cmin[3];
    int32_t cmax[3];
    int32_t ntris;
} bv_t;

// 3d vector structs

// 3x1
typedef struct Vct_3d_t {
    int32_t var[3];
} Vct_3d_t;

// 3x2
typedef struct Ray_t {
    int32_t origin[3];
    int32_t dir[3];
} Ray_t;

typedef struct Light_t {
    int32_t src[3];
    int32_t color[3];
} Light_t;

// 3x3
typedef struct Vert_t {
    int32_t v0[3];
    int32_t v1[3];
    int32_t v2[3];
} Vert_t;

typedef struct Material_t {
    int32_t ka[3];
    int32_t kd[3];
    int32_t ks[3];
} Material_t;

// autogen, see wiki/Automatically-Generated-Functionality
#include "bv_array_N_t.h"
