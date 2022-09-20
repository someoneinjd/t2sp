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
float16 v[2];
float s[32];
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(256))) ;
channel float _xLoader_channel __attribute__((depth(256))) ;
channel float _xFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s[32]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(256))) ;
// Address spaces for kernel_aLoader
#define __address_space__A_serializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__A_serializer const float *restrict _A_serializer_1,
 __address_space__A_serializer const float *restrict _A_serializer_2)
{
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 10;
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
 int _15 = _A_extent_1 >> 10;
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
 int _xFeeder_cycle_temp;
 float __attribute__((memory, numbanks(32), singlepump, numwriteports(1), numreadports(1))) _xFeeder_buffer__0_ibuffer[2][32];
 _xFeeder_cycle_temp = 992;
 int _26 = _A_extent_1 >> 10;
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
  bool _35 = _34 < _28;
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
  bool _46 = _45 <= _28;
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
 float _uZ_shreg[32][32];
 // produce uX
 float _uX_shreg;
 float _uZ_temp[32];
 // produce uA
 float _uA_shreg[32];
 int _217 = _A_extent_1 >> 10;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _217; _uA_s0_i++)
 {
  int _218 = _A_extent_0 >> 5;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _218; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 1024; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 32; _dummy_s0_iii++)
    {
     float _220 = _uZ_shreg[31][_dummy_s0_iii];
     _uZ_temp[_dummy_s0_iii] = _220;
     #pragma unroll
     for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 31; _dummy__1_s0_l0++)
     {
      int _221 = 31 - _dummy__1_s0_l0;
      int _222 = 30 - _dummy__1_s0_l0;
      float _224 = _uZ_shreg[_222][_dummy_s0_iii];
      _uZ_shreg[_221][_dummy_s0_iii] = _224;
      (void)_224;
     } // for _dummy__1_s0_l0
     float _225 = _uZ_temp[_dummy_s0_iii];
     _uZ_shreg[0][_dummy_s0_iii] = _225;
     (void)_225;
    } // for _dummy_s0_iii
    bool _V_channel_temp;
    _V_channel_temp = 0;
    _aLoader_channel_array = read_channel_intel(_aLoader_channel);
    float _xFeeder_channel_array = read_channel_intel(_xFeeder_channel);
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 32; _uA_s0_iii++)
    {
     float __227 = _aLoader_channel_array.s[_uA_s0_iii];
     _uA_shreg[_uA_s0_iii] = __227;
     (void)__227;
     float _228;
     bool _229 = _uA_s0_iii == 0;
     if (_229)
     {
      float __230 = _xFeeder_channel_array;
      _228 = __230;
     } // if _229
     else
     {
      float _232 = _uX_shreg;
      _228 = _232;
     } // if _229 else
     float _233 = _228;
     _uX_shreg = _233;
     (void)_233;
     float _235 = _uX_shreg;
     float _236 = __fpga_reg(__fpga_reg(_235));
     _uX_shreg = _236;
     (void)_236;
     float _237;
     int _238 = _uA_s0_kk_ii >> 5;
     bool _239 = _238 == 0;
     bool _240 = _uA_s0_k == 0;
     bool _241 = _239 && _240;
     if (_241)
     {
      float _242 = float_from_bits(0 /* 0 */);
      _237 = _242;
     } // if _241
     else
     {
      float _244 = _uZ_shreg[0][_uA_s0_iii];
      _237 = _244;
     } // if _241 else
     float _245 = _237;
     float _247 = _uA_shreg[_uA_s0_iii];
     float _249 = _uX_shreg;
     float _250 = _247 * _249;
     float _251 = _245 + _250;
     _uZ_shreg[0][_uA_s0_iii] = _251;
     (void)_251;
     int _252 = _uA_s0_kk_ii >> 5;
     bool _253 = _252 == 31;
     int _254 = _A_extent_0 >> 5;
     int _255 = _254 + -1;
     bool _256 = _uA_s0_k == _255;
     bool _257 = _253 && _256;
     if (_257)
     {
      float _259 = _uZ_shreg[0][_uA_s0_iii];
      _V_channel_array.s[_uA_s0_iii] = _259;
      (void)_uA_s0_iii;
      _V_channel_temp = 1;
     } // if _257
    } // for _uA_s0_iii
    bool _260 = _V_channel_temp;
    if (_260)
    {
     write_channel_intel(_V_channel, _V_channel_array);
     (void)_V_channel_array;
    } // if _260
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
 int _261 = _A_extent_1 >> 10;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _261; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
  {
   _V_channel_array_t __262 = read_channel_intel(_V_channel);
   _V_channel_array = __262;
   #pragma unroll
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 32; _unloader_s0_iii++)
   {
    float __263 = _V_channel_array.s[_unloader_s0_iii];
    int _264 = _addr_temp;
    _unloader_mem_channel[_264] = __263;
    int _265 = _addr_temp;
    int _266 = _265 + 1;
    _addr_temp = _266;
   } // for _unloader_s0_iii
  } // for _unloader_s0_ii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

