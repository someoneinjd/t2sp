/*OpenCL C x86-64-linux-avx-avx2-avx512-avx512_skylake-enable_synthesis-f16c-fma-intel_fpga-opencl-sse41*/
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
} _ALoader_channel_array_t;
channel _ALoader_channel_array_t _ALoader_channel __attribute__((depth(256))) ;
channel float _XLoader_channel __attribute__((depth(256))) ;
channel float _XFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s[32]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(256))) ;
// Address spaces for kernel_ALoader
#define __address_space__ASerializer __global
__kernel void kernel_ALoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__ASerializer const float *restrict _A_serializer_1,
 __address_space__ASerializer const float *restrict _A_serializer_2)
{
 _ALoader_channel_array_t _ALoader_channel_array;
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 8;
 int _1 = _A_extent_0 >> 8;
 int _2 = (2 * _1 - _0 + 1) * _0 / 2;
 for (int _ALoader_s0_i_k = 0; _ALoader_s0_i_k < 0 + _2; _ALoader_s0_i_k++)
 {
   #pragma loop_coalesce 2
   for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 256; _ALoader_s0_kk++)
   {
    for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 8; _ALoader_s0_ii++)
    {
      int _3 = _addr_temp * 16;
      _ALoader_channel_array.v[0] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_1 + _3));
      _ALoader_channel_array.v[1] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_2 + _3));
      write_channel_intel(_ALoader_channel, _ALoader_channel_array);
      _addr_temp += 1;
    } // for _ALoader_s0_ii
   } // for _ALoader_s0_kk
 } // for _ALoader_s0_i_k
} // kernel kernel_ALoader
#undef __address_space__ASerializer
// Address spaces for kernel_XLoader
#define __address_space__XSerializer_mem_channel __global
__kernel void kernel_XLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__XSerializer_mem_channel const float *restrict _XSerializer_mem_channel)
{
 int _14 = _A_extent_1 >> 8;
 int _15 = _14 + 1;
 for (int _XLoader_s0_i = 0; _XLoader_s0_i < 0 + _15; _XLoader_s0_i++)
 {
  int _16 = _A_extent_0 >> 8;
  int _17 = _16 - _XLoader_s0_i + ((_XLoader_s0_i < _14) ? 0 : 1);
  for (int _XLoader_s0_k = _XLoader_s0_i; _XLoader_s0_k < _XLoader_s0_i + _17; _XLoader_s0_k++)
  {
   for (int _XLoader_s0_kk = 0; _XLoader_s0_kk < 0 + 256; _XLoader_s0_kk++)
   {
    bool _18 = _XLoader_s0_k == _XLoader_s0_i;
    int _21 = _A_extent_1 >> 8;
    bool _22 = _XLoader_s0_i < _21;
    bool _23 = _22 || _18;
    if (_23)
    {
     float _24;
     int _25 = _A_extent_1 >> 8;
     bool _26 = _XLoader_s0_i < _25;
     if (_26)
     {
      int _18 = _XLoader_s0_kk + _XLoader_s0_k*256;
      float _32 = _XSerializer_mem_channel[_18];
      _24 = _32;
     } // if _26
     else
     {
      float _33 = float_from_bits(0 /* 0 */);
      _24 = _33;
     } // if _26 else
     float _34 = _24;
     write_channel_intel(_XLoader_channel, _34);
     (void)_34;
    } // if _23
   } // for _XLoader_s0_kk
  } // for _XLoader_s0_k
 } // for _XLoader_s0_i
} // kernel kernel_XLoader
#undef __address_space__XSerializer_mem_channel
// Address spaces for kernel_XFeeder
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_XFeeder(
)
{
 int _XFeeder_cycle_temp;
 float __attribute__((memory, numbanks(1), singlepump, numwriteports(1), numreadports(1))) _XFeeder_buffer__0_ibuffer[2][256];
 _XFeeder_cycle_temp = 1792;
 while(1)
 {
  int _37 = _XFeeder_cycle_temp;
  int _38 = _37 & 2047;
  bool _39 = 1792 <= _38;
  if (_39)
  {
   float __40 = read_channel_intel(_XLoader_channel);
   int _41 = _XFeeder_cycle_temp;
   int _42 = _41 >> 11;
   int _43 = _42 & 1;
   bool _44 = (bool)(_43);
   int _45 = _41 & 2047;
   int _46 = _45 & 255;
   _XFeeder_buffer__0_ibuffer[_44][_46] = __40;
  } // if _39
  int _47 = _XFeeder_cycle_temp;
  bool _48 = 2047 < _47;
  if (_48)
  {
   int _49 = _XFeeder_cycle_temp;
   int _50 = _49 >> 11;
   int _51 = _50 & 1;
   bool _52 = (bool)(_51);
   bool _53 = !(_52);
   int _54 = _49 >> 3;
   int _55 = _54 & 255;
   float _56 = _XFeeder_buffer__0_ibuffer[_53][_55];
   write_channel_intel(_XFeeder_channel, _56);
   (void)_56;
  } // if _48
  int _57 = _XFeeder_cycle_temp;
  int _58 = _57 + 1;
  _XFeeder_cycle_temp = _58;
 } // while _XFeeder_s0_outermost_loop_infinite
} // kernel kernel_XFeeder
// Address spaces for kernel_V
__kernel void kernel_V(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _ALoader_channel_array_t _ALoader_channel_array;
 _V_channel_array_t _V_channel_array;
 // produce uZ
 float _uZ_shreg[8][32];
 // produce uX
 float _uX_shreg;
 float _uZ_temp[32];
 // produce uA
 float _uA_shreg[32];
 int _121 = _A_extent_1 >> 8;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _121; _uA_s0_i++)
 {
  int _122 = _A_extent_0 >> 8;
  int _123 = _122 - _uA_s0_i;
  for (int _uA_s0_k = _uA_s0_i; _uA_s0_k < _uA_s0_i + _123; _uA_s0_k++)
  {
   #pragma loop_coalesce 2
   for (int _uA_s0_kk = 0; _uA_s0_kk < 0 + 256; _uA_s0_kk++)
   {
    for (int _uA_s0_ii = 0; _uA_s0_ii < 0 + 8; _uA_s0_ii++)
    {
     #pragma unroll
     for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 32; _dummy_s0_iii++)
     {
      float _125 = _uZ_shreg[7][_dummy_s0_iii];
      _uZ_temp[_dummy_s0_iii] = _125;
      #pragma unroll
      for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 7; _dummy__1_s0_l0++)
      {
       int _126 = 7 - _dummy__1_s0_l0;
       int _127 = 6 - _dummy__1_s0_l0;
       float _129 = _uZ_shreg[_127][_dummy_s0_iii];
       _uZ_shreg[_126][_dummy_s0_iii] = _129;
       (void)_129;
      } // for _dummy__1_s0_l0
      float _130 = _uZ_temp[_dummy_s0_iii];
      _uZ_shreg[0][_dummy_s0_iii] = _130;
      (void)_130;
     } // for _dummy_s0_iii
     bool _V_channel_temp;
     _V_channel_temp = 0;
     _ALoader_channel_array = read_channel_intel(_ALoader_channel);
     float _XFeeder_channel_array = read_channel_intel(_XFeeder_channel);
     #pragma unroll
     for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 32; _uA_s0_iii++)
     {
      float __132 = _ALoader_channel_array.s[_uA_s0_iii];
      _uA_shreg[_uA_s0_iii] = __132;
      (void)__132;
      float _133;
      bool _134 = _uA_s0_iii == 0;
      if (_134)
      {
       float __135 = _XFeeder_channel_array;
       _133 = __135;
      } // if _134
      else
      {
       float _137 = _uX_shreg;
       _133 = _137;
      } // if _134 else
      float _138 = _133;
      _uX_shreg = _138;
      (void)_138;
      float _140 = _uX_shreg;
      float _141 = __fpga_reg(__fpga_reg(_140));
      _uX_shreg = _141;
      (void)_141;
      float _142;
      bool _143 = _uA_s0_kk == 0;
      bool _144 = _uA_s0_k == _uA_s0_i;
      bool _145 = _143 && _144;
      if (_145)
      {
       float _146 = float_from_bits(0 /* 0 */);
       _142 = _146;
      } // if _145
      else
      {
       float _148 = _uZ_shreg[0][_uA_s0_iii];
       _142 = _148;
      } // if _145 else
      float _149 = _142;
      float _151 = _uA_shreg[_uA_s0_iii];
      float _153 = _uX_shreg;
      float _154 = _151 * _153;
      float _155 = _149 + _154;
      _uZ_shreg[0][_uA_s0_iii] = _155;
      (void)_155;
      bool _156 = _uA_s0_kk == 255;
      int _157 = _A_extent_0 >> 8;
      int _158 = _157 + -1;
      bool _159 = _uA_s0_k == _158;
      bool _160 = _156 && _159;
      if (_160)
      {
       float _162 = _uZ_shreg[0][_uA_s0_iii];
       _V_channel_array.s[_uA_s0_iii] = _162;
       (void)_uA_s0_iii;
       _V_channel_temp = 1;
      } // if _160
     } // for _uA_s0_iii
     bool _163 = _V_channel_temp;
     if (_163)
     {
      write_channel_intel(_V_channel, _V_channel_array);
      (void)_V_channel_array;
     } // if _163
    } // for _uA_s0_ii
   } // for _uA_s0_kk
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
 int _164 = _A_extent_1 >> 8;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _164; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 8; _unloader_s0_ii++)
  {
   _V_channel_array_t __165 = read_channel_intel(_V_channel);
   _V_channel_array = __165;
   #pragma unroll
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 32; _unloader_s0_iii++)
   {
    float __166 = _V_channel_array.s[_unloader_s0_iii];
    int _167 = _addr_temp;
    _unloader_mem_channel[_167] = __166;
    int _168 = _addr_temp;
    int _169 = _168 + 1;
    _addr_temp = _169;
   } // for _unloader_s0_iii
  } // for _unloader_s0_ii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

