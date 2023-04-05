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
    float s[64]; 
    float16 v[4];
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(256))) ;
channel float _xLoader_channel __attribute__((depth(256))) ;
channel float _xFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s; } _V_1_channel_array_t;
channel _V_1_channel_array_t _V_1_channel __attribute__((depth(256))) ;
typedef struct { float s[64]; } _V_2_channel_array_t;
channel _V_2_channel_array_t _V_2_channel __attribute__((depth(256))) ;
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
 _aLoader_channel_array_t _aLoader_channel_array;
 int _0 = _A_extent_1 >> 12;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _0; _aLoader_s0_i++)
 {
  int _1 = _A_extent_0 >> 13;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _1; _aLoader_s0_k++)
  {
   for (int _aLoader_s0_kk = 0; _aLoader_s0_kk < 0 + 8192; _aLoader_s0_kk++)
   {
    for (int _aLoader_s0_ii = 0; _aLoader_s0_ii < 0 + 64; _aLoader_s0_ii++)
    {
     int _2 = _addr_temp * 16;
     _aLoader_channel_array.v[0] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_1 + _2));
     _aLoader_channel_array.v[1] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_2 + _2));
     _aLoader_channel_array.v[2] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_3 + _2));
     _aLoader_channel_array.v[3] = vload16(0, (__address_space__A_serializer float*)(_A_serializer_4 + _2));
     write_channel_intel(_aLoader_channel, _aLoader_channel_array);
     (void)_aLoader_channel_array;
     _addr_temp += 1;
    } // for _aLoader_s0_ii
   } // for _aLoader_s0_kk
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
 int _13 = _A_extent_1 >> 12;
 int _14 = _13 + 1;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _14; _xLoader_s0_i++)
 {
  int _15 = _A_extent_0 >> 13;
  for (int _xLoader_s0_k = 0; _xLoader_s0_k < 0 + _15; _xLoader_s0_k++)
  {
   for (int _xLoader_s0_kk = 0; _xLoader_s0_kk < 0 + 8192; _xLoader_s0_kk++)
   {
    bool _16 = _xLoader_s0_k == 0;
    int _19 = _A_extent_1 >> 12;
    bool _20 = _xLoader_s0_i < _19;
    bool _21 = _16 || _20;
    if (_21)
    {
     float _22;
     int _23 = _A_extent_1 >> 12;
     bool _24 = _xLoader_s0_i < _23;
     if (_24)
     {
      int _25 = _xLoader_s0_kk + 8192*_xLoader_s0_k;
      float _29 = _X_serializer_mem_channel[_25];
      _22 = _29;
     } // if _24
     else
     {
      float _30 = float_from_bits(0 /* 0 */);
      _22 = _30;
     } // if _24 else
     float _31 = _22;
     write_channel_intel(_xLoader_channel, _31);
     (void)_31;
    } // if _21
    int _32 = _addr_temp;
    int _33 = _32 + 1;
    _addr_temp = _33;
   } // for _xLoader_s0_kk
  } // for _xLoader_s0_k
 } // for _xLoader_s0_i
} // kernel kernel_xLoader
#undef __address_space__X_serializer_mem_channel
// Address spaces for kernel_xFeeder
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_xFeeder(
)
{
 int _xFeeder_cycle_temp;
 float __attribute__((memory, numbanks(1), singlepump, numwriteports(1), numreadports(1))) _xFeeder_buffer__0_ibuffer[2][8192];
 _xFeeder_cycle_temp = 516096;
 while(1)
 {
  int _34 = _xFeeder_cycle_temp;
  int _35 = _34 & 524287;
  bool _36 = 516096 <= _35;
  if (_36)
  {
   float __37 = read_channel_intel(_xLoader_channel);
   int _38 = _xFeeder_cycle_temp;
   int _39 = _38 >> 19;
   int _40 = _39 & 1;
   bool _41 = (bool)(_40);
   int _42 = _38 & 524287;
   int _43 = _42 & 8191;
   _xFeeder_buffer__0_ibuffer[_41][_43] = __37;
  } // if _36
  int _44 = _xFeeder_cycle_temp;
  bool _45 = 524287 < _44;
  if (_45)
  {
   int _46 = _xFeeder_cycle_temp;
   int _47 = _46 >> 19;
   int _48 = _47 & 1;
   bool _49 = (bool)(_48);
   bool _50 = !(_49);
   int _51 = _46 >> 6;
   int _52 = _51 & 8191;
   float _53 = _xFeeder_buffer__0_ibuffer[_50][_52];
   write_channel_intel(_xFeeder_channel, _53);
   (void)_53;
  } // if _45
  int _54 = _xFeeder_cycle_temp;
  int _55 = _54 + 1;
  _xFeeder_cycle_temp = _55;
 } // while _xFeeder_s0_outermost_loop_infinite
} // kernel kernel_xFeeder
// Address spaces for kernel_V_1
__kernel void kernel_V_1(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _aLoader_channel_array_t _aLoader_channel_array;
 _V_1_channel_array_t _V_1_channel_array;
 _V_2_channel_array_t _V_2_channel_array;
 // produce uZ
 float _uZ_shreg[65][64];
 // produce uX
 float _uX_shreg;
 // produce uA
 float _uA_shreg[64];
 int _182 = _A_extent_1 >> 12;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _182; _uA_s0_i++)
 {
  int _183 = _A_extent_0 >> 13;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _183; _uA_s0_k++)
  {
   #pragma loop_coalesce 2
   for (int _uA_s0_kk = 0; _uA_s0_kk < 0 + 8192; _uA_s0_kk++)
   {
    for (int _uA_s0_ii = 0; _uA_s0_ii < 0 + 64; _uA_s0_ii++)
    {
     #pragma unroll
     for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 64; _dummy_s0_iii++)
     {
      #pragma unroll
      for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 64; _dummy__1_s0_l0++)
      {
       int _184 = 64 - _dummy__1_s0_l0;
       int _185 = 63 - _dummy__1_s0_l0;
       float _187 = _uZ_shreg[_185][_dummy_s0_iii];
       _uZ_shreg[_184][_dummy_s0_iii] = _187;
       (void)_187;
      } // for _dummy__1_s0_l0
     } // for _dummy_s0_iii
     _aLoader_channel_array_t __188 = read_channel_intel(_aLoader_channel);
     _aLoader_channel_array = __188;
     float _xFeeder_channel_array = read_channel_intel(_xFeeder_channel);
     #pragma unroll
     for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 64; _uA_s0_iii++)
     {
      float __189 = _aLoader_channel_array.s[_uA_s0_iii];
      _uA_shreg[_uA_s0_iii] = __189;
      (void)__189;
      float _190;
      bool _191 = _uA_s0_iii == 0;
      if (_191)
      {
       float __192 = _xFeeder_channel_array;
       _190 = __192;
      } // if _191
      else
      {
       float _194 = _uX_shreg;
       _190 = _194;
      } // if _191 else
      float _195 = _190;
      _uX_shreg = _195;
      (void)_195;
      float _197 = _uX_shreg;
      float _198 = __fpga_reg(__fpga_reg(_197));
      _uX_shreg = _198;
      (void)_198;
      bool _199 = _uA_s0_iii == 63;
      float _200;
      bool _201 = _uA_s0_ii == 63;
      bool _202 = _201 && _199;
      bool _203 = _uA_s0_kk == 0;
      bool _204 = _202 || _203;
      if (_204)
      {
       float _205 = float_from_bits(0 /* 0 */);
       _200 = _205;
      } // if _204
      else
      {
       float _206;
       if (_199)
       {
        int _207 = _uA_s0_iii + -63;
        float _209 = _uZ_shreg[63][_207];
        _206 = _209;
       } // if _199
       else
       {
        int _210 = _uA_s0_iii + 1;
        float _212 = _uZ_shreg[64][_210];
        _206 = _212;
       } // if _199 else
       float _213 = _206;
       _200 = _213;
      } // if _204 else
      float _214 = _200;
      float _216 = _uA_shreg[_uA_s0_iii];
      float _218 = _uX_shreg;
      float _219 = _216 * _218;
      float _220 = _214 + _219;
      _uZ_shreg[0][_uA_s0_iii] = _220;
      (void)_220;
      bool _221 = _uA_s0_iii == 0;
      bool _222 = _uA_s0_ii == 0;
      bool _223 = _221 && _222;
      if (_223)
      {
       float _225 = _uZ_shreg[0][0];
       _V_1_channel_array.s = _225;
       (void)_225;
      } // if _223
      bool _162 = _uA_s0_kk == 8191;
      if (_162)
      {
       float _163 = _uZ_shreg[0][_uA_s0_iii];
       _V_2_channel_array.s[_uA_s0_iii] = _163;
      }
     } // for _uA_s0_iii
     if (_uA_s0_kk == 8191)
     {
      write_channel_intel(_V_2_channel, _V_2_channel_array);
     }
    } // for _uA_s0_ii
    write_channel_intel(_V_1_channel, _V_1_channel_array);
    (void)_V_1_channel_array;
   } // for _uA_s0_kk
  } // for _uA_s0_k
 } // for _uA_s0_i
} // kernel kernel_V_1
// Address spaces for kernel_unloader_1
#define __address_space__unloader_1_mem_channel __global
__kernel void kernel_unloader_1(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__unloader_1_mem_channel float *restrict _unloader_1_mem_channel)
{
 _V_1_channel_array_t _V_1_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _226 = _A_extent_1 >> 12;
 for (int _unloader_1_s0_i = 0; _unloader_1_s0_i < 0 + _226; _unloader_1_s0_i++)
 {
  int _227 = _A_extent_0 >> 13;
  for (int _unloader_1_s0_k = 0; _unloader_1_s0_k < 0 + _227; _unloader_1_s0_k++)
  {
   for (int _unloader_1_s0_kk = 0; _unloader_1_s0_kk < 0 + 8192; _unloader_1_s0_kk++)
   {
    _V_1_channel_array_t __228 = read_channel_intel(_V_1_channel);
    _V_1_channel_array = __228;
    (void)__228;
    int _229 = _addr_temp;
    _unloader_1_mem_channel[_229] = _V_1_channel_array.s;
    int _230 = _addr_temp;
    int _231 = _230 + 1;
    _addr_temp = _231;
   } // for _unloader_1_s0_kk
  } // for _unloader_1_s0_k
 } // for _unloader_1_s0_i
} // kernel kernel_unloader_1
#undef __address_space__unloader_1_mem_channel

#define __address_space__unloader_2_mem_channel __global
__kernel void kernel_unloader_2(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__unloader_2_mem_channel float *restrict _unloader_2_mem_channel)
{
 _V_2_channel_array_t _V_2_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _162 = _A_extent_1 >> 12;
 for (int _unloader_1_s0_i = 0; _unloader_1_s0_i < 0 + _162; _unloader_1_s0_i++)
 {
  int _163 = _A_extent_0 >> 13;
  for (int _unloader_1_s0_k = 0; _unloader_1_s0_k < 0 + _163; _unloader_1_s0_k++)
  {
   for (int _unloader_1_s0_ii = 0; _unloader_1_s0_ii < 0 + 64; _unloader_1_s0_ii++)
   {
    _V_2_channel_array_t __164 = read_channel_intel(_V_2_channel);
    _V_2_channel_array = __164;
    #pragma unroll
    for (int _unloader_1_s0_iii = 0; _unloader_1_s0_iii < 0 + 64; _unloader_1_s0_iii++)
    {
     int _165 = _addr_temp;
     _unloader_2_mem_channel[_165] = _V_2_channel_array.s[_unloader_1_s0_iii];
     int _166 = _addr_temp;
     int _167 = _166 + 1;
     _addr_temp = _167;
    } // for _unloader_1_s0_iii
   } // for _unloader_1_s0_kk
  } // for _unloader_1_s0_k
 } // for _unloader_1_s0_i
} // kernel kernel_unloader_1
#undef __address_space__unloader_2_mem_channel
