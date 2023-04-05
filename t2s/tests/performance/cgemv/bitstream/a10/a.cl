/*OpenCL C x86-64-linux-avx-avx2-avx512-avx512_skylake-cm-enable_synthesis-f16c-fma-intel_fpga-opencl-sse41*/
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
typedef float2 complex;
typedef union { float4 t; float2 s[2]; } complex2;
typedef union { float8 t; float2 s[4]; } complex4;
typedef union { float16 t; float2 s[8]; } complex8;
inline float2 conjugate(float2 x) {return (float2)(x.s0, -x.s1); }
inline float2 sqrt_c32(float2 x) {return (float2)(sqrt_f32(x.s0), 0.0f); }
inline float2 fast_inverse_c32(float2 x) {return (float2)(fast_inverse_f32(x.s0), 0.0f); }
inline float2 fast_inverse_sqrt_c32(float2 x) {return (float2)(fast_inverse_sqrt_f32(x.s0), 0.0f); }
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
    complex s[16]; 
    float16 v[2]; 
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(256))) ;
channel complex _xLoader_channel __attribute__((depth(256))) ;
channel complex _xFeeder_channel __attribute__((depth(256))) ;
typedef struct { complex s[16]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(256))) ;
// Address spaces for kernel_aLoader
#define __address_space__A_serializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__A_serializer const complex *restrict _A_serializer_1,
 __address_space__A_serializer const complex *restrict _A_serializer_2)
{
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 9;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _0; _aLoader_s0_i++)
 {
  int _1 = _A_extent_0 >> 5;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _1; _aLoader_s0_k++)
  {
   for (int _aLoader_s0_kk_ii = 0; _aLoader_s0_kk_ii < 0 + 1024; _aLoader_s0_kk_ii++)
   {
    int _1 = _addr_temp;
    int _2 = _1 * 8;
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
 __address_space__X_serializer_mem_channel const complex *restrict _X_serializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _15 = _A_extent_1 >> 9;
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
    complex _21 = _X_serializer_mem_channel[_20];
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
 complex __attribute__((memory, numbanks(32), singlepump, numwriteports(1), numreadports(1))) _xFeeder_buffer__0_ibuffer[2][32];
 _xFeeder_cycle_temp = 992;
 int _26 = _A_extent_1 >> 9;
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
   complex __37 = read_channel_intel(_xLoader_channel);
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
   complex _56 = _xFeeder_buffer__0_ibuffer[_53][_55];
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
 complex _uZ_shreg[32][16];
 // produce uX
 complex _uX_shreg;
 complex _uZ_temp[16];
 // produce uA
 complex _uA_shreg[16];
 int _132 = _A_extent_1 >> 9;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _132; _uA_s0_i++)
 {
  int _133 = _A_extent_0 >> 5;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _133; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 1024; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 16; _dummy_s0_iii++)
    {
     complex _135 = _uZ_shreg[31][_dummy_s0_iii];
     _uZ_temp[_dummy_s0_iii] = _135;
     #pragma unroll
     for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 31; _dummy__1_s0_l0++)
     {
      int _136 = 31 - _dummy__1_s0_l0;
      int _137 = 30 - _dummy__1_s0_l0;
      complex _139 = _uZ_shreg[_137][_dummy_s0_iii];
      _uZ_shreg[_136][_dummy_s0_iii] = _139;
      (void)_139;
     } // for _dummy__1_s0_l0
     complex _140 = _uZ_temp[_dummy_s0_iii];
     _uZ_shreg[0][_dummy_s0_iii] = _140;
     (void)_140;
    } // for _dummy_s0_iii
    bool _V_channel_temp;
    _V_channel_temp = 0;
    _aLoader_channel_array = read_channel_intel(_aLoader_channel);
    complex _xFeeder_channel_array = read_channel_intel(_xFeeder_channel);
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 16; _uA_s0_iii++)
    {
     complex __142 = _aLoader_channel_array.s[_uA_s0_iii];
     _uA_shreg[_uA_s0_iii] = __142;
     (void)__142;
     complex _143;
     bool _144 = _uA_s0_iii == 0;
     if (_144)
     {
      complex __145 = _xFeeder_channel_array;
      _143 = __145;
     } // if _144
     else
     {
      complex _147 = _uX_shreg;
      _143 = _147;
     } // if _144 else
     complex _148 = _143;
     _uX_shreg = _148;
     (void)_148;
     complex _150 = _uX_shreg;
     complex _151 = __fpga_reg(__fpga_reg(_150));
     _uX_shreg = _151;
     (void)_151;
     complex _152;
     int _153 = _uA_s0_kk_ii >> 5;
     bool _154 = _153 == 0;
     bool _155 = _uA_s0_k == 0;
     bool _156 = _154 && _155;
     if (_156)
     {
      complex _157 = (complex)(0.000000f, 0.000000f);
      _152 = _157;
     } // if _156
     else
     {
      complex _159 = _uZ_shreg[0][_uA_s0_iii];
      _152 = _159;
     } // if _156 else
     complex _160 = _152;
     complex _162 = _uA_shreg[_uA_s0_iii];
     complex _164 = _uX_shreg;
     complex _165 = (float2)(_162.s0 * _164.s0 - _162.s1 * _164.s1, _162.s0 * _164.s1 + _162.s1 * _164.s0);
     complex _166 = _160 + _165;
     _uZ_shreg[0][_uA_s0_iii] = _166;
     (void)_166;
     int _167 = _uA_s0_kk_ii >> 5;
     bool _168 = _167 == 31;
     int _169 = _A_extent_0 >> 5;
     int _170 = _169 + -1;
     bool _171 = _uA_s0_k == _170;
     bool _172 = _168 && _171;
     if (_172)
     {
      complex _174 = _uZ_shreg[0][_uA_s0_iii];
      _V_channel_array.s[_uA_s0_iii] = _174;
      (void)_uA_s0_iii;
      _V_channel_temp = 1;
     } // if _172
    } // for _uA_s0_iii
    bool _175 = _V_channel_temp;
    if (_175)
    {
     write_channel_intel(_V_channel, _V_channel_array);
     (void)_V_channel_array;
    } // if _175
   } // for _uA_s0_kk_ii
  } // for _uA_s0_k
 } // for _uA_s0_i
} // kernel kernel_V
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 __address_space__unloader_mem_channel complex *restrict _unloader_mem_channel)
{
 _V_channel_array_t _V_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _176 = _A_extent_1 >> 9;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _176; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
  {
   _V_channel_array_t __177 = read_channel_intel(_V_channel);
   _V_channel_array = __177;
   (void)__177;
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 16; _unloader_s0_iii++)
   {
    complex __178 = _V_channel_array.s[_unloader_s0_iii];
    int _179 = _addr_temp;
    _unloader_mem_channel[_179] = __178;
    int _180 = _addr_temp;
    int _181 = _180 + 1;
    _addr_temp = _181;
   } // for _unloader_s0_iii
  } // for _unloader_s0_ii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

