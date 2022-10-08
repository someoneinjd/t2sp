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
typedef struct { float s[64]; } float64;
typedef union {
    float s[64];
    float16 v[4];
} _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(1024))) ;
channel float64 _xLoader_channel __attribute__((depth(1024))) ;
channel float64 _xFeeder_channel __attribute__((depth(1024))) ;
channel float64 _V_channel __attribute__((depth(1024))) ;
channel float64 _yLoader_channel __attribute__((depth(1024))) ;
channel float64 _Out_channel __attribute__((depth(1024))) ;
// Address spaces for kernel_aLoader
#define __address_space__aSerializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__aSerializer const float *restrict _aSerializer_1,
 __address_space__aSerializer const float *restrict _aSerializer_2,
 __address_space__aSerializer const float *restrict _aSerializer_3,
 __address_space__aSerializer const float *restrict _aSerializer_4)
{
 int _addr_temp = 0;
 int _0 = _A_extent_1 >> 11;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _0; _aLoader_s0_i++)
 {
  int _1 = _A_extent_0 >> 6;
  for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _1; _aLoader_s0_k++)
  {
   for (int _aLoader_s0_kk_ii = 0; _aLoader_s0_kk_ii < 0 + 2048; _aLoader_s0_kk_ii++)
   {
    int _3 = _addr_temp;
    int _4 = _3 * 16;
    _aLoader_channel_array_t _temp;
    _temp.v[0] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_1 + _4));
    _temp.v[1] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_2 + _4));
    _temp.v[2] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_3 + _4));
    _temp.v[3] = vload16(0, (__address_space__aSerializer float*)(_aSerializer_4 + _4));
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
 int _addr_temp;
 _addr_temp = 0;
 int _15 = _A_extent_1 >> 11;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _15; _xLoader_s0_i++)
 {
  int _16 = _A_extent_0 >> 6;
  for (int _xLoader_s0_k = 0; _xLoader_s0_k < 0 + _16; _xLoader_s0_k++)
  {
   for (int _xLoader_s0_kk_ii = 0; _xLoader_s0_kk_ii < 0 + 33; _xLoader_s0_kk_ii++)
   {
    int _17 = _addr_temp * 64;
    float64 _18 = *((__address_space__xSerializer_mem_channel float64*)(_xSerializer_mem_channel + _17));
    write_channel_intel(_xLoader_channel, _18);
    (void)_18;
    int _19 = _addr_temp + 1;
    _addr_temp = _19;
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
 float64 __attribute__((register)) _xFeeder_channel_array;
 float64 __attribute__((register)) _xFeeder_value_shreg;
 uint _xFeeder_time_stamp_shreg;
 float64 __attribute__((register)) _xFeeder_in_v_temp;
 uint _xFeeder_cycle_temp;
 float __attribute__((memory, numbanks(64), bankwidth(4), singlepump, numwriteports(1), numreadports(1))) _xFeeder_DB_0_ibuffer[2][33][64];
 uint _20 = (uint)(ADD_UINT64_T_SUFFIX(2015));
 _xFeeder_cycle_temp = _20;
 int _21 = _A_extent_1 >> 11;
 int _22 = _A_extent_0 >> 6;
 int _23 = _21 * _22;
 int _24 = _23 * 2048;
 int _25 = _24 + 2048;
 for (int _xFeeder_s0_outermost_loop = 0; _xFeeder_s0_outermost_loop < 0 + _25; _xFeeder_s0_outermost_loop++)
 {
  uint _26 = _xFeeder_cycle_temp;
  uint _27 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _28 = _26 >> _27;
  int _29 = (int)(_28);
  int _30 = _A_extent_1 >> 11;
  int _31 = _A_extent_0 >> 6;
  int _32 = _30 * _31;
  bool _33 = _29 < _32;
  uint _34 = _26 & 2047;
  bool _35 = 2015 <= _34;
  bool _36 = _33 && _35;
  if (_36)
  {
   float64 __34 = read_channel_intel(_xLoader_channel);
   _xFeeder_in_v_temp = __34;
  } // if _33
  #pragma unroll
  for (int _xFeeder_s0_buf = 0; _xFeeder_s0_buf < 0 + 64; _xFeeder_s0_buf++)
  {
   bool _35 = _xFeeder_s0_buf == 0;
   if (_35)
   {
    _xFeeder_value_shreg = _xFeeder_in_v_temp;
    _xFeeder_time_stamp_shreg = _xFeeder_cycle_temp;
   } // if _35
   else
   {
    _xFeeder_value_shreg = _xFeeder_value_shreg;
    _xFeeder_time_stamp_shreg = _xFeeder_time_stamp_shreg;
   } // if _35 else
   _xFeeder_value_shreg = __fpga_reg(__fpga_reg(_xFeeder_value_shreg));
   _xFeeder_time_stamp_shreg = __fpga_reg(__fpga_reg(_xFeeder_time_stamp_shreg));

   uint _49 = _xFeeder_cycle_temp;
   uint _50 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _51 = _49 & _50;
   uint _52 = (uint)(ADD_UINT64_T_SUFFIX(2015));
   bool _53 = _52 <= _51;
   if (_53)
   {
    uint _59 = _xFeeder_cycle_temp;
    uint _60 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _61 = _59 >> _60;
    uint _62 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _63 = _61 & _62;
    bool _64 = (bool)(_63); 
    uint _66 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _67 = _59 & _66;
    uint _68 = _67 - 2015;
    _xFeeder_DB_0_ibuffer[_64][_68][_xFeeder_s0_buf] = _xFeeder_value_shreg.s[_xFeeder_s0_buf];
   } // if _55
   uint _74 = _xFeeder_time_stamp_shreg;
   uint _75 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _76 = _74 >> _75;
   int _77 = (int)(_76);
   int _78 = _A_extent_1 >> 11;
   int _79 = _A_extent_0 >> 6;
   int _80 = _78 * _79;
   bool _81 = _77 <= _80;
   uint _82 = (uint)(ADD_UINT64_T_SUFFIX(0));
   bool _84 = _82 < _76;
   bool _85 = _81 && _84;
   if (_85)
   {
    uint _93 = _xFeeder_time_stamp_shreg;
    uint _94 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _95 = _93 >> _94;
    uint _96 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _97 = _95 & _96;
    bool _98 = (bool)(_97);
    bool _99 = !(_98);
    uint _101 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _102 = _93 & _101;
    uint _ii = _102 & 31;
    uint _kk = _102 >> 5;
    uint _word = (64*_ii + _kk) >> 6;
    uint _elem = (64*_ii + _kk) & 63;
    uint _word_off = (64 - _elem + _xFeeder_s0_buf) >> 6;
    uint _addr = _word + (1 - _word_off);
    float _107 = _xFeeder_DB_0_ibuffer[_99][_addr][_xFeeder_s0_buf];
    uint _elem_off = (64 - _elem + _xFeeder_s0_buf) & 63;
    _xFeeder_channel_array.s[_elem_off] = _107;
    (void)_xFeeder_s0_buf;
   } // if _91
  } // for _xFeeder_s0_buf
  uint _109 = _xFeeder_time_stamp_shreg;
  uint _110 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _111 = _109 >> _110;
  int _112 = (int)(_111);
  int _113 = _A_extent_1 >> 11;
  int _114 = _A_extent_0 >> 6;
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
 float64 _xFeeder_channel_array;
 _aLoader_channel_array_t _aLoader_channel_array;
 float64 _V_channel_array;
 // produce uZ
 float _uZ_shreg[32][64];
 // produce uX
 float _uX_shreg[64];
 float _uZ_temp[64];
 // produce uA
 float _uA_shreg[64];
 int _130 = _A_extent_1 >> 11;
 for (int _uA_s0_i = 0; _uA_s0_i < 0 + _130; _uA_s0_i++)
 {
  int _131 = _A_extent_0 >> 6;
  for (int _uA_s0_k = 0; _uA_s0_k < 0 + _131; _uA_s0_k++)
  {
   for (int _uA_s0_kk_ii = 0; _uA_s0_kk_ii < 0 + 2048; _uA_s0_kk_ii++)
   {
    #pragma unroll
    for (int _dummy_s0_iii = 0; _dummy_s0_iii < 0 + 64; _dummy_s0_iii++)
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
    float64 __139 = read_channel_intel(_xFeeder_channel);
    _xFeeder_channel_array = __139;
    (void)__139;
    _aLoader_channel_array_t __140 = read_channel_intel(_aLoader_channel);
    _aLoader_channel_array = __140;
    (void)__140;
    #pragma unroll
    for (int _uA_s0_iii = 0; _uA_s0_iii < 0 + 64; _uA_s0_iii++)
    {
     float __141 = _aLoader_channel_array.s[_uA_s0_iii];
     _uA_shreg[_uA_s0_iii] = __141;
     (void)__141;
     float __142 = _xFeeder_channel_array.s[_uA_s0_iii];
     _uX_shreg[_uA_s0_iii] = __142;
     (void)__142;
     float _143;
     int _144 = _uA_s0_kk_ii >> 5;
     int _145 = _uA_s0_k * 64;
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
     bool _159 = _158 == 63;
     int _160 = _A_extent_0 >> 6;
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
 int _167 = _A_extent_1 >> 11;
 for (int _yLoader_s0_i = 0; _yLoader_s0_i < 0 + _167; _yLoader_s0_i++)
 {
  for (int _yLoader_s0_ii = 0; _yLoader_s0_ii < 0 + 32; _yLoader_s0_ii++)
  {
   int _168 = _addr_temp;
   int _169 = _168 * 64;
   float64 _170 = *((__address_space__ySerializer_mem_channel float64*)(_ySerializer_mem_channel + _169));
   write_channel_intel(_yLoader_channel, _170);
   (void)_169;
   int _171 = _168 + 1;
   _addr_temp = _171;
  } // for _yLoader_s0_ii_iii
 } // for _yLoader_s0_i
} // kernel kernel_yLoader
#undef __address_space__ySerializer_mem_channel
// Address spaces for kernel_Out
__kernel void kernel_Out(
 const int _A_extent_1,
 const float _Alpha,
 const float _Beta)
{
 int _171 = _A_extent_1 >> 11;
 for (int _Out_s0_i = 0; _Out_s0_i < 0 + _171; _Out_s0_i++)
 {
  for (int _Out_s0_ii = 0; _Out_s0_ii < 0 + 32; _Out_s0_ii++)
  {
   float64 __172 = read_channel_intel(_V_channel);
   float64 __274 = read_channel_intel(_yLoader_channel);
   float64 _277;
   #pragma unroll
   for (int _Out_s0_iii = 0; _Out_s0_iii < 0 + 64; _Out_s0_iii++)
   {
    _277.s[_Out_s0_iii] = _Alpha * __172.s[_Out_s0_iii] + _Beta * __274.s[_Out_s0_iii];
   } // for _Out_s0_iii
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
 int _178 = _A_extent_1 >> 11;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _178; _unloader_s0_i++)
 {
  for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
  {
   float64 __179 = read_channel_intel(_Out_channel);
   int _180 = _addr_temp * 64;
   *((__address_space__unloader_mem_channel float64*)(_unloader_mem_channel + _180)) = __179;
   int _181 = _addr_temp;
   int _182 = _181 + 1;
   _addr_temp = _182;
  } // for _unloader_s0_ii_iii
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

