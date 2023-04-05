/*OpenCL C x86-64-linux-avx-avx2-enable_synthesis-f16c-fma-intel_fpga-opencl-sse41*/
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
float16 v[4];
float s[64];
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(256))) ;
channel float _xLoader_channel __attribute__((depth(256))) ;
channel float _xFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s[64]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(256))) ;
// Address spaces for kernel_aLoader
#define __address_space__A_serializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__A_serializer const float *restrict _A_serializer_1,
 __address_space__A_serializer const float *restrict _A_serializer_2,
 __address_space__A_serializer const float *restrict _A_serializer_3,
 __address_space__A_serializer const float *restrict _A_serializer_4)
{
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 11;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _0; _aLoader_s0_i++)
 {
  int _1 = _A_extent_0 >> 5;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _1; _aLoader_s0_k++)
  {
   for (int _aLoader_s0_kk_ii = 0; _aLoader_s0_kk_ii < 0 + 1024; _aLoader_s0_kk_ii++)
   {
    int _1 = _addr_temp;
    int _2 = _1 * 16;
    _aLoader_channel_array_t _temp;
    _temp.v[0] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_1 + _2));
    _temp.v[1] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_2 + _2));
    _temp.v[2] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_3 + _2));
    _temp.v[3] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_4 + _2));
    write_channel_intel(_aLoader_channel, _temp);
    _addr_temp += 1;
   } // for _aLoader_s0_kk_ii
  } // for _aLoader_s0_k
 } // for _aLoader_s0_i
} // kernel kernel_aLoader
#undef __address_space__A_serializer
// Address spaces for kernel_xLoader
#define __address_space__X_serializer_mem_channel __global
__kernel void kernel_xLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__X_serializer_mem_channel const float *restrict _X_serializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _15 = _A_extent_1 >> 11;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _15; _xLoader_s0_i++)
 {
  int _16 = _A_extent_0 >> 5;
  for (int _xLoader_s0_k = 0; _xLoader_s0_k < 0 + _16; _xLoader_s0_k++)
  {
   for (int _xLoader_s0_kk = 0; _xLoader_s0_kk < 0 + 32; _xLoader_s0_kk++)
   {
    int _17 = _addr_temp;
    int _18 = _A_extent_0 >> 5;
    int _19 = _18 * 32;
    int _20 = _17 % _19;
    float _21 = _X_serializer_mem_channel[_20];
    write_channel_intel(_xLoader_channel, _21);
    (void)_21;
    int _22 = _17 + 1;
    _addr_temp = _22;
   } // for _xLoader_s0_kk
  } // for _xLoader_s0_k
 } // for _xLoader_s0_i
} // kernel kernel_xLoader
#undef __address_space__X_serializer_mem_channel
// Address spaces for kernel_xFeeder
__kernel void kernel_xFeeder(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _23 = _A_extent_1 >> 11;
 int _24 = _A_extent_0 >> 5;
 int _25 = _23 * _24;
 int _xFeeder_cycle_temp;
 float __attribute__((memory, numbanks(32), singlepump, numwriteports(1), numreadports(1))) _xFeeder_buffer__0_ibuffer[2][32];
 _xFeeder_cycle_temp = 992;
 int _26 = _A_extent_1 >> 11;
 int _27 = _A_extent_0 >> 5;
 int _28 = _26 * _27;
 int _29 = _28 * 1024;
 int _30 = _29 + 1024;
 for (int _xFeeder_s0_outermost_loop = 0; _xFeeder_s0_outermost_loop < 0 + _30; _xFeeder_s0_outermost_loop++)
 {
  int _31 = _xFeeder_cycle_temp;
  int _32 = _31 & 1023;
  bool _33 = 992 <= _32;
  int _34 = _31 >> 10;
  bool _35 = _34 < _25;
  bool _36 = _33 && _35;
  if (_36)
  {
   float __37 = read_channel_intel(_xLoader_channel);
   int _38 = _xFeeder_cycle_temp;
   int _39 = _38 >> 10;
   int _40 = _39 & 1;
   bool _41 = (bool)(_40);
   int _42 = _38 & 1023;
   int _43 = _42 & 31;
   _xFeeder_buffer__0_ibuffer[_41][_43] = __37;
  } // if _36
  int _44 = _xFeeder_cycle_temp;
  int _45 = _44 >> 10;
  bool _46 = _45 <= _25;
  bool _47 = 1023 < _44;
  bool _48 = _46 && _47;
  if (_48)
  {
   int _49 = _xFeeder_cycle_temp;
   int _50 = _49 >> 10;
   int _51 = _50 & 1;
   bool _52 = (bool)(_51);
   bool _53 = !(_52);
   int _54 = _49 >> 5;
   int _55 = _54 & 31;
   float _56 = _xFeeder_buffer__0_ibuffer[_53][_55];
   write_channel_intel(_xFeeder_channel, _56);
   (void)_56;
  } // if _48
  int _60 = _xFeeder_cycle_temp;
  int _61 = _60 + 1;
  _xFeeder_cycle_temp = _61;
 } // for _xFeeder_s0_outermost_loop
} // kernel kernel_xFeeder
// Address spaces for kernel_V
__kernel void kernel_V(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _aLoader_channel_array_t _aLoader_channel_array;
 _V_channel_array_t _V_channel_array;
 // produce uZ
 float _uZ_shreg[32][64];
 // produce uX
 float _uX_shreg;
 float _uZ_temp[64];
 // produce uA
 float _uA_shreg[64];
 int _377 = _A_extent_1 >> 11;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _377; _uA_s0_i++)
 {
  int _378 = _A_extent_0 >> 5;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _378; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 1024; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 64; _dummy_s0_iii++)
    {
     float _380 = _uZ_shreg[31][_dummy_s0_iii];
     _uZ_temp[_dummy_s0_iii] = _380;
     #pragma unroll
     for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 31; _dummy__1_s0_l0++)
     {
      int _381 = 31 - _dummy__1_s0_l0;
      int _382 = 30 - _dummy__1_s0_l0;
      float _384 = _uZ_shreg[_382][_dummy_s0_iii];
      _uZ_shreg[_381][_dummy_s0_iii] = _384;
      (void)_384;
     } // for _dummy__1_s0_l0
     float _385 = _uZ_temp[_dummy_s0_iii];
     _uZ_shreg[0][_dummy_s0_iii] = _385;
     (void)_385;
    } // for _dummy_s0_iii
    bool _V_channel_temp;
    _V_channel_temp = 0;
    _aLoader_channel_array = read_channel_intel(_aLoader_channel);
    float _xFeeder_channel_array = read_channel_intel(_xFeeder_channel);
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 64; _uA_s0_iii++)
    {
     float __387 = _aLoader_channel_array.s[_uA_s0_iii];
     _uA_shreg[_uA_s0_iii] = __387;
     (void)__387;
     float _388;
     bool _389 = _uA_s0_iii == 0;
     if (_389)
     {
      float __390 = _xFeeder_channel_array;
      _388 = __390;
     } // if _389
     else
     {
      float _392 = _uX_shreg;
      _388 = _392;
     } // if _389 else
     float _393 = _388;
     _uX_shreg = _393;
     (void)_393;
     float _395 = _uX_shreg;
     float _396 = __fpga_reg(__fpga_reg(_395));
     _uX_shreg = _396;
     (void)_396;
     float _397;
     int _398 = _uA_s0_kk_ii >> 5;
     bool _399 = _398 == 0;
     bool _400 = _uA_s0_k == 0;
     bool _401 = _399 && _400;
     if (_401)
     {
      float _402 = float_from_bits(0 /* 0 */);
      _397 = _402;
     } // if _401
     else
     {
      float _404 = _uZ_shreg[0][_uA_s0_iii];
      _397 = _404;
     } // if _401 else
     float _405 = _397;
     float _407 = _uA_shreg[_uA_s0_iii];
     float _409 = _uX_shreg;
     float _410 = _407 * _409;
     float _411 = _405 + _410;
     _uZ_shreg[0][_uA_s0_iii] = _411;
     (void)_411;
     int _412 = _uA_s0_kk_ii >> 5;
     bool _413 = _412 == 31;
     int _414 = _A_extent_0 >> 5;
     int _415 = _414 + -1;
     bool _416 = _uA_s0_k == _415;
     bool _417 = _413 && _416;
     if (_417)
     {
      float _419 = _uZ_shreg[0][_uA_s0_iii];
      _V_channel_array.s[_uA_s0_iii] = _419;
      (void)_uA_s0_iii;
      _V_channel_temp = 1;
     } // if _417
    } // for _uA_s0_iii
    bool _420 = _V_channel_temp;
    if (_420)
    {
     write_channel_intel(_V_channel, _V_channel_array);
     (void)_V_channel_array;
    } // if _420
   } // for _uA_s0_kk_ii
  } // for _uA_s0_k
 } // for _uA_s0_i
} // kernel kernel_V
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 _V_channel_array_t _V_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _421 = _A_extent_1 >> 11;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _421; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
  {
   _V_channel_array_t __422 = read_channel_intel(_V_channel);
   _V_channel_array = __422;
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 64; _unloader_s0_iii++)
   {
    float __423 = _V_channel_array.s[_unloader_s0_iii];
    int _424 = _addr_temp;
    _unloader_mem_channel[_424] = __423;
    int _425 = _addr_temp;
    int _426 = _425 + 1;
    _addr_temp = _426;
   } // for _unloader_s0_iii
  } // for _unloader_s0_ii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

