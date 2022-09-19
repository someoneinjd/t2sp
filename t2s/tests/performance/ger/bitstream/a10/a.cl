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
typedef struct { float s; } _xLoader_channel_array_t;
channel _xLoader_channel_array_t _xLoader_channel __attribute__((depth(256))) ;
channel float _yLoader_channel __attribute__((depth(256))) ;
typedef struct { float s[16]; } _yFeeder_channel_array_t;
channel _yFeeder_channel_array_t _yFeeder_channel __attribute__((depth(256))) ;
typedef struct { float s[16]; } _aLoader_channel_array_t;
channel _aLoader_channel_array_t _aLoader_channel __attribute__((depth(256))) ;
typedef struct { float s[16]; } _uZ_channel_array_t;
channel _uZ_channel_array_t _uZ_channel __attribute__((depth(256))) ;
// Address spaces for kernel_xLoader
#define __address_space__X_serializer_mem_channel __global
__kernel void kernel_xLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__X_serializer_mem_channel const float *restrict _X_serializer_mem_channel)
{
 _xLoader_channel_array_t _xLoader_channel_array;
 int _0 = _A_extent_1 >> 4;
 for (int _xLoader_s0_i = 0; _xLoader_s0_i < 0 + _0; _xLoader_s0_i++)
 {
  int _1 = _A_extent_0 >> 4;
  for (int _xLoader_s0_j = 0; _xLoader_s0_j < 0 + _1; _xLoader_s0_j++)
  {
   for (int _xLoader_s0_ii = 0; _xLoader_s0_ii < 0 + 16; _xLoader_s0_ii++)
   {
      int _3 = _xLoader_s0_ii + 16*_xLoader_s0_i;
      float _10 = _X_serializer_mem_channel[_3];
      _xLoader_channel_array.s = _10;
      write_channel_intel(_xLoader_channel, _xLoader_channel_array);
      (void)_xLoader_channel_array;
   } // for _xLoader_s0_ii
  } // for _xLoader_s0_j
 } // for _xLoader_s0_i
} // kernel kernel_xLoader
#undef __address_space__X_serializer_mem_channel
// Address spaces for kernel_yLoader
#define __address_space__Y_serializer_mem_channel __global
__kernel void kernel_yLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__Y_serializer_mem_channel const float *restrict _Y_serializer_mem_channel)
{
 int _12 = _A_extent_1 >> 4;
 int _13 = _12 + 1;
 for (int _yLoader_s0_i = 0; _yLoader_s0_i < 0 + _13; _yLoader_s0_i++)
 {
  int _14 = _A_extent_0 >> 4;
  for (int _yLoader_s0_j = 0; _yLoader_s0_j < 0 + _14; _yLoader_s0_j++)
  {
   for (int _yLoader_s0_jj = 0; _yLoader_s0_jj < 0 + 16; _yLoader_s0_jj++)
   {
    bool _15 = _yLoader_s0_j == 0;
    int _18 = _A_extent_1 >> 4;
    bool _19 = _yLoader_s0_i < _18;
    bool _20 = _15 || _19;
    if (_20)
    {
     float _21;
     int _22 = _A_extent_1 >> 4;
     bool _23 = _yLoader_s0_i < _22;
     if (_23)
     {
      int _27 = _yLoader_s0_jj + 16*_yLoader_s0_j;
      float _28 = _Y_serializer_mem_channel[_27];
      _21 = _28;
     } // if _23
     else
     {
      float _29 = float_from_bits(0 /* 0 */);
      _21 = _29;
     } // if _23 else
     float _30 = _21;
     write_channel_intel(_yLoader_channel, _30);
     (void)_30;
    } // if _20
   } // for _yLoader_s0_jj
  } // for _yLoader_s0_j
 } // for _yLoader_s0_i
} // kernel kernel_yLoader
#undef __address_space__Y_serializer_mem_channel
// Address spaces for kernel_yFeeder
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_yFeeder(
)
{
 _yFeeder_channel_array_t _yFeeder_channel_array;
 float _yFeeder_value_shreg;
 uint _yFeeder_time_stamp_shreg;
 float _yFeeder_in_v_temp;
 uint _yFeeder_cycle_temp;
 float __attribute__((memory, numbanks(16), singlepump, numwriteports(1), numreadports(1))) _yFeeder_DB_0_ibuffer[2][16];
 uint _33 = (uint)(ADD_UINT64_T_SUFFIX(0));
 _yFeeder_cycle_temp = _33;
 while(1)
 {
  float __34 = read_channel_intel(_yLoader_channel);
  _yFeeder_in_v_temp = __34;
  #pragma unroll
  for (int _yFeeder_s0_buf = 0; _yFeeder_s0_buf < 0 + 16; _yFeeder_s0_buf++)
  {
   bool _35 = _yFeeder_s0_buf == 0;
   if (_35)
   {
    float _36 = _yFeeder_in_v_temp;
    _yFeeder_value_shreg = _36;
    (void)_36;
    uint _37 = _yFeeder_cycle_temp;
    _yFeeder_time_stamp_shreg = _37;
    (void)_37;
   } // if _35
   else
   {
    float _39 = _yFeeder_value_shreg;
    _yFeeder_value_shreg = _39;
    (void)_39;
    uint _41 = _yFeeder_time_stamp_shreg;
    _yFeeder_time_stamp_shreg = _41;
    (void)_41;
   } // if _35 else
   float _43 = _yFeeder_value_shreg;
   float _44 = __fpga_reg(__fpga_reg(_43));
   _yFeeder_value_shreg = _44;
   (void)_44;
   uint _46 = _yFeeder_time_stamp_shreg;
   uint _47 = __fpga_reg(__fpga_reg(_46));
   _yFeeder_time_stamp_shreg = _47;
   (void)_47;
   uint _49 = _yFeeder_time_stamp_shreg;
   uint _50 = (uint)(ADD_UINT64_T_SUFFIX(15));
   uint _51 = _49 & _50;
   uint _52 = _51 & _50;
   int _53 = (int)(_52);
   bool _54 = _yFeeder_s0_buf == _53;
   if (_54)
   {
    float _56 = _yFeeder_value_shreg;
    uint _58 = _yFeeder_time_stamp_shreg;
    uint _59 = (uint)(ADD_UINT64_T_SUFFIX(4));
    uint _60 = _58 >> _59;
    uint _61 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _62 = _60 & _61;
    bool _63 = (bool)(_62);
    _yFeeder_DB_0_ibuffer[_63][_yFeeder_s0_buf] = _56;
   } // if _54
   uint _65 = _yFeeder_time_stamp_shreg;
   uint _66 = (uint)(ADD_UINT64_T_SUFFIX(4));
   uint _67 = _65 >> _66;
   uint _68 = (uint)(ADD_UINT64_T_SUFFIX(1));
   uint _69 = _67 & _68;
   bool _70 = (bool)(_69);
   bool _71 = !(_70);
   float _72 = _yFeeder_DB_0_ibuffer[_71][_yFeeder_s0_buf];
   _yFeeder_channel_array.s[_yFeeder_s0_buf] = _72;
   (void)_yFeeder_s0_buf;
  } // for _yFeeder_s0_buf
  uint _73 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _75 = _yFeeder_time_stamp_shreg;
  uint _76 = (uint)(ADD_UINT64_T_SUFFIX(4));
  uint _77 = _75 >> _76;
  bool _78 = _73 < _77;
  if (_78)
  {
   write_channel_intel(_yFeeder_channel, _yFeeder_channel_array);
   (void)_yFeeder_channel_array;
  } // if _78
  uint _79 = _yFeeder_cycle_temp;
  uint _80 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _81 = _79 + _80;
  _yFeeder_cycle_temp = _81;
 } // while _yFeeder_s0_outermost_loop_infinite
} // kernel kernel_yFeeder
// Address spaces for kernel_aLoader
#define __address_space__A_serializer __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__A_serializer const float *restrict _A_serializer)
{
 _aLoader_channel_array_t _aLoader_channel_array;
 int _82 = _A_extent_1 >> 4;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _82; _aLoader_s0_i++)
 {
  int _83 = _A_extent_0 >> 4;
  for (int _aLoader_s0_j = 0; _aLoader_s0_j < 0 + _83; _aLoader_s0_j++)
  {
   for (int _aLoader_s0_ii = 0; _aLoader_s0_ii < 0 + 16; _aLoader_s0_ii++)
   {
    #pragma unroll
    for (int _aLoader_s0_jj = 0; _aLoader_s0_jj < 0 + 16; _aLoader_s0_jj++)
    {
     int _84 = _A_extent_0 >> 4;
     int _85 = _84 * _aLoader_s0_i;
     int _86 = _85 * 256;
     int _87 = _aLoader_s0_j * 256;
     int _88 = _aLoader_s0_ii * 16;
     int _89 = _88 + _aLoader_s0_jj;
     int _90 = _87 + _89;
     int _91 = _86 + _90;
     float _92 = _A_serializer[_91];
     _aLoader_channel_array.s[_aLoader_s0_jj] = _92;
     (void)_aLoader_s0_jj;
    } // for _aLoader_s0_jj
    write_channel_intel(_aLoader_channel, _aLoader_channel_array);
    (void)_aLoader_channel_array;
   } // for _aLoader_s0_ii
  } // for _aLoader_s0_j
 } // for _aLoader_s0_i
} // kernel kernel_aLoader
#undef __address_space__A_serializer
// Address spaces for kernel_uZ
__kernel void kernel_uZ(
 const int _A_extent_0,
 const int _A_extent_1)
{
 _aLoader_channel_array_t _aLoader_channel_array;
 _yFeeder_channel_array_t _yFeeder_channel_array;
 _xLoader_channel_array_t _xLoader_channel_array;
 _uZ_channel_array_t _uZ_channel_array;
 // produce uY
 float _uY_shreg[16];
 // produce uX
 float _uX_shreg;
 int _93 = _A_extent_1 >> 4;
 for (int _uX_s0_i = 0; _uX_s0_i < 0 + _93; _uX_s0_i++)
 {
  int _94 = _A_extent_0 >> 4;
  for (int _uX_s0_j = 0; _uX_s0_j < 0 + _94; _uX_s0_j++)
  {
   for (int _uX_s0_ii = 0; _uX_s0_ii < 0 + 16; _uX_s0_ii++)
   {
    _aLoader_channel_array_t __95 = read_channel_intel(_aLoader_channel);
    _aLoader_channel_array = __95;
    (void)__95;
    _yFeeder_channel_array_t __96 = read_channel_intel(_yFeeder_channel);
    _yFeeder_channel_array = __96;
    (void)__96;
    _xLoader_channel_array_t __97 = read_channel_intel(_xLoader_channel);
    _xLoader_channel_array = __97;
    (void)__97;
    #pragma unroll
    for (int _uX_s0_jj = 0; _uX_s0_jj < 0 + 16; _uX_s0_jj++)
    {
     float _98;
     bool _99 = _uX_s0_jj == 0;
     if (_99)
     {
      _98 = _xLoader_channel_array.s;
     } // if _99
     else
     {
      float _101 = _uX_shreg;
      _98 = _101;
     } // if _99 else
     float _102 = _98;
     _uX_shreg = _102;
     (void)_102;
     float _104 = _uX_shreg;
     float _105 = __fpga_reg(__fpga_reg(_104));
     _uX_shreg = _105;
     (void)_105;
     float __106 = _yFeeder_channel_array.s[_uX_s0_jj];
     _uY_shreg[_uX_s0_jj] = __106;
     (void)__106;
     float __107 = _aLoader_channel_array.s[_uX_s0_jj];
     float _109 = _uX_shreg;
     float _111 = _uY_shreg[_uX_s0_jj];
     float _112 = _109 * _111;
     float _113 = __107 + _112;
     _uZ_channel_array.s[_uX_s0_jj] = _113;
     (void)_uX_s0_jj;
    } // for _uX_s0_jj
    write_channel_intel(_uZ_channel, _uZ_channel_array);
    (void)_uZ_channel_array;
   } // for _uX_s0_ii
  } // for _uX_s0_j
 } // for _uX_s0_i
} // kernel kernel_uZ
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_0,
 const int _A_extent_1,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 _uZ_channel_array_t _uZ_channel_array;
 int _addr_temp;
 _addr_temp = 0;
 int _114 = _A_extent_1 >> 4;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _114; _unloader_s0_i++)
 {
  int _115 = _A_extent_0 >> 4;
  for (int _unloader_s0_j = 0; _unloader_s0_j < 0 + _115; _unloader_s0_j++)
  {
   for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 16; _unloader_s0_ii++)
   {
    _uZ_channel_array_t __116 = read_channel_intel(_uZ_channel);
    _uZ_channel_array = __116;
    #pragma unroll
    for (int _unloader_s0_jj = 0; _unloader_s0_jj < 0 + 16; _unloader_s0_jj++)
    {
     float __117 = _uZ_channel_array.s[_unloader_s0_jj];
     int _118 = _addr_temp;
     _unloader_mem_channel[_118] = __117;
     int _119 = _addr_temp;
     int _120 = _119 + 1;
     _addr_temp = _120;
    } // for _unloader_s0_jj
   } // for _unloader_s0_ii
  } // for _unloader_s0_j
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

