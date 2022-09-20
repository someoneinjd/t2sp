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
} _ALoader_channel_array_t;
channel _ALoader_channel_array_t _ALoader_channel __attribute__((depth(256))) ;
channel float _XLoader_channel __attribute__((depth(256))) ;
channel float _XFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s[64]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(256))) ;

channel _ALoader_channel_array_t _ALoader_T_channel __attribute__((depth(256))) ;
typedef struct { float s[64]; } _AFeeder_T_channel_array_t;
channel _AFeeder_T_channel_array_t _AFeeder_T_channel __attribute__((depth(256))) ;
channel float _XLoader_T_channel __attribute__((depth(256))) ;
channel float _XFeeder_T_channel __attribute__((depth(256))) ;
channel _V_channel_array_t _V_T_channel __attribute__((depth(256))) ;

// Address spaces for kernel_ALoader
#define __address_space__ASerializer __global
__kernel void kernel_ALoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__ASerializer const float *restrict _A_serializer_1,
 __address_space__ASerializer const float *restrict _A_serializer_2,
 __address_space__ASerializer const float *restrict _A_serializer_3,
 __address_space__ASerializer const float *restrict _A_serializer_4)
{
 _ALoader_channel_array_t _ALoader_channel_array;
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 10;
 int _1 = _A_extent_0 >> 10;
 int _2 = (2 * _1 - _0 + 1) * _0 / 2;
 for (int _ALoader_s0_i_k = 0; _ALoader_s0_i_k < 1 + _2; _ALoader_s0_i_k++)
 {
   #pragma loop_coalesce 2
   for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 1024; _ALoader_s0_kk++)
   {
    for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 16; _ALoader_s0_ii++)
    {
     bool _3 = _ALoader_s0_i_k < _2;
     if (_3)
     {
      int _7 = _addr_temp * 16;
      _ALoader_channel_array.v[0] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_1 + _7));
      _ALoader_channel_array.v[1] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_2 + _7));
      _ALoader_channel_array.v[2] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_3 + _7));
      _ALoader_channel_array.v[3] = vload16(0, (__address_space__ASerializer float*)(_A_serializer_4 + _7));
     } // for _ALoader_s0_iii
     else
     {
      float _8 = float_from_bits(0 /* 0 */);
      _ALoader_channel_array.v[0] = _8;
      _ALoader_channel_array.v[1] = _8;
      _ALoader_channel_array.v[2] = _8;
      _ALoader_channel_array.v[3] = _8;
     }
     if (_ALoader_s0_i_k < _2)
     {
      write_channel_intel(_ALoader_channel, _ALoader_channel_array);
     }
     write_channel_intel(_ALoader_T_channel, _ALoader_channel_array);
     _addr_temp += 1;
    } // for _ALoader_s0_ii
   } // for _ALoader_s0_kk
 } // for _ALoader_s0_i
} // kernel kernel_ALoader
#undef __address_space__ASerializer
// Address spaces for kernel_XLoader
#define __address_space__XSerializer_mem_channel __global
__kernel void kernel_XLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__XSerializer_mem_channel const float *restrict _XSerializer_mem_channel)
{
 int _14 = _A_extent_1 >> 10;
 int _15 = _14 + 1;
 for (int _XLoader_s0_i = 0; _XLoader_s0_i < 0 + _15; _XLoader_s0_i++)
 {
  int _16 = _A_extent_0 >> 10;
  int _17 = _16 - _XLoader_s0_i + ((_XLoader_s0_i < _14) ? 0 : 1);
  for (int _XLoader_s0_k = _XLoader_s0_i; _XLoader_s0_k < _XLoader_s0_i + _17; _XLoader_s0_k++)
  {
   for (int _XLoader_s0_kk = 0; _XLoader_s0_kk < 0 + 1024; _XLoader_s0_kk++)
   {
    bool _18 = _XLoader_s0_k == _XLoader_s0_i;
    int _21 = _A_extent_1 >> 10;
    bool _22 = _XLoader_s0_i < _21;
    bool _23 = _18 || _22;
    if (_23)
    {
     float _24;
     int _25 = _A_extent_1 >> 10;
     bool _26 = _XLoader_s0_i < _25;
     if (_26)
     {
      int _27 = _XLoader_s0_kk + _XLoader_s0_k*1024;
      float _32 = _XSerializer_mem_channel[_27];
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
 float __attribute__((memory, numbanks(1), singlepump, numwriteports(1), numreadports(1))) _XFeeder_buffer__0_ibuffer[2][1024];
 _XFeeder_cycle_temp = 15360;
 while(1)
 {
  int _37 = _XFeeder_cycle_temp;
  int _38 = _37 & 16383;
  bool _39 = 15360 <= _38;
  if (_39)
  {
   float __40 = read_channel_intel(_XLoader_channel);
   int _41 = _XFeeder_cycle_temp;
   int _42 = _41 >> 14;
   int _43 = _42 & 1;
   bool _44 = (bool)(_43);
   int _45 = _41 & 16383;
   int _46 = _45 & 1023;
   _XFeeder_buffer__0_ibuffer[_44][_46] = __40;
  } // if _39
  int _47 = _XFeeder_cycle_temp;
  bool _48 = 16383 < _47;
  if (_48)
  {
   int _49 = _XFeeder_cycle_temp;
   int _50 = _49 >> 14;
   int _51 = _50 & 1;
   bool _52 = (bool)(_51);
   bool _53 = !(_52);
   int _54 = _49 >> 4;
   int _55 = _54 & 1023;
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
#define __address_space__V __global
__kernel void kernel_V(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _ALoader_channel_array_t _ALoader_channel_array;
 _V_channel_array_t _V_channel_array;
 // produce uZ
 float _uZ_shreg[16][64];
 // produce uX
 float _uX_shreg;
 float _uZ_temp[64];
 // produce uA
 float _uA_shreg[64];
 int _185 = _A_extent_1 >> 10;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _185; _uA_s0_i++)
 {
  int _186 = _A_extent_0 >> 10;
  int _187 = _186 - _uA_s0_i;
  for (int _uA_s0_k = _uA_s0_i; _uA_s0_k < _uA_s0_i + _187; _uA_s0_k++)
  {
   #pragma loop_coalesce 2
   for (int _uA_s0_kk = 0; _uA_s0_kk < 0 + 1024; _uA_s0_kk++)
   {
    for (int _uA_s0_ii = 0; _uA_s0_ii < 0 + 16; _uA_s0_ii++)
    {
     #pragma unroll
     for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 64; _dummy_s0_iii++)
     {
      float _189 = _uZ_shreg[15][_dummy_s0_iii];
      _uZ_temp[_dummy_s0_iii] = _189;
      #pragma unroll
      for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 15; _dummy__1_s0_l0++)
      {
       int _190 = 15 - _dummy__1_s0_l0;
       int _191 = 14 - _dummy__1_s0_l0;
       float _193 = _uZ_shreg[_191][_dummy_s0_iii];
       _uZ_shreg[_190][_dummy_s0_iii] = _193;
       (void)_193;
      } // for _dummy__1_s0_l0
      float _194 = _uZ_temp[_dummy_s0_iii];
      _uZ_shreg[0][_dummy_s0_iii] = _194;
      (void)_194;
     } // for _dummy_s0_iii
     bool _V_channel_temp;
     _V_channel_temp = 0;
     _ALoader_channel_array = read_channel_intel(_ALoader_channel);
     float _XFeeder_channel_array = read_channel_intel(_XFeeder_channel);
     #pragma unroll
     for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 64; _uA_s0_iii++)
     {
      float __196 = _ALoader_channel_array.s[_uA_s0_iii];
      _uA_shreg[_uA_s0_iii] = __196;
      (void)__196;
      float _197;
      bool _198 = _uA_s0_iii == 0;
      if (_198)
      {
       float __199 = _XFeeder_channel_array;
       _197 = __199;
      } // if _198
      else
      {
       float _201 = _uX_shreg;
       _197 = _201;
      } // if _198 else
      float _202 = _197;
      _uX_shreg = _202;
      (void)_202;
      float _204 = _uX_shreg;
      float _205 = __fpga_reg(__fpga_reg(_204));
      _uX_shreg = _205;
      (void)_205;
      float _206;
      bool _207 = _uA_s0_kk == 0;
      bool _208 = _uA_s0_k == _uA_s0_i;
      bool _209 = _207 && _208;
      if (_209)
      {
       float _210 = float_from_bits(0 /* 0 */);
       _206 = _210;
      } // if _209
      else
      {
       float _212 = _uZ_shreg[0][_uA_s0_iii];
       _206 = _212;
      } // if _209 else
      float _213 = _206;
      float _215 = _uA_shreg[_uA_s0_iii];
      float _217 = _uX_shreg;
      float _218 = _215 * _217;
      float _219 = _213 + _218;
      _uZ_shreg[0][_uA_s0_iii] = _219;
      (void)_219;
      bool _220 = _uA_s0_kk == 1023;
      int _221 = _A_extent_0 >> 10;
      int _222 = _221 + -1;
      bool _223 = _uA_s0_k == _222;
      bool _224 = _220 && _223;
      if (_224)
      {
       float _226 = _uZ_shreg[0][_uA_s0_iii];
       _V_channel_array.s[_uA_s0_iii] = _226;
       _V_channel_temp = 1;
      } // if _224
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
#undef __address_space__V
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 _V_channel_array_t _V_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _164 = _A_extent_1 >> 10;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _164; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 16; _unloader_s0_ii++)
  {
   _V_channel_array_t __165 = read_channel_intel(_V_channel);
   _V_channel_array = __165;
   #pragma unroll
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 64; _unloader_s0_iii++)
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

// Address spaces for kernel_XLoader_T
#define __address_space__XSerializer_T_mem_channel __global
__kernel void kernel_XLoader_T(
 const int _A_extent_0,
 __address_space__XSerializer_T_mem_channel const float *restrict _XSerializer_T_mem_channel)
{
 int _343 = _A_extent_0 >> 10;
 int _344 = _343 + 1;
 for (int _XLoader_T_s0_k = 0; _XLoader_T_s0_k < 0 + _344; _XLoader_T_s0_k++)
 {
  int _345 = _A_extent_0 >> 10;
  int _346 = _345 - _XLoader_T_s0_k + ((_XLoader_T_s0_k < _343) ? 0 : 1);
  for (int _XLoader_T_s0_i = _XLoader_T_s0_k; _XLoader_T_s0_i < _XLoader_T_s0_k + _346; _XLoader_T_s0_i++)
  {
   for (int _XLoader_T_s0_kk = 0; _XLoader_T_s0_kk < 0 + 1024; _XLoader_T_s0_kk++)
   {
    bool _347 = _XLoader_T_s0_i == _XLoader_T_s0_k;
    int _350 = _A_extent_0 >> 10;
    bool _351 = _XLoader_T_s0_k < _350;
    bool _352 = _347 || _351;
    if (_352)
    {
     float _354;
     int _355 = _A_extent_0 >> 10;
     bool _356 = _XLoader_T_s0_k < _355;
     if (_356)
     {
      int _196 = _XLoader_T_s0_kk + _XLoader_T_s0_k*1024;
      float _364 = _XSerializer_T_mem_channel[_196];
      _354 = _364;
     } // if _356
     else
     {
      float _365 = float_from_bits(0 /* 0 */);
      _354 = _365;
     } // if _356 else
     float _366 = _354;
     write_channel_intel(_XLoader_T_channel, _366);
     (void)_366;
    } // if _352
   } // for _XLoader_T_s0_kk
  } // for _XLoader_T_s0_i
 } // for _XLoader_T_s0_k
} // kernel kernel_XLoader_T
#undef __address_space__XSerializer_T_mem_channel
// Address spaces for kernel_AFeeder_T
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_AFeeder_T(
)
{
 _AFeeder_T_channel_array_t _AFeeder_T_channel_array;
 _ALoader_channel_array_t __attribute__((register)) _AFeeder_T_value_shreg;
 uint _AFeeder_T_time_stamp_shreg;
 _ALoader_channel_array_t __attribute__((register)) _AFeeder_T_in_v_temp;
 uint _AFeeder_T_cycle_temp;
 float __attribute__((memory, numbanks(64), singlepump, numwriteports(1), numreadports(1))) _AFeeder_T_DB_0_ibuffer[2][1024][1024];
 _AFeeder_T_cycle_temp = 0;
 while(1)
 {
  _ALoader_channel_array_t __attribute__((register)) _temp;
  _AFeeder_T_in_v_temp = read_channel_intel(_ALoader_T_channel);;
  #pragma unroll
  for (int _AFeeder_T_s0_buf = 0; _AFeeder_T_s0_buf < 0 + 64; _AFeeder_T_s0_buf++)
  {
   bool _264 = _AFeeder_T_s0_buf == 0;
   if (_264)
   {
    _AFeeder_T_value_shreg = _AFeeder_T_in_v_temp;
    _AFeeder_T_time_stamp_shreg = _AFeeder_T_cycle_temp;
   } // if _264
   else
   {
    _AFeeder_T_value_shreg= _AFeeder_T_value_shreg;
    _AFeeder_T_time_stamp_shreg = _AFeeder_T_time_stamp_shreg;
   } // if _264 else
   _AFeeder_T_value_shreg = __fpga_reg(__fpga_reg(_AFeeder_T_value_shreg));
   _AFeeder_T_time_stamp_shreg = __fpga_reg(__fpga_reg(_AFeeder_T_time_stamp_shreg));

   uint _288 = _AFeeder_T_time_stamp_shreg;
   uint _290 = _288 >> 14;
   uint _292 = _290 & 1;
   bool _293 = (bool)(_292);
   uint _296 = _288 & 16383;
   int _i = (_296 & 15) << 6;
   int _k = (_296 >> 4);
   unsigned _idx = (_AFeeder_T_s0_buf + 64 - (_k & 63)) & 63;
   _AFeeder_T_DB_0_ibuffer[_293][_k][_i + _AFeeder_T_s0_buf] = _AFeeder_T_value_shreg.s[_idx];

   int _312 = _AFeeder_T_time_stamp_shreg;
   bool _313 = 16383 < _312;
   if (_313)
   {
    uint _315 = _AFeeder_T_time_stamp_shreg;
    uint _320 = _315 >> 14;
    uint _322 = _320 & 1;
    bool _323 = (bool)(_322);
    bool _324 = !(_323);
    int _325 = _315 & 16383;
    int _i = (_325 & 15) << 6;
    int _k = (_325 >> 4);
    int _base = (_k >> 6) << 6;
    unsigned _idx = (_AFeeder_T_s0_buf + 64 - (_k & 63)) & 63;
    _temp.s[_AFeeder_T_s0_buf] = _AFeeder_T_DB_0_ibuffer[_324][_i + _idx][_base + _AFeeder_T_s0_buf];
   } // if _313
  } // for _AFeeder_T_s0_buf
  _AFeeder_T_channel_array_t __attribute__((register)) _out;
  int _315 = _AFeeder_T_time_stamp_shreg;
  int _325 = _315 & 16383;
  int _k = (_325 >> 4);
  #pragma unroll
  for (int _t = 0; _t < 64; _t++) {
    unsigned _idx = (_t + (_k & 63)) & 63;
    _out.s[_t] = _temp.s[_idx];
  }
  if (16383 < _315)
  {
   write_channel_intel(_AFeeder_T_channel, _out);
  } // if _339
  uint _340 = _AFeeder_T_cycle_temp;
  uint _342 = _340 + 1;
  _AFeeder_T_cycle_temp = _342;
 } // while _AFeeder_T_s0_outermost_loop_infinite
} // kernel kernel_AFeeder_T
// Address spaces for kernel_XFeeder_T
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_XFeeder_T(
)
{
 int _XFeeder_T_cycle_temp;
 float __attribute__((memory, numbanks(1), singlepump, numwriteports(1), numreadports(1))) _XFeeder_T_buffer__0_ibuffer[2][1024];
 _XFeeder_T_cycle_temp = 15360;
 while(1)
 {
  int _369 = _XFeeder_T_cycle_temp;
  int _370 = _369 & 16383;
  bool _371 = 15360 <= _370;
  if (_371)
  {
   float __372 = read_channel_intel(_XLoader_T_channel);
   int _373 = _XFeeder_T_cycle_temp;
   int _374 = _373 >> 14;
   int _375 = _374 & 1;
   bool _376 = (bool)(_375);
   int _377 = _373 & 16383;
   int _378 = _377 & 1023;
   _XFeeder_T_buffer__0_ibuffer[_376][_378] = __372;
  } // if _371
  int _379 = _XFeeder_T_cycle_temp;
  bool _380 = 16383 < _379;
  if (_380)
  {
   int _381 = _XFeeder_T_cycle_temp;
   int _382 = _381 >> 14;
   int _383 = _382 & 1;
   bool _384 = (bool)(_383);
   bool _385 = !(_384);
   int _386 = _381 >> 4;
   int _387 = _386 & 1023;
   float _388 = _XFeeder_T_buffer__0_ibuffer[_385][_387];
   write_channel_intel(_XFeeder_T_channel, _388);
   (void)_388;
  } // if _380
  int _389 = _XFeeder_T_cycle_temp;
  int _390 = _389 + 1;
  _XFeeder_T_cycle_temp = _390;
 } // while _XFeeder_T_s0_outermost_loop_infinite
} // kernel kernel_XFeeder_T
// Address spaces for kernel_V_T
#define __address_space__V_T __global
__kernel void kernel_V_T(
 const int _A_extent_0)
{
 _AFeeder_T_channel_array_t _AFeeder_T_channel_array;
 _V_channel_array_t _V_channel_array;
 // produce uZ_T
 float _uZ_T_shreg[16][64];
 // produce uX_T
 float _uX_T_shreg;
 float _uZ_T_temp[64];
 float _uZ_temp[64];
 // produce uA_T
 float _uA_T_shreg[64];
 int _517 = _A_extent_0 >> 10;
 for (int _uA_T_s0_k = 0; _uA_T_s0_k < 0 + _517; _uA_T_s0_k++)
 {
  int _518 = _A_extent_0 >> 10;
  int _519 = _518 - _uA_T_s0_k;
  for (int _uA_T_s0_i = _uA_T_s0_k; _uA_T_s0_i < _uA_T_s0_k + _519; _uA_T_s0_i++)
  {
   #pragma loop_coalesce 2
   for (int _uA_T_s0_kk = 0; _uA_T_s0_kk < 0 + 1024; _uA_T_s0_kk++)
   {
    for (int _uA_T_s0_ii = 0; _uA_T_s0_ii < 0 + 16; _uA_T_s0_ii++)
    {
     #pragma unroll
     for (int _dummy__2_s0_iii = 0; _dummy__2_s0_iii < 0 + 64; _dummy__2_s0_iii++)
     {
      float _521 = _uZ_T_shreg[15][_dummy__2_s0_iii];
      _uZ_T_temp[_dummy__2_s0_iii] = _521;
      #pragma unroll
      for (int _dummy__3_s0_l0 = 0; _dummy__3_s0_l0 < 0 + 15; _dummy__3_s0_l0++)
      {
       int _522 = 15 - _dummy__3_s0_l0;
       int _523 = 14 - _dummy__3_s0_l0;
       float _525 = _uZ_T_shreg[_523][_dummy__2_s0_iii];
       _uZ_T_shreg[_522][_dummy__2_s0_iii] = _525;
       (void)_525;
      } // for _dummy__3_s0_l0
      float _526 = _uZ_T_temp[_dummy__2_s0_iii];
      _uZ_T_shreg[0][_dummy__2_s0_iii] = _526;
      (void)_526;
     } // for _dummy__2_s0_iii
     bool _V_channel_temp;
     _V_channel_temp = 0;
     _AFeeder_T_channel_array = read_channel_intel(_AFeeder_T_channel);
     float _XFeeder_T_channel_array = read_channel_intel(_XFeeder_T_channel);
     #pragma unroll
     for (int _uA_T_s0_iii = 0; _uA_T_s0_iii < 0 + 64; _uA_T_s0_iii++)
     {
      float __528 = _AFeeder_T_channel_array.s[_uA_T_s0_iii];
      _uA_T_shreg[_uA_T_s0_iii] = __528;
      (void)__528;
      float _529;
      bool _530 = _uA_T_s0_iii == 0;
      if (_530)
      {
       float __531 = _XFeeder_T_channel_array;
       _529 = __531;
      } // if _530
      else
      {
       float _533 = _uX_T_shreg;
       _529 = _533;
      } // if _530 else
      float _534 = _529;
      _uX_T_shreg = _534;
      (void)_534;
      float _536 = _uX_T_shreg;
      float _537 = __fpga_reg(__fpga_reg(_536));
      _uX_T_shreg = _537;
      (void)_537;
      float _538;
      bool _539 = _uA_T_s0_kk == 0;
      if (_539)
      {
       float _540 = float_from_bits(0 /* 0 */);
       _538 = _540;
      } // if _539
      else
      {
       float _542 = _uZ_T_shreg[0][_uA_T_s0_iii];
       _538 = _542;
      } // if _539 else
      float _543 = _538;
      float _545 = _uA_T_shreg[_uA_T_s0_iii];
      float _547 = _uX_T_shreg;
      float _548 = _545 * _547;
      float _549 = _543 + _548;
      _uZ_T_shreg[0][_uA_T_s0_iii] = _549;
      (void)_549;
      bool _550 = _uA_T_s0_kk == 1023;
      if (_550)
      {
       float _552 = _uZ_T_shreg[0][_uA_T_s0_iii];
       _V_channel_array.s[_uA_T_s0_iii] = _552;
       _V_channel_temp = 1;
      } // if _550
     } // for _uA_T_s0_iii
     bool _163 = _V_channel_temp;
     if (_163)
     {
      write_channel_intel(_V_T_channel, _V_channel_array);
      (void)_V_channel_array;
     } // if _163
    } // for _uA_T_s0_ii
   } // for _uA_T_s0_kk
  } // for _uA_T_s0_i
 } // for _uA_T_s0_k
} // kernel kernel_V_T
#undef __address_space__V_T
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader_T(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 _V_channel_array_t _V_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _163 = _A_extent_0 >> 10;
 for (int _unloader_s0_k = 0; _unloader_s0_k < _163; _unloader_s0_k++)
 {
  int _164 = _A_extent_1 >> 10;
  for (int _unloader_s0_i = _unloader_s0_k; _unloader_s0_i < 0 + _164; _unloader_s0_i++)
  {
   for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 16; _unloader_s0_ii++)
   {
    _V_channel_array_t __165 = read_channel_intel(_V_T_channel);
    _V_channel_array = __165;
    #pragma unroll
    for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 64; _unloader_s0_iii++)
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
 } // for _unloader_s0_k
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel
