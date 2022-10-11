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
float __attribute__ ((aligned(128))) s[32];
struct {float s0,  s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8,  s9,  sa,  sb,  sc,  sd,  se,  sf,  s16,  s17,  s18,  s19,  s20,  s21,  s22,  s23,  s24,  s25,  s26,  s27,  s28,  s29,  s30,  s31;};
} float32;
typedef union {
bool __attribute__ ((aligned(32))) s[32];
struct {bool s0,  s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8,  s9,  sa,  sb,  sc,  sd,  se,  sf,  s16,  s17,  s18,  s19,  s20,  s21,  s22,  s23,  s24,  s25,  s26,  s27,  s28,  s29,  s30,  s31;};
} bool32;
typedef union {
int __attribute__ ((aligned(128))) s[32];
struct {int s0,  s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8,  s9,  sa,  sb,  sc,  sd,  se,  sf,  s16,  s17,  s18,  s19,  s20,  s21,  s22,  s23,  s24,  s25,  s26,  s27,  s28,  s29,  s30,  s31;};
} int32;
typedef union {
   float s[32]; 
   float16 v[2];
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(1024))) ;
channel float32 _xLoader_channel __attribute__((depth(1024))) ;
channel float32 _xFeeder_channel __attribute__((depth(1024))) ;
channel float32 _V_channel __attribute__((depth(1024))) ;
channel float32 _yLoader_channel __attribute__((depth(1024))) ;
channel float32 _Out_channel __attribute__((depth(1024))) ;
// Address spaces for kernel_aLoader
#define __address_space__aSerializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__aSerializer const float *restrict _aSerializer_1,
 __address_space__aSerializer const float *restrict _aSerializer_2)
{
 int _addr_temp = 0;
 _aLoader_channel_array_t _aLoader_channel_array;
 int _0 = _A_extent_1 >> 10;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _0; _aLoader_s0_i++)
 {
  int _1 = _A_extent_0 + 31;
  int _2 = _1 >> 5;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _2; _aLoader_s0_k++)
  {
   for (int _aLoader_s0_kk_ii = 0; _aLoader_s0_kk_ii < 0 + 1024; _aLoader_s0_kk_ii++)
   {
    int _3 = _addr_temp;
    int _4 = _3 * 16;
    _aLoader_channel_array_t _temp;
    _temp.v[0] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_1 + _4));
    _temp.v[1] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_2 + _4));
    write_channel_intel(_aLoader_channel, _temp);
    _addr_temp += 1;
   } // for _aLoader_s0_kk_ii
  } // for _aLoader_s0_k
 } // for _aLoader_s0_i
} // kernel kernel_aLoader
#undef __address_space__aSerializer
// Address spaces for kernel_xLoader
#define __address_space__xSerializer_mem_channel __global
__kernel void kernel_xLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__xSerializer_mem_channel const float *restrict _xSerializer_mem_channel)
{
 int _addr_temp = 0;
 int _15 = _A_extent_1 >> 10;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _15; _xLoader_s0_i++)
 {
  int _16 = _A_extent_0 >> 5;
  for (int _xLoader_s0_k = 0; _xLoader_s0_k < 0 + _16; _xLoader_s0_k++)
  {
   for (int _xLoader_s0_kk_ii = 0; _xLoader_s0_kk_ii < 0 + 33; _xLoader_s0_kk_ii++)
   {
    int _17 = _addr_temp * 32;
    float32 _18 = *((__address_space__xSerializer_mem_channel float32*)(_xSerializer_mem_channel + _17));
    write_channel_intel(_xLoader_channel, _18);
    (void)_18;
    _addr_temp += 1;
   } // for _xLoader_s0_kk_ii_iii
  } // for _xLoader_s0_k
 } // for _xLoader_s0_i
} // kernel kernel_xLoader
#undef __address_space__xSerializer_mem_channel
// Address spaces for kernel_xFeeder
__kernel void kernel_xFeeder(
 const int _A_extent_0,
 const int _A_extent_1)
{
 float32 __attribute__((register)) _xFeeder_channel_array;
 float32 __attribute__((register)) _xFeeder_value_shreg;
 uint _xFeeder_time_stamp_shreg;
 float32 __attribute__((register)) _xFeeder_in_v_temp;
 uint _xFeeder_cycle_temp;
 float __attribute__((memory, numbanks(32), bankwidth(4), singlepump, numwriteports(1), numreadports(1))) _xFeeder_DB_0_ibuffer[2][33][32];
 uint _20 = (uint)(ADD_UINT64_T_SUFFIX(991));
 _xFeeder_cycle_temp = _20;
 int _21 = _A_extent_1 >> 10;
 int _22 = _A_extent_0 >> 5;
 int _23 = _21 * _22;
 int _24 = _23 * 1024;
 int _25 = _24 + 1024;
 for (int _xFeeder_s0_outermost_loop = 0; _xFeeder_s0_outermost_loop < 0 + _25; _xFeeder_s0_outermost_loop++)
 {
  uint _26 = _xFeeder_cycle_temp;
  uint _27 = (uint)(ADD_UINT64_T_SUFFIX(10));
  uint _28 = _26 >> _27;
  int _29 = (int)(_28);
  int _30 = _A_extent_1 >> 10;
  int _31 = _A_extent_0 >> 5;
  int _32 = _30 * _31;
  bool _33 = _29 < _32;
  uint _34 = _26 & 1023;
  bool _35 = 991 <= _34;
  bool _36 = _33 && _35;
  if (_36)
  {
   float32 __34 = read_channel_intel(_xLoader_channel);
   _xFeeder_in_v_temp = __34;
  } // if _33
  #pragma unroll
  for (int _xFeeder_s0_buf = 0; _xFeeder_s0_buf < 0 + 32; _xFeeder_s0_buf++)
  {
   bool _41 = _xFeeder_s0_buf == 0;
   if (_41)
   {
    _xFeeder_value_shreg = _xFeeder_in_v_temp;
    _xFeeder_time_stamp_shreg = _xFeeder_cycle_temp;
   } // if _41
   else
   {
    _xFeeder_value_shreg = _xFeeder_value_shreg;
    _xFeeder_time_stamp_shreg = _xFeeder_time_stamp_shreg;
   } // if _41 else
   _xFeeder_value_shreg = __fpga_reg(__fpga_reg(_xFeeder_value_shreg));
   _xFeeder_time_stamp_shreg = __fpga_reg(__fpga_reg(_xFeeder_time_stamp_shreg));

   uint _49 = _xFeeder_cycle_temp;
   uint _50 = (uint)(ADD_UINT64_T_SUFFIX(1023));
   uint _51 = _49 & _50;
   uint _52 = (uint)(ADD_UINT64_T_SUFFIX(991));
   bool _55 =  _52 <= _51;
   if (_55)
   {
    uint _59 = _xFeeder_cycle_temp;
    uint _60 = (uint)(ADD_UINT64_T_SUFFIX(10));
    uint _61 = _59 >> _60;
    uint _62 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _63 = _61 & _62;
    uint _64 = (uint)(ADD_UINT64_T_SUFFIX(1023));
    uint _65 = _59 & _64;
    uint _66 = _65 - 991;
    _xFeeder_DB_0_ibuffer[_63][_66][_xFeeder_s0_buf] = _xFeeder_value_shreg.s[_xFeeder_s0_buf];
   } // _55
   uint _74 = _xFeeder_cycle_temp;
   uint _75 = (uint)(ADD_UINT64_T_SUFFIX(10));
   uint _76 = _74 >> _75;
   int _77 = (int)(_76);
   int _78 = _A_extent_1 >> 10;
   int _79 = _A_extent_0 >> 5;
   int _80 = _78 * _79;
   bool _81 = _77 <= _80;
   uint _82 = (uint)(ADD_UINT64_T_SUFFIX(0));
   bool _84 = _82 < _77;
   bool _85 = _81 && _84;
   if (_85)
   {
    uint _93 = _xFeeder_cycle_temp;
    uint _94 = (uint)(ADD_UINT64_T_SUFFIX(10));
    uint _95 = _93 >> _94;
    uint _96 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _97 = _95 & _96;
    bool _98 = (bool)(_97);
    bool _99 = !(_98);
    uint _101 = (uint)(ADD_UINT64_T_SUFFIX(1023));
    uint _102 = _93 & _101;
    uint _ii = _102 & 31;
    uint _kk = _102 >> 5;
    uint _word = (_ii*32 + _kk) >> 5;
    uint _elem = (_ii*32 + _kk) & 31;
    uint _word_off = (32 - _elem + _xFeeder_s0_buf) >> 5;
    uint _addr = _word + (1 - _word_off);
    float _107 = _xFeeder_DB_0_ibuffer[_99][_addr][_xFeeder_s0_buf];
    uint _elem_off = (32 - _elem + _xFeeder_s0_buf) & 31;
    _xFeeder_channel_array.s[_elem_off] = _107;
   } // if _85
  } // for _xFeeder_s0_buf
  uint _109 = _xFeeder_cycle_temp;
  uint _110 = (uint)(ADD_UINT64_T_SUFFIX(10));
  uint _111 = _109 >> _110;
  int _112 = (int)(_111);
  int _113 = _A_extent_1 >> 10;
  int _114 = _A_extent_0 >> 5;
  int _115 = _113 * _114;
  bool _116 = _112 <= _115;
  uint _123 = (uint)(ADD_UINT64_T_SUFFIX(0));
  bool _125 = _123 < _112;
  bool _126 = _116 && _125;
  if (_126)
  {
   write_channel_intel(_xFeeder_channel, _xFeeder_channel_array);
   (void)_xFeeder_channel_array;
  } // if _126
  uint _127 = _xFeeder_cycle_temp;
  uint _128 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _129 = _127 + _128;
  _xFeeder_cycle_temp = _129;
 } // for _xFeeder_s0_outermost_loop
} // kernel kernel_xFeeder
// Address spaces for kernel_V
__kernel void kernel_V(
 const int _A_extent_0,
 const int _A_extent_1)
{
 float32 _xFeeder_channel_array;
 _aLoader_channel_array_t _aLoader_channel_array;
 float32 _V_channel_array;
 // produce uZ
 float _uZ_shreg[32][32];
 // produce uX
 float _uX_shreg[32];
 float _uZ_temp[32];
 // produce uA
 float _uA_shreg[32];
 int _130 = _A_extent_1 >> 10;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _130; _uA_s0_i++)
 {
  int _131 = _A_extent_0 >> 5;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _131; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 1024; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 32; _dummy_s0_iii++)
    {
     float _133 = _uZ_shreg[31][_dummy_s0_iii];
     _uZ_temp[_dummy_s0_iii] = _133;
     #pragma unroll
     for (int _dummy__1_s0_l0 = 0; _dummy__1_s0_l0 < 0 + 31; _dummy__1_s0_l0++)
     {
      int _134 = 31 - _dummy__1_s0_l0;
      int _135 = 30 - _dummy__1_s0_l0;
      float _137 = _uZ_shreg[_135][_dummy_s0_iii];
      _uZ_shreg[_134][_dummy_s0_iii] = _137;
      (void)_137;
     } // for _dummy__1_s0_l0
     float _138 = _uZ_temp[_dummy_s0_iii];
     _uZ_shreg[0][_dummy_s0_iii] = _138;
     (void)_138;
    } // for _dummy_s0_iii
    bool _V_channel_temp;
    _V_channel_temp = 0;
    float32 __139 = read_channel_intel(_xFeeder_channel);
    _xFeeder_channel_array = __139;
    (void)__139;
    _aLoader_channel_array_t __140 = read_channel_intel(_aLoader_channel);
    _aLoader_channel_array = __140;
    (void)__140;
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 32; _uA_s0_iii++)
    {
     float __141 = _aLoader_channel_array.s[_uA_s0_iii];
     _uA_shreg[_uA_s0_iii] = __141;
     (void)__141;
     float __142 = _xFeeder_channel_array.s[_uA_s0_iii];
     _uX_shreg[_uA_s0_iii] = __142;
     (void)__142;
     float _143;
     int _144 = _uA_s0_kk_ii >> 5;
     int _145 = _uA_s0_k * 32;
     int _146 = _144 + _145;
     bool _147 = _146 == 0;
     if (_147)
     {
      float _148 = float_from_bits(0 /* 0 */);
      _143 = _148;
     } // if _147
     else
     {
      float _150 = _uZ_shreg[0][_uA_s0_iii];
      _143 = _150;
     } // if _147 else
     float _151 = _143;
     float _153 = _uA_shreg[_uA_s0_iii];
     float _155 = _uX_shreg[_uA_s0_iii];
     float _156 = _153 * _155;
     float _157 = _151 + _156;
     _uZ_shreg[0][_uA_s0_iii] = _157;
     (void)_157;
     int _158 = _uA_s0_kk_ii >> 5;
     bool _159 = _158 == 31;
     int _160 = _A_extent_0 >> 5;
     int _161 = _160 + -1;
     bool _162 = _uA_s0_k == _161;
     bool _163 = _159 && _162;
     if (_163)
     {
      float _165 = _uZ_shreg[0][_uA_s0_iii];
      _V_channel_array.s[_uA_s0_iii] = _165;
      (void)_uA_s0_iii;
      _V_channel_temp = 1;
     } // if _163
    } // for _uA_s0_iii
    bool _166 = _V_channel_temp;
    if (_166)
    {
     write_channel_intel(_V_channel, _V_channel_array);
     (void)_V_channel_array;
    } // if _166
   } // for _uA_s0_kk_ii
  } // for _uA_s0_k
 } // for _uA_s0_i
} // kernel kernel_V
// Address spaces for kernel_yLoader
#define __address_space__ySerializer_mem_channel __global
__kernel void kernel_yLoader(
 const int _A_extent_1,
 __address_space__ySerializer_mem_channel const float *restrict _ySerializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _167 = _A_extent_1 >> 10;
 for (int _yLoader_s0_i = 0; _yLoader_s0_i < 0 + _167; _yLoader_s0_i++)
 {
  for (int _yLoader_s0_ii = 0; _yLoader_s0_ii < 0 + 32; _yLoader_s0_ii++)
  {
   int _168 = _addr_temp;
   int _169 = _168 * 32;
   float32 _170 = *((__address_space__ySerializer_mem_channel float32*)(_ySerializer_mem_channel + _169));
   write_channel_intel(_yLoader_channel, _170);
   (void)_170;
   int _171 = _168 + 1;
   _addr_temp = _171;
  } // for _yLoader_s0_ii
 } // for _yLoader_s0_i
} // kernel kernel_yLoader
#undef __address_space__ySerializer_mem_channel
// Address spaces for kernel_Out
__kernel void kernel_Out(
 const int _A_extent_1,
 const float _Alpha,
 const float _Beta)
{
 int _172 = _A_extent_1 >> 10;
 for (int _Out_s0_i = 0; _Out_s0_i < 0 + _172; _Out_s0_i++)
 {
  for (int _Out_s0_ii = 0; _Out_s0_ii < 0 + 32; _Out_s0_ii++)
  {
   float32 __173 = read_channel_intel(_V_channel);
   float32 __274 = read_channel_intel(_yLoader_channel);
   float32 _277;
   #pragma unroll
   for (int _Out_s0_iii = 0; _Out_s0_iii < 32; _Out_s0_iii++)
   {
    _277.s[_Out_s0_iii] = _Alpha * __173.s[_Out_s0_iii] + _Beta * __274.s[_Out_s0_iii];
   }
   write_channel_intel(_Out_channel, _277);
   (void)_277;
  } // for _Out_s0_ii
 } // for _Out_s0_i
} // kernel kernel_Out
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _278 = _A_extent_1 >> 10;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _278; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
  {
   float32 __279 = read_channel_intel(_Out_channel);
   int _280 = _addr_temp;
   int _281 = _280 * 32;
   *((__address_space__unloader_mem_channel float32*)(_unloader_mem_channel + _281)) = __279;
   int _282 = _addr_temp;
   int _283 = _282 + 1;
   _addr_temp = _283;
  } // for _unloader_s0_ii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

