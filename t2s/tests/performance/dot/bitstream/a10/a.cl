/*OpenCL C x86-64-linux-avx-avx2-debug-f16c-fma-intel_fpga-opencl-sse41*/
#pragma OPENCL FP_CONTRACT ON
#define float_from_bits(x) as_float(x)
inline float nan_f32() { return NAN; }
inline float neg_inf_f32() { return -INFINITY; }
inline float inf_f32() { return INFINITY; }
inline bool is_nan_f32(float x) {return isnan(x); }
inline bool is_inf_f32(float x) {return isinf(x); }
inline bool is_finite_f32(float x) {return isfinite(x); }
#define sqrt_f32 sqrt 
#define sin_f32 sin 
#define cos_f32 cos 
#define exp_f32 exp 
#define log_f32 log 
#define abs_f32 fabs 
#define floor_f32 floor 
#define ceil_f32 ceil 
#define round_f32 round 
#define trunc_f32 trunc 
#define pow_f32 pow
#define asin_f32 asin 
#define acos_f32 acos 
#define tan_f32 tan 
#define atan_f32 atan 
#define atan2_f32 atan2
#define sinh_f32 sinh 
#define asinh_f32 asinh 
#define cosh_f32 cosh 
#define acosh_f32 acosh 
#define tanh_f32 tanh 
#define atanh_f32 atanh 
#define fast_inverse_f32 native_recip 
#define fast_inverse_sqrt_f32 native_rsqrt 
#define __address_space___shared __local


// ll suffix in OpenCL is reserved for 128-bit integers.
#if defined __OPENCL_VERSION__
#define ADD_INT64_T_SUFFIX(x) x##l
#define ADD_UINT64_T_SUFFIX(x) x##ul
// HLSL doesn't have any suffixes.
#elif defined HLSL_VERSION
#define ADD_INT64_T_SUFFIX(x) x
#define ADD_UINT64_T_SUFFIX(x) x
#else
#define ADD_INT64_T_SUFFIX(x) x##ll
#define ADD_UINT64_T_SUFFIX(x) x##ull
#endif
#pragma OPENCL EXTENSION cl_intel_channels : enable
typedef union {
float16 v[1];
float s[16];
} _xLoader__1_channel_array_t;
channel _xLoader__1_channel_array_t _xLoader__1_channel __attribute__((depth(256))) ;
typedef union {
float16 v[1];
float s[16];
} _yLoader__1_channel_array_t;
channel _yLoader__1_channel_array_t _yLoader__1_channel __attribute__((depth(256))) ;
channel float _Out_channel __attribute__((depth(256))) ;
// Address spaces for kernel_xLoader_1
#define __address_space__xSerializer__1 __global
__kernel void kernel_xLoader_1(
 const int _X_extent_0,
 const int _X_extent_1,
 __address_space__xSerializer__1 const float *restrict _xSerializer__1)
{
 int _addr_temp = 0;
 for (int _xLoader__1_s0_b = 0; _xLoader__1_s0_b < 0 + _X_extent_1; _xLoader__1_s0_b++)
 {
  int _0 = _X_extent_0 >> 4;
  for (int _xLoader__1_s0_k = 0; _xLoader__1_s0_k < 0 + _0; _xLoader__1_s0_k++)
  {
   _xLoader__1_channel_array_t _temp;
   int _1 = _addr_temp;
   int _2 = _1 * 16;
   _temp.v[0] = vload16(0, (__address_space__xSerializer__1 float*)(_xSerializer__1 + _2));
   write_channel_intel(_xLoader__1_channel, _temp);
   _addr_temp += 1;
  } // for _xLoader__1_s0_k
 } // for _xLoader__1_s0_b
} // kernel kernel_xLoader_1
#undef __address_space__xSerializer__1
// Address spaces for kernel_yLoader_1
#define __address_space__ySerializer__1 __global
__kernel void kernel_yLoader_1(
 const int _X_extent_0,
 const int _X_extent_1,
 __address_space__ySerializer__1 const float *restrict _ySerializer__1)
{
 int _addr_temp = 0;
 for (int _yLoader__1_s0_b = 0; _yLoader__1_s0_b < 0 + _X_extent_1; _yLoader__1_s0_b++)
 {
  int _8 = _X_extent_0 >> 4;
  for (int _yLoader__1_s0_k = 0; _yLoader__1_s0_k < 0 + _8; _yLoader__1_s0_k++)
  {
   _yLoader__1_channel_array_t _temp;
   int _1 = _addr_temp;
   int _2 = _1 * 16;
   _temp.v[0] = vload16(0, (__address_space__ySerializer__1 float*)(_ySerializer__1 + _2));
   write_channel_intel(_yLoader__1_channel, _temp);
   _addr_temp += 1;
  } // for _yLoader__1_s0_k
 } // for _yLoader__1_s0_b
} // kernel kernel_yLoader_1
#undef __address_space__ySerializer__1
// Address spaces for kernel_Z
__kernel void kernel_Z(
 const int _X_extent_0,
 const int _X_extent_1)
{
 _yLoader__1_channel_array_t _yLoader__1_channel_array;
 _xLoader__1_channel_array_t _xLoader__1_channel_array;
 for (int _uX_s0_b = 0; _uX_s0_b < 0 + _X_extent_1; _uX_s0_b++)
 {
  int _16 = _X_extent_0 >> 4;
  float _k_accumulator = 0;
  for (int _uX_s0_k = 0; _uX_s0_k < 0 + _16; _uX_s0_k++)
  {
   _yLoader__1_channel_array_t __17 = read_channel_intel(_yLoader__1_channel);
   _yLoader__1_channel_array = __17;
   _xLoader__1_channel_array_t __18 = read_channel_intel(_xLoader__1_channel);
   _xLoader__1_channel_array = __18;
   float _kk_accumulator = 0;
   #pragma unroll
   for (int _uX_s0_kk = 0; _uX_s0_kk < 0 + 16; _uX_s0_kk++)
   {
    float __19 = _xLoader__1_channel_array.s[_uX_s0_kk];
    float __20 = _yLoader__1_channel_array.s[_uX_s0_kk];
    float _32 = __19 * __20;
    float _33 = _kk_accumulator + _32;
    _kk_accumulator = _33;
   } // for _uX_s0_kk
   _k_accumulator += _kk_accumulator;
  } // for _uX_s0_k
  write_channel_intel(_Out_channel, _k_accumulator);
 } // for _uX_s0_b
} // kernel kernel_Z
// Address spaces for kernel_unloader_1
#define __address_space__unloader__1_mem_channel __global
__kernel void kernel_unloader_1(
 const int _X_extent_1,
 __address_space__unloader__1_mem_channel float *restrict _unloader__1_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 for (int _unloader__1_s0_b = 0; _unloader__1_s0_b < 0 + _X_extent_1; _unloader__1_s0_b++)
 {
  float __59 = read_channel_intel(_Out_channel);
  int _60 = _addr_temp;
  _unloader__1_mem_channel[_60] = __59;
  int _61 = _addr_temp;
  int _62 = _61 + 1;
  _addr_temp = _62;
 } // for _unloader__1_s0_b
} // kernel kernel_unloader_1
#undef __address_space__unloader__1_mem_channel

