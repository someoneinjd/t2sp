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
channel float _aLoader_channel[2] __attribute__((depth(0))) ;
channel float _aFeeder_channel[2] __attribute__((depth(0))) ;
channel float _xLoader_channel[2] __attribute__((depth(0))) ;
channel float _xFeeder_channel[2] __attribute__((depth(0))) ;
typedef struct { float s[2]; } _V_channel_array_t;
channel _V_channel_array_t _V_channel __attribute__((depth(0))) ;
channel float _yLoader_channel __attribute__((depth(0))) ;
channel float _yFeeder_channel __attribute__((depth(0))) ;
channel float _Out_channel __attribute__((depth(0))) ;
channel float _drainer_channel __attribute__((depth(0))) ;
channel float _collector_channel __attribute__((depth(0))) ;
// Address spaces for kernel_aLoader
#define __address_space__aSerializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__aSerializer const float *restrict _aSerializer)
{
 int _0 = _A_extent_0 + _A_extent_1;
 int _1 = _0 + 3;
 int _2 = _1 >> 2;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _2; _aLoader_s0_i++)
 {
  int _3 = _A_extent_1 >> 2;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _3; _aLoader_s0_k++)
  {
   int _4 = _A_extent_1 >> 1;
   int _5 = _aLoader_s0_k * 2;
   int _6 = _4 - _5;
   int _7 = min(_6, 1);
   int _8 = max(_7, -1);
   int _9 = _8 + 1;
   for (int _aLoader_s0_kk = 0; _aLoader_s0_kk < 0 + _9; _aLoader_s0_kk++)
   {
    for (int _aLoader_s0_ii = 0; _aLoader_s0_ii < 0 + 2; _aLoader_s0_ii++)
    {
     int _10 = _aLoader_s0_k * 2;
     int _11 = _10 + _aLoader_s0_kk;
     int _12 = _11 * 2;
     int _13 = _A_extent_1 - _12;
     int _14 = min(_13, 1);
     int _15 = max(_14, -1);
     int _16 = _15 + 1;
     for (int _aLoader_s0_kkk = 0; _aLoader_s0_kkk < 0 + _16; _aLoader_s0_kkk++)
     {
      int _17 = _aLoader_s0_k * 4;
      int _18 = _aLoader_s0_kk * 2;
      int _19 = _18 + _aLoader_s0_kkk;
      int _20 = _17 + _19;
      bool _21 = _20 <= _A_extent_1;
      if (_21)
      {
       int _22 = _A_extent_1 >> 2;
       int _23 = _22 * _aLoader_s0_i;
       int _24 = _23 * 16;
       int _25 = _aLoader_s0_k * 16;
       int _26 = _aLoader_s0_kk * 8;
       int _27 = _aLoader_s0_ii * 4;
       int _28 = _27 + _aLoader_s0_kkk;
       int _29 = _26 + _28;
       int _30 = _25 + _29;
       int _31 = _24 + _30;
       float _32 = _aSerializer[_31];
       write_channel_intel(_aLoader_channel[0], _32);
       (void)_32;
      } // if _21
     } // for _aLoader_s0_kkk
     int _33 = _aLoader_s0_k * 2;
     int _34 = _33 + _aLoader_s0_kk;
     int _35 = _34 * 2;
     int _36 = _A_extent_1 - _35;
     int _37 = min(_36, 1);
     int _38 = max(_37, -1);
     int _39 = _38 + 1;
     for (int _aLoader_s0_kkk = 0; _aLoader_s0_kkk < 0 + _39; _aLoader_s0_kkk++)
     {
      int _40 = _aLoader_s0_k * 4;
      int _41 = _aLoader_s0_kk * 2;
      int _42 = _41 + _aLoader_s0_kkk;
      int _43 = _40 + _42;
      bool _44 = _43 <= _A_extent_1;
      if (_44)
      {
       int _45 = _A_extent_1 >> 2;
       int _46 = _45 * _aLoader_s0_i;
       int _47 = _46 * 16;
       int _48 = _aLoader_s0_k * 16;
       int _49 = _aLoader_s0_kk * 8;
       int _50 = _aLoader_s0_ii * 4;
       int _51 = _50 + _aLoader_s0_kkk;
       int _52 = _49 + _51;
       int _53 = _48 + _52;
       int _54 = _47 + _53;
       int _55 = _54 + 2;
       float _56 = _aSerializer[_55];
       write_channel_intel(_aLoader_channel[1], _56);
       (void)_56;
      } // if _44
     } // for _aLoader_s0_kkk
    } // for _aLoader_s0_ii
   } // for _aLoader_s0_kk
  } // for _aLoader_s0_k
 } // for _aLoader_s0_i
} // kernel kernel_aLoader
#undef __address_space__aSerializer
// Address spaces for kernel_aFeeder
__kernel void kernel_aFeeder(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _57 = _A_extent_0 + _A_extent_1;
 int _58 = _57 + 3;
 int _59 = _58 >> 2;
 for (int _aFeeder_s0_i = 0; _aFeeder_s0_i < 0 + _59; _aFeeder_s0_i++)
 {
  int _60 = _A_extent_1 >> 2;
  for (int _aFeeder_s0_k = 0; _aFeeder_s0_k < 0 + _60; _aFeeder_s0_k++)
  {
   int _61 = _A_extent_1 >> 1;
   int _62 = _aFeeder_s0_k * 2;
   int _63 = _61 - _62;
   int _64 = min(_63, 1);
   int _65 = max(_64, -1);
   int _66 = _65 + 1;
   for (int _aFeeder_s0_kk = 0; _aFeeder_s0_kk < 0 + _66; _aFeeder_s0_kk++)
   {
    for (int _aFeeder_s0_ii = 0; _aFeeder_s0_ii < 0 + 2; _aFeeder_s0_ii++)
    {
     int _67 = _aFeeder_s0_k * 2;
     int _68 = _67 + _aFeeder_s0_kk;
     int _69 = _68 * 2;
     int _70 = _A_extent_1 - _69;
     int _71 = min(_70, 1);
     int _72 = max(_71, -1);
     int _73 = _72 + 1;
     for (int _aFeeder_s0_kkk = 0; _aFeeder_s0_kkk < 0 + _73; _aFeeder_s0_kkk++)
     {
      int _74 = _aFeeder_s0_k * 4;
      int _75 = _aFeeder_s0_kk * 2;
      int _76 = _75 + _aFeeder_s0_kkk;
      int _77 = _74 + _76;
      bool _78 = _77 <= _A_extent_1;
      if (_78)
      {
       float __79 = read_channel_intel(_aLoader_channel[0]);
       write_channel_intel(_aFeeder_channel[0], __79);
       (void)__79;
      } // if _78
     } // for _aFeeder_s0_kkk
     int _80 = _aFeeder_s0_k * 2;
     int _81 = _80 + _aFeeder_s0_kk;
     int _82 = _81 * 2;
     int _83 = _A_extent_1 - _82;
     int _84 = min(_83, 1);
     int _85 = max(_84, -1);
     int _86 = _85 + 1;
     for (int _aFeeder_s0_kkk = 0; _aFeeder_s0_kkk < 0 + _86; _aFeeder_s0_kkk++)
     {
      int _87 = _aFeeder_s0_k * 4;
      int _88 = _aFeeder_s0_kk * 2;
      int _89 = _88 + _aFeeder_s0_kkk;
      int _90 = _87 + _89;
      bool _91 = _90 <= _A_extent_1;
      if (_91)
      {
       float __92 = read_channel_intel(_aLoader_channel[1]);
       write_channel_intel(_aFeeder_channel[1], __92);
       (void)__92;
      } // if _91
     } // for _aFeeder_s0_kkk
    } // for _aFeeder_s0_ii
   } // for _aFeeder_s0_kk
  } // for _aFeeder_s0_k
 } // for _aFeeder_s0_i
} // kernel kernel_aFeeder
// Address spaces for kernel_xLoader
#define __address_space__xSerializer __global
__kernel void kernel_xLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__xSerializer const float *restrict _xSerializer)
{
 int _93 = _A_extent_0 + _A_extent_1;
 int _94 = _93 + 3;
 int _95 = _94 >> 2;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _95; _xLoader_s0_i++)
 {
  int _96 = _A_extent_1 >> 2;
  for (int _xLoader_s0_k = 0; _xLoader_s0_k < 0 + _96; _xLoader_s0_k++)
  {
   for (int _xLoader_s0_kk_ii = 0; _xLoader_s0_kk_ii < 0 + 4; _xLoader_s0_kk_ii++)
   {
    for (int _xLoader_s0_kkk = 0; _xLoader_s0_kkk < 0 + 2; _xLoader_s0_kkk++)
    {
     int _97 = _A_extent_1 >> 2;
     int _98 = _97 * _xLoader_s0_i;
     int _99 = _98 * 16;
     int _100 = _xLoader_s0_k * 16;
     int _101 = _xLoader_s0_kk_ii >> 1;
     int _102 = _101 * 8;
     int _103 = _xLoader_s0_kk_ii & 1;
     int _104 = _103 * 4;
     int _105 = _104 + _xLoader_s0_kkk;
     int _106 = _102 + _105;
     int _107 = _100 + _106;
     int _108 = _99 + _107;
     float _109 = _xSerializer[_108];
     write_channel_intel(_xLoader_channel[0], _109);
     (void)_109;
    } // for _xLoader_s0_kkk
    for (int _xLoader_s0_kkk = 0; _xLoader_s0_kkk < 0 + 2; _xLoader_s0_kkk++)
    {
     bool _110 = _xLoader_s0_kkk == 0;
     if (_110)
     {
      int _111 = _A_extent_1 >> 2;
      int _112 = _111 * _xLoader_s0_i;
      int _113 = _112 * 4;
      int _114 = _xLoader_s0_k * 4;
      int _115 = _114 + _xLoader_s0_kk_ii;
      int _116 = _113 + _115;
      int _117 = _116 * 4;
      int _118 = _117 + 2;
      float _119 = _xSerializer[_118];
      write_channel_intel(_xLoader_channel[1], _119);
      (void)_119;
     } // if _110
    } // for _xLoader_s0_kkk
   } // for _xLoader_s0_kk_ii
  } // for _xLoader_s0_k
 } // for _xLoader_s0_i
} // kernel kernel_xLoader
#undef __address_space__xSerializer
// Address spaces for kernel_xFeeder
__kernel void kernel_xFeeder(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _120 = _A_extent_0 + _A_extent_1;
 int _121 = _120 + 3;
 int _122 = _121 >> 2;
 for (int _xFeeder_s0_i = 0; _xFeeder_s0_i < 0 + _122; _xFeeder_s0_i++)
 {
  int _123 = _A_extent_1 >> 2;
  for (int _xFeeder_s0_k = 0; _xFeeder_s0_k < 0 + _123; _xFeeder_s0_k++)
  {
   for (int _xFeeder_s0_kk_ii = 0; _xFeeder_s0_kk_ii < 0 + 4; _xFeeder_s0_kk_ii++)
   {
    for (int _xFeeder_s0_kkk = 0; _xFeeder_s0_kkk < 0 + 2; _xFeeder_s0_kkk++)
    {
     float __124 = read_channel_intel(_xLoader_channel[0]);
     write_channel_intel(_xFeeder_channel[0], __124);
     (void)__124;
    } // for _xFeeder_s0_kkk
    for (int _xFeeder_s0_kkk = 0; _xFeeder_s0_kkk < 0 + 2; _xFeeder_s0_kkk++)
    {
     bool _125 = _xFeeder_s0_kkk == 0;
     if (_125)
     {
      float __126 = read_channel_intel(_xLoader_channel[1]);
      write_channel_intel(_xFeeder_channel[1], __126);
      (void)__126;
     } // if _125
    } // for _xFeeder_s0_kkk
   } // for _xFeeder_s0_kk_ii
  } // for _xFeeder_s0_k
 } // for _xFeeder_s0_i
} // kernel kernel_xFeeder
// Address spaces for kernel_V
__kernel void kernel_V(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _V_channel_array_t _V_channel_array;
 // produce uZ
 float _uZ_shreg[2][2];
 // produce uX
 float _uX_shreg[2][2];
 float _uZ_temp[2];
 // produce uA
 float _uA_shreg[2];
 int _127 = _A_extent_0 + _A_extent_1;
 int _128 = _127 + 3;
 int _129 = _128 >> 2;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _129; _uA_s0_i++)
 {
  int _130 = _A_extent_1 >> 2;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _130; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 4; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 2; _dummy_s0_iii++)
    {
     float _132 = _uZ_shreg[1][_dummy_s0_iii];
     _uZ_temp[_dummy_s0_iii] = _132;
     float _134 = _uZ_shreg[0][_dummy_s0_iii];
     _uZ_shreg[1][_dummy_s0_iii] = _134;
     (void)_134;
     float _135 = _uZ_temp[_dummy_s0_iii];
     _uZ_shreg[0][_dummy_s0_iii] = _135;
     (void)_135;
    } // for _dummy_s0_iii
    bool _V_channel_temp;
    _V_channel_temp = 0;
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 2; _uA_s0_iii++)
    {
     for (int _uA_s0_kkk = 0; _uA_s0_kkk < 0 + 2; _uA_s0_kkk++)
     {
            _uX_shreg[1][_uA_s0_iii] = _uX_shreg[0][_uA_s0_iii]; 

      float _136;
      int _137 = _uA_s0_k * 4;
      int _138 = _uA_s0_kk_ii >> 1;
      int _139 = _138 * 2;
      int _140 = _139 + _uA_s0_kkk;
      int _141 = _137 + _140;
      bool _142 = _A_extent_1 < _141;
      if (_142)
      {
       float _143 = float_from_bits(0 /* 0 */);
       _136 = _143;
      } // if _142
      else
      {
       float __144 = read_channel_intel(_aFeeder_channel[_uA_s0_iii]);
       _136 = __144;
      } // if _142 else
      float _145 = _136;
      _uA_shreg[_uA_s0_iii] = _145;
      (void)_145;
      float _146;
      bool _147 = _uA_s0_kkk == 0;
      bool _148 = _uA_s0_iii == 0;
      bool _149 = _147 || _148;
      if (_149)
      {
       float __150 = read_channel_intel(_xFeeder_channel[_uA_s0_iii]);
       _146 = __150;
      } // if _149
      else
      {
       float _152 = _uX_shreg[1][0];
       _146 = _152;
      } // if _149 else
      float _153 = _146;
      _uX_shreg[0][0] = _153;
      (void)_153;
      float _155 = _uX_shreg[0][0];
      float _156 = __fpga_reg(__fpga_reg(_155));
      _uX_shreg[0][0] = _156;
      (void)_156;
      float _157;
      int _158 = _uA_s0_k * 4;
      int _159 = _uA_s0_kk_ii >> 1;
      int _160 = _159 * 2;
      int _161 = _160 + _uA_s0_kkk;
      int _162 = _158 + _161;
      bool _163 = _162 == 0;
      if (_163)
      {
       float _164 = float_from_bits(0 /* 0 */);
       _157 = _164;
      } // if _163
      else
      {
       float _166 = _uZ_shreg[0][_uA_s0_iii];
       _157 = _166;
      } // if _163 else
      float _167 = _157;
      float _169 = _uA_shreg[_uA_s0_iii];
      float _171 = _uX_shreg[0][0];
      float _172 = _169 * _171;
      float _173 = _167 + _172;
      _uZ_shreg[0][_uA_s0_iii] = _173;
      (void)_173;
      bool _174 = _uA_s0_kkk == 1;
      int _175 = _uA_s0_kk_ii >> 1;
      bool _176 = _175 == 1;
      bool _177 = _174 && _176;
      int _178 = _A_extent_1 >> 2;
      int _179 = _178 + -1;
      bool _180 = _uA_s0_k == _179;
      bool _181 = _177 && _180;
      if (_181)
      {
       float _183 = _uZ_shreg[0][_uA_s0_iii];
       _V_channel_array.s[_uA_s0_iii] = _183;
       (void)_uA_s0_iii;
       _V_channel_temp = 1;
      } // if _181
     } // for _uA_s0_kkk
    } // for _uA_s0_iii
    bool _184 = _V_channel_temp;
    if (_184)
    {
     write_channel_intel(_V_channel, _V_channel_array);
     (void)_V_channel_array;
    } // if _184
   } // for _uA_s0_kk_ii
  } // for _uA_s0_k
 } // for _uA_s0_i
} // kernel kernel_V
// Address spaces for kernel_yLoader
#define __address_space__ySerializer_mem_channel __global
__kernel void kernel_yLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__ySerializer_mem_channel const float *restrict _ySerializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _185 = _A_extent_0 + _A_extent_1;
 int _186 = _185 + 3;
 int _187 = _186 >> 2;
 for (int _yLoader_s0_i = 0; _yLoader_s0_i < 0 + _187; _yLoader_s0_i++)
 {
  for (int _yLoader_s0_ii_iii = 0; _yLoader_s0_ii_iii < 0 + 4; _yLoader_s0_ii_iii++)
  {
   int _188 = _addr_temp;
   float _189 = _ySerializer_mem_channel[_188];
   write_channel_intel(_yLoader_channel, _189);
   (void)_189;
   int _190 = _188 + 1;
   _addr_temp = _190;
  } // for _yLoader_s0_ii_iii
 } // for _yLoader_s0_i
} // kernel kernel_yLoader
#undef __address_space__ySerializer_mem_channel
// Address spaces for kernel_yFeeder
__kernel void kernel_yFeeder(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _191 = _A_extent_0 + _A_extent_1;
 int _192 = _191 + 3;
 int _193 = _192 >> 2;
 for (int _yFeeder_s0_i = 0; _yFeeder_s0_i < 0 + _193; _yFeeder_s0_i++)
 {
  for (int _yFeeder_s0_ii_iii = 0; _yFeeder_s0_ii_iii < 0 + 4; _yFeeder_s0_ii_iii++)
  {
   float __194 = read_channel_intel(_yLoader_channel);
   write_channel_intel(_yFeeder_channel, __194);
   (void)__194;
  } // for _yFeeder_s0_ii_iii
 } // for _yFeeder_s0_i
} // kernel kernel_yFeeder
// Address spaces for kernel_Out
__kernel void kernel_Out(
 const int _A_extent_0,
 const int _A_extent_1,
 const float _Alpha,
 const float _Beta)
{
 _V_channel_array_t _V_channel_array;
 int _195 = _A_extent_0 + _A_extent_1;
 int _196 = _195 + 3;
 int _197 = _196 >> 2;
 for (int _Out_s0_i = 0; _Out_s0_i < 0 + _197; _Out_s0_i++)
 {
  for (int _Out_s0_ii = 0; _Out_s0_ii < 0 + 2; _Out_s0_ii++)
  {
   _V_channel_array_t __198 = read_channel_intel(_V_channel);
   _V_channel_array = __198;
   (void)__198;
   for (int _Out_s0_iii = 0; _Out_s0_iii < 0 + 2; _Out_s0_iii++)
   {
    float __199 = _V_channel_array.s[_Out_s0_iii];
    float _200 = __199 * _Alpha;
    float __201 = read_channel_intel(_yFeeder_channel);
    float _202 = __201 * _Beta;
    float _203 = _200 + _202;
    write_channel_intel(_Out_channel, _203);
    (void)_203;
   } // for _Out_s0_iii
  } // for _Out_s0_ii
 } // for _Out_s0_i
} // kernel kernel_Out
// Address spaces for kernel_drainer
__kernel void kernel_drainer(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _204 = _A_extent_0 + _A_extent_1;
 int _205 = _204 + 3;
 int _206 = _205 >> 2;
 for (int _drainer_s0_i = 0; _drainer_s0_i < 0 + _206; _drainer_s0_i++)
 {
  for (int _drainer_s0_ii_iii = 0; _drainer_s0_ii_iii < 0 + 4; _drainer_s0_ii_iii++)
  {
   float __207 = read_channel_intel(_Out_channel);
   write_channel_intel(_drainer_channel, __207);
   (void)__207;
  } // for _drainer_s0_ii_iii
 } // for _drainer_s0_i
} // kernel kernel_drainer
// Address spaces for kernel_collector
__kernel void kernel_collector(
 const int _A_extent_0,
 const int _A_extent_1)
{
 int _208 = _A_extent_0 + _A_extent_1;
 int _209 = _208 + 3;
 int _210 = _209 >> 2;
 for (int _collector_s0_i = 0; _collector_s0_i < 0 + _210; _collector_s0_i++)
 {
  for (int _collector_s0_ii_iii = 0; _collector_s0_ii_iii < 0 + 4; _collector_s0_ii_iii++)
  {
   float __211 = read_channel_intel(_drainer_channel);
   write_channel_intel(_collector_channel, __211);
   (void)__211;
  } // for _collector_s0_ii_iii
 } // for _collector_s0_i
} // kernel kernel_collector
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _212 = _A_extent_0 + _A_extent_1;
 int _213 = _212 + 3;
 int _214 = _213 >> 2;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _214; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii_iii = 0; _unloader_s0_ii_iii < 0 + 4; _unloader_s0_ii_iii++)
  {
   float __215 = read_channel_intel(_collector_channel);
   int _216 = _addr_temp;
   _unloader_mem_channel[_216] = __215;
   int _217 = _addr_temp;
   int _218 = _217 + 1;
   _addr_temp = _218;
  } // for _unloader_s0_ii_iii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

