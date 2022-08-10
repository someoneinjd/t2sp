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
bool __attribute__ ((aligned(16))) s[16];
struct {bool s0,  s1,  s2,  s3,  s4,  s5,  s6,  s7,  s8,  s9,  sa,  sb,  sc,  sd,  se,  sf;};
} bool16;
typedef union {
bool __attribute__ ((aligned(8))) s[8];
struct {bool s0,  s1,  s2,  s3,  s4,  s5,  s6,  s7;};
} bool8;
channel float16 _ALoader_channel __attribute__((depth(256))) ;
typedef struct { float16 s[8]; } _AFeeder_channel_array_t;
channel _AFeeder_channel_array_t _AFeeder_channel __attribute__((depth(256))) ;
channel float16 _BLoader_channel __attribute__((depth(256))) ;
typedef struct { float16 s[8]; } _BFeeder_channel_array_t;
channel _BFeeder_channel_array_t _BFeeder_channel __attribute__((depth(256))) ;
channel float8 _Out_channel __attribute__((depth(256))) ;
// Address spaces for kernel_ALoader
#define __address_space__ASerializer_mem_channel __global
__kernel void kernel_ALoader(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__ASerializer_mem_channel const float *restrict _ASerializer_mem_channel)
{
 int _0 = _A_extent_1 >> 7;
 int _1 = _0 + 1;
 for (int _ALoader_s0_i = 0; _ALoader_s0_i < 0 + _1; _ALoader_s0_i++)
 {
  int _2 = _B_extent_0 >> 7;
  int _3 = _2 - _ALoader_s0_i + ((_ALoader_s0_i < _0) ? 0 : 1);
  for (int _ALoader_s0_j = _ALoader_s0_i; _ALoader_s0_j < _ALoader_s0_i + _3; _ALoader_s0_j++)
  {
   int _4 = _A_extent_0 >> 7;
   for (int _ALoader_s0_k = 0; _ALoader_s0_k < 0 + _4; _ALoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 8; _ALoader_s0_kk++)
    {
     for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 16; _ALoader_s0_ii++)
     {
      for (int _ALoader_s0_iii = 0; _ALoader_s0_iii < 0 + 8; _ALoader_s0_iii++)
      {
       bool _5 = _ALoader_s0_j == _ALoader_s0_i;
       bool _6 = _ALoader_s0_k == 0;
       bool _7 = _5 && _6;
       int _8 = _A_extent_1 >> 7;
       bool _9 = _ALoader_s0_i < _8;
       bool _10 = _7 || _9;
       if (_10)
       {
        float16 _12;
        int _13 = _A_extent_1 >> 7;
        bool _14 = _ALoader_s0_i < _13;
        if (_14)
        {
         int _18 = _ALoader_s0_iii*16 + _ALoader_s0_ii*128 + _ALoader_s0_kk*2048;
         int _19 = _18 + _ALoader_s0_k*16384;
         int _20 = _19 + _ALoader_s0_i*16384*_4;
         float16 _27 = vload16(0, (__address_space__ASerializer_mem_channel float*)_ASerializer_mem_channel + _20);
         _12 = _27;
        } // if _14
        else
        {
         float _28 = float_from_bits(0 /* 0 */);
         float16 _29 = _28;
         _12 = _29;
        } // if _14 else
        float16 _30 = _12;
        write_channel_intel(_ALoader_channel, _30);
        (void)_30;
       } // if _10
      } // for _ALoader_s0_iii
     } // for _ALoader_s0_ii
    } // for _ALoader_s0_kk
   } // for _ALoader_s0_k
  } // for _ALoader_s0_j
 } // for _ALoader_s0_i
} // kernel kernel_ALoader
#undef __address_space__ASerializer_mem_channel
// Address spaces for kernel_AFeeder
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_AFeeder(
)
{
 _AFeeder_channel_array_t _AFeeder_channel_array;
 float16 _AFeeder_value_shreg;
 uint _AFeeder_time_stamp_shreg;
 float16 _AFeeder_in_v_temp;
 uint _AFeeder_cycle_temp;
 float16 __attribute__((memory, numbanks(8), singlepump, numwriteports(1), numreadports(1))) _AFeeder_DB_0_ibuffer[2][8][16][8];
 #pragma unroll
 for (int _AFeeder_s0_jjj_init = 0; _AFeeder_s0_jjj_init < 0 + 8; _AFeeder_s0_jjj_init++)
 {
  bool _33 = _AFeeder_s0_jjj_init == 0;
  if (_33)
  {
   uint _34 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   _AFeeder_cycle_temp = _34;
  } // if _33
 } // for _AFeeder_s0_jjj_init
 while(1)
 {
  uint _35 = (uint)(ADD_UINT64_T_SUFFIX(1024));
  uint _36 = _AFeeder_cycle_temp;
  uint _37 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _38 = _36 & _37;
  bool _39 = _35 <= _38;
  if (_39)
  {
   float16 __40 = read_channel_intel(_ALoader_channel);
   _AFeeder_in_v_temp = __40;
  } // if _39
  #pragma unroll
  for (int _AFeeder_s0_buf = 0; _AFeeder_s0_buf < 0 + 8; _AFeeder_s0_buf++)
  {
   bool _41 = _AFeeder_s0_buf == 0;
   if (_41)
   {
    float16 _42 = _AFeeder_in_v_temp;
    _AFeeder_value_shreg = _42;
    (void)_42;
    uint _43 = _AFeeder_cycle_temp;
    _AFeeder_time_stamp_shreg = _43;
    (void)_43;
   } // if _41
   else
   {
    float16 _45 = _AFeeder_value_shreg;
    _AFeeder_value_shreg = _45;
    (void)_45;
    uint _47 = _AFeeder_time_stamp_shreg;
    _AFeeder_time_stamp_shreg = _47;
    (void)_47;
   } // if _41 else
   float16 _49 = _AFeeder_value_shreg;
   float16 _50 = __fpga_reg(__fpga_reg(_49));
   _AFeeder_value_shreg = _50;
   (void)_50;
   uint _52 = _AFeeder_time_stamp_shreg;
   uint _53 = __fpga_reg(__fpga_reg(_52));
   _AFeeder_time_stamp_shreg = _53;
   (void)_53;
   uint _54 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   uint _56 = _AFeeder_time_stamp_shreg;
   uint _57 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _58 = _56 & _57;
   bool _59 = _54 <= _58;
   if (_59)
   {
    uint _61 = _AFeeder_time_stamp_shreg;
    uint _62 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _63 = _61 & _62;
    uint _64 = (uint)(ADD_UINT64_T_SUFFIX(1024));
    uint _65 = _63 - _64;
    uint _66 = (uint)(ADD_UINT64_T_SUFFIX(7));
    uint _67 = _65 & _66;
    int _68 = (int)(_67);
    bool _69 = _AFeeder_s0_buf == _68;
    if (_69)
    {
     float16 _71 = _AFeeder_value_shreg;
     uint _73 = _AFeeder_time_stamp_shreg;
     uint _74 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _75 = _73 >> _74;
     uint _76 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _77 = _75 & _76;
     bool _78 = (bool)(_77);
     uint _80 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _81 = _73 & _80;
     uint _82 = (uint)(ADD_UINT64_T_SUFFIX(1024));
     uint _83 = _81 - _82;
     int _84 = (int)(_83);
     int _85 = _84 >> 7;
     int _87 = _84 >> 3;
     int _88 = _87 & 15;
     _AFeeder_DB_0_ibuffer[_78][_85][_88][_AFeeder_s0_buf] = _71;
    } // if _69
   } // if _59
   uint _89 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _91 = _AFeeder_time_stamp_shreg;
   uint _92 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _93 = _91 >> _92;
   bool _94 = _89 < _93;
   if (_94)
   {
    uint _96 = _AFeeder_time_stamp_shreg;
    uint _97 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _98 = _96 & _97;
    int _99 = (int)(_98);
    uint _100 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _101 = _96 >> _100;
    uint _102 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _103 = _101 & _102;
    bool _104 = (bool)(_103);
    bool _105 = !(_104);
    int _106 = _99 >> 8;
    int _107 = _99 >> 4;
    int _108 = _107 & 15;
    float16 _109 = _AFeeder_DB_0_ibuffer[_105][_106][_108][_AFeeder_s0_buf];
    _AFeeder_channel_array.s[_AFeeder_s0_buf] = _109;
    (void)_AFeeder_s0_buf;
   } // if _94
  } // for _AFeeder_s0_buf
  uint _110 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _112 = _AFeeder_time_stamp_shreg;
  uint _113 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _114 = _112 >> _113;
  bool _115 = _110 < _114;
  if (_115)
  {
   write_channel_intel(_AFeeder_channel, _AFeeder_channel_array);
   (void)_AFeeder_channel_array;
  } // if _115
  uint _116 = _AFeeder_cycle_temp;
  uint _117 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _118 = _116 + _117;
  _AFeeder_cycle_temp = _118;
 } // while _AFeeder_s0_outermost_loop_infinite
} // kernel kernel_AFeeder
// Address spaces for kernel_BLoader
#define __address_space__BSerializer_mem_channel __global
__kernel void kernel_BLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__BSerializer_mem_channel const float *restrict _BSerializer_mem_channel)
{
 int _119 = _A_extent_1 >> 7;
 int _120 = _119 + 1;
 for (int _BLoader_s0_i = 0; _BLoader_s0_i < 0 + _120; _BLoader_s0_i++)
 {
  int _121 = _B_extent_0 >> 7;
  int _122 = _121 - _BLoader_s0_i + ((_BLoader_s0_i < _119) ? 0 : 1);
  for (int _BLoader_s0_j = _BLoader_s0_i; _BLoader_s0_j < _BLoader_s0_i + _122; _BLoader_s0_j++)
  {
   int _123 = _A_extent_0 >> 7;
   for (int _BLoader_s0_k = 0; _BLoader_s0_k < 0 + _123; _BLoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _BLoader_s0_kk = 0; _BLoader_s0_kk < 0 + 8; _BLoader_s0_kk++)
    {
     for (int _BLoader_s0_jj = 0; _BLoader_s0_jj < 0 + 16; _BLoader_s0_jj++)
     {
      for (int _BLoader_s0_jjj = 0; _BLoader_s0_jjj < 0 + 8; _BLoader_s0_jjj++)
      {
       bool _124 = _BLoader_s0_j == _BLoader_s0_i;
       bool _125 = _BLoader_s0_k == 0;
       bool _126 = _124 && _125;
       int _127 = _A_extent_1 >> 7;
       bool _128 = _BLoader_s0_i < _127;
       bool _129 = _126 || _128;
       if (_129)
       {
        float16 _130;
        int _131 = _A_extent_1 >> 7;
        bool _132 = _BLoader_s0_i < _131;
        if (_132)
        {
         int _18 = _BLoader_s0_jjj*16 + _BLoader_s0_jj*128 + _BLoader_s0_kk*2048;
         int _19 = _18 + _BLoader_s0_k*16384;
         int _20 = _19 + _BLoader_s0_j*16384*_123;
         float16 _141 = vload16(0, (__address_space__BSerializer_mem_channel float*)_BSerializer_mem_channel + _20);
         _130 = _141;
        } // if _132
        else
        {
         float _142 = float_from_bits(0 /* 0 */);
         float16 _143 = _142;
         _130 = _143;
        } // if _132 else
        float16 _144 = _130;
        write_channel_intel(_BLoader_channel, _144);
        (void)_144;
       } // if _129
      } // for _BLoader_s0_jjj
     } // for _BLoader_s0_jj
    } // for _BLoader_s0_kk
   } // for _BLoader_s0_k
  } // for _BLoader_s0_j
 } // for _BLoader_s0_i
} // kernel kernel_BLoader
#undef __address_space__BSerializer_mem_channel
// Address spaces for kernel_BFeeder
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_BFeeder(
)
{
 _BFeeder_channel_array_t _BFeeder_channel_array;
 float16 _BFeeder_value_shreg;
 uint _BFeeder_time_stamp_shreg;
 float16 _BFeeder_in_v_temp;
 uint _BFeeder_cycle_temp;
 float16 __attribute__((memory, numbanks(8), singlepump, numwriteports(1), numreadports(1))) _BFeeder_DB_0_ibuffer[2][8][16][8];
 #pragma unroll
 for (int _BFeeder_s0_iii_init = 0; _BFeeder_s0_iii_init < 0 + 8; _BFeeder_s0_iii_init++)
 {
  bool _147 = _BFeeder_s0_iii_init == 0;
  if (_147)
  {
   uint _148 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   _BFeeder_cycle_temp = _148;
  } // if _147
 } // for _BFeeder_s0_iii_init
 while(1)
 {
  uint _149 = (uint)(ADD_UINT64_T_SUFFIX(1024));
  uint _150 = _BFeeder_cycle_temp;
  uint _151 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _152 = _150 & _151;
  bool _153 = _149 <= _152;
  if (_153)
  {
   float16 __154 = read_channel_intel(_BLoader_channel);
   _BFeeder_in_v_temp = __154;
  } // if _153
  #pragma unroll
  for (int _BFeeder_s0_buf = 0; _BFeeder_s0_buf < 0 + 8; _BFeeder_s0_buf++)
  {
   bool _155 = _BFeeder_s0_buf == 0;
   if (_155)
   {
    float16 _156 = _BFeeder_in_v_temp;
    _BFeeder_value_shreg = _156;
    (void)_156;
    uint _157 = _BFeeder_cycle_temp;
    _BFeeder_time_stamp_shreg = _157;
    (void)_157;
   } // if _155
   else
   {
    float16 _159 = _BFeeder_value_shreg;
    _BFeeder_value_shreg = _159;
    (void)_159;
    uint _161 = _BFeeder_time_stamp_shreg;
    _BFeeder_time_stamp_shreg = _161;
    (void)_161;
   } // if _155 else
   float16 _163 = _BFeeder_value_shreg;
   float16 _164 = __fpga_reg(__fpga_reg(_163));
   _BFeeder_value_shreg = _164;
   (void)_164;
   uint _166 = _BFeeder_time_stamp_shreg;
   uint _167 = __fpga_reg(__fpga_reg(_166));
   _BFeeder_time_stamp_shreg = _167;
   (void)_167;
   uint _168 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   uint _170 = _BFeeder_time_stamp_shreg;
   uint _171 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _172 = _170 & _171;
   bool _173 = _168 <= _172;
   if (_173)
   {
    uint _175 = _BFeeder_time_stamp_shreg;
    uint _176 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _177 = _175 & _176;
    uint _178 = (uint)(ADD_UINT64_T_SUFFIX(1024));
    uint _179 = _177 - _178;
    uint _180 = (uint)(ADD_UINT64_T_SUFFIX(7));
    uint _181 = _179 & _180;
    int _182 = (int)(_181);
    bool _183 = _BFeeder_s0_buf == _182;
    if (_183)
    {
     float16 _185 = _BFeeder_value_shreg;
     uint _187 = _BFeeder_time_stamp_shreg;
     uint _188 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _189 = _187 >> _188;
     uint _190 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _191 = _189 & _190;
     bool _192 = (bool)(_191);
     uint _194 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _195 = _187 & _194;
     uint _196 = (uint)(ADD_UINT64_T_SUFFIX(1024));
     uint _197 = _195 - _196;
     int _198 = (int)(_197);
     int _199 = _198 >> 7;
     int _201 = _198 >> 3;
     int _202 = _201 & 15;
     _BFeeder_DB_0_ibuffer[_192][_199][_202][_BFeeder_s0_buf] = _185;
    } // if _183
   } // if _173
   uint _203 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _205 = _BFeeder_time_stamp_shreg;
   uint _206 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _207 = _205 >> _206;
   bool _208 = _203 < _207;
   if (_208)
   {
    uint _210 = _BFeeder_time_stamp_shreg;
    uint _211 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _212 = _210 & _211;
    int _213 = (int)(_212);
    uint _214 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _215 = _210 >> _214;
    uint _216 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _217 = _215 & _216;
    bool _218 = (bool)(_217);
    bool _219 = !(_218);
    int _220 = _213 >> 8;
    int _221 = _213 & 15;
    float16 _222 = _BFeeder_DB_0_ibuffer[_219][_220][_221][_BFeeder_s0_buf];
    _BFeeder_channel_array.s[_BFeeder_s0_buf] = _222;
    (void)_BFeeder_s0_buf;
   } // if _208
  } // for _BFeeder_s0_buf
  uint _223 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _225 = _BFeeder_time_stamp_shreg;
  uint _226 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _227 = _225 >> _226;
  bool _228 = _223 < _227;
  if (_228)
  {
   write_channel_intel(_BFeeder_channel, _BFeeder_channel_array);
   (void)_BFeeder_channel_array;
  } // if _228
  uint _229 = _BFeeder_cycle_temp;
  uint _230 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _231 = _229 + _230;
  _BFeeder_cycle_temp = _231;
 } // while _BFeeder_s0_outermost_loop_infinite
} // kernel kernel_BFeeder
// Address spaces for kernel_Out
__kernel void kernel_Out(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0)
{
 _BFeeder_channel_array_t _BFeeder_channel_array;
 _AFeeder_channel_array_t _AFeeder_channel_array;
 // produce Z
 float _Z_shreg[256][8][8];
 float _Z_pipe_shreg[8][1793];
 // produce Y
 float16 _Y_shreg[8];
 float _Z_temp[8][8];
 // produce X
 float16 _X_shreg[8];
 float _Z_shreg_temp;
 int _Z_pipe_iter_temp;
 int _Z_pipe_base_temp;
 _Z_pipe_iter_temp = 2048;
 _Z_pipe_base_temp = 0;
 int _232 = _A_extent_1 >> 7;
 int _234 = _B_extent_0 >> 7;
 int _233 = (2 * _234 - _232 + 1) * _232 / 2;
 int _235 = _233 + 1;
 for (int _X_s0_i_j = 0; _X_s0_i_j < 0 + _235; _X_s0_i_j++)
 {
   int _236 = _A_extent_0 >> 7;
   for (int _X_s0_k = 0; _X_s0_k < 0 + _236; _X_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _X_s0_kk = 0; _X_s0_kk < 0 + 8; _X_s0_kk++)
    {
     for (int _X_s0_ii = 0; _X_s0_ii < 0 + 16; _X_s0_ii++)
     {
      for (int _X_s0_jj = 0; _X_s0_jj < 0 + 16; _X_s0_jj++)
      {
       #pragma unroll
       for (int _dummy__1_s0_iii = 0; _dummy__1_s0_iii < 0 + 8; _dummy__1_s0_iii++)
       {
        #pragma unroll
        for (int _dummy_s0_jjj = 0; _dummy_s0_jjj < 0 + 8; _dummy_s0_jjj++)
        {
         float _238 = _Z_shreg[255][_dummy_s0_jjj][_dummy__1_s0_iii];
         _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii] = _238;
         #pragma unroll
         for (int _dummy__2_s0_l1 = 0; _dummy__2_s0_l1 < 0 + 255; _dummy__2_s0_l1++)
         {
          int _239 = 255 - _dummy__2_s0_l1;
          int _240 = 254 - _dummy__2_s0_l1;
          float _242 = _Z_shreg[_240][_dummy_s0_jjj][_dummy__1_s0_iii];
          _Z_shreg[_239][_dummy_s0_jjj][_dummy__1_s0_iii] = _242;
          (void)_242;
         } // for _dummy__2_s0_l1
         float _243 = _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii];
         _Z_shreg[0][_dummy_s0_jjj][_dummy__1_s0_iii] = _243;
         (void)_243;
        } // for _dummy_s0_jjj
       } // for _dummy__1_s0_iii
       bool _245 = _X_s0_i_j < _233;
       if (_245)
       {
        _BFeeder_channel_array_t __246 = read_channel_intel(_BFeeder_channel);
        _BFeeder_channel_array = __246;
        (void)__246;
        _AFeeder_channel_array_t __247 = read_channel_intel(_AFeeder_channel);
        _AFeeder_channel_array = __247;
        (void)__247;
       } // if _245
       #pragma unroll
       for (int _X_s0_iii = 0; _X_s0_iii < 0 + 8; _X_s0_iii++)
       {
        #pragma unroll
        for (int _X_s0_jjj = 0; _X_s0_jjj < 0 + 8; _X_s0_jjj++)
        {
         float16 _248;
         bool _249 = _X_s0_jjj == 0;
         if (_249)
         {
          float16 __250 = _AFeeder_channel_array.s[_X_s0_iii];
          _248 = __250;
         } // if _249
         else
         {
          float16 _252 = _X_shreg[_X_s0_iii];
          _248 = _252;
         } // if _249 else
         float16 _253 = _248;
         _X_shreg[_X_s0_iii] = _253;
         (void)_253;
         float16 _255 = _X_shreg[_X_s0_iii];
         float16 _256 = __fpga_reg(__fpga_reg(_255));
         _X_shreg[_X_s0_iii] = _256;
         (void)_256;
         float16 _257;
         bool _258 = _X_s0_iii == 0;
         if (_258)
         {
          float16 __259 = _BFeeder_channel_array.s[_X_s0_jjj];
          _257 = __259;
         } // if _258
         else
         {
          float16 _261 = _Y_shreg[_X_s0_jjj];
          _257 = _261;
         } // if _258 else
         float16 _262 = _257;
         _Y_shreg[_X_s0_jjj] = _262;
         (void)_262;
         float16 _264 = _Y_shreg[_X_s0_jjj];
         float16 _265 = __fpga_reg(__fpga_reg(_264));
         _Y_shreg[_X_s0_jjj] = _265;
         (void)_265;
         float _266;
         bool _267 = _X_s0_k == 0;
         bool _268 = _X_s0_kk == 0;
         bool _269 = _267 && _268;
         if (_269)
         {
          float _270 = float_from_bits(0 /* 0 */);
          _266 = _270;
         } // if _269
         else
         {
          float _272 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
          float _273 = __fpga_reg(_272);
          _266 = _273;
         } // if _269 else
         float _274 = _266;
         _Z_shreg_temp = _274;
         #pragma unroll
         for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 16; _X_s0_kkk++)
         {
          float _275 = _Z_shreg_temp;
          float _277 = _X_shreg[_X_s0_iii][_X_s0_kkk];
          float _279 = _Y_shreg[_X_s0_jjj][_X_s0_kkk];
          float _280 = _277 * _279;
          float _281 = _275 + _280;
          _Z_shreg_temp = _281;
          int _282 = _X_s0_kkk & 3;
          bool _283 = _282 == 3;
          if (_283)
          {
           float _284 = _Z_shreg_temp;
           float _285 = __fpga_reg(_284);
           _Z_shreg_temp = _285;
          } // if _283
         } // for _X_s0_kkk
         float _286 = _Z_shreg_temp;
         _Z_shreg[0][_X_s0_jjj][_X_s0_iii] = _286;
         (void)_286;
         #pragma unroll
         for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 16; _X_s0_kkk++)
         {
          bool _287 = _X_s0_kkk == 15;
          bool _288 = _X_s0_kk == 7;
          bool _289 = _287 && _288;
          int _290 = _A_extent_0 >> 7;
          int _291 = _290 + -1;
          bool _292 = _X_s0_k == _291;
          bool _293 = _289 && _292;
          if (_293)
          {
           int _294 = _X_s0_iii * 256;
           float _296 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
           _Z_pipe_shreg[_X_s0_jjj][_294] = _296;
           (void)_296;
          } // if _293
         } // for _X_s0_kkk
        } // for _X_s0_jjj
       } // for _X_s0_iii
       bool _297 = _X_s0_jj == 0;
       bool _298 = _X_s0_ii == 0;
       bool _299 = _297 && _298;
       int _300 = _A_extent_0 >> 7;
       int _301 = _300 + -1;
       bool _302 = _X_s0_k == _301;
       bool _303 = _299 && _302;
       bool _304 = _X_s0_kk == 7;
       bool _305 = _303 && _304;
       bool _307 = _X_s0_i_j < _233;
       bool _308 = _305 && _307;
       if (_308)
       {
        int _309 = _Z_pipe_iter_temp;
        _Z_pipe_base_temp = _309;
       } // if _308
       float8 _Out_channel_temp;
       #pragma unroll
       for (int _Z_pipe_b__62 = 0; _Z_pipe_b__62 < 0 + 8; _Z_pipe_b__62++)
       {
        float _311 = _Z_pipe_shreg[_Z_pipe_b__62][0];
        _Out_channel_temp[_Z_pipe_b__62] = _311;
        #pragma unroll
        for (int _Z_pipe_b__62_dummy = 0; _Z_pipe_b__62_dummy < 0 + 8; _Z_pipe_b__62_dummy++)
        {
         float _312 = _Out_channel_temp[_Z_pipe_b__62_dummy];
         float _313 = __fpga_reg(__fpga_reg(_312));
         _Out_channel_temp[_Z_pipe_b__62_dummy] = _313;
        } // for _Z_pipe_b__62_dummy
       } // for _Z_pipe_b__62
       int _314 = _Z_pipe_iter_temp;
       int _315 = _Z_pipe_base_temp;
       int _316 = _315 + 2048;
       bool _317 = _314 < _316;
       if (_317)
       {
        float8 _318 = _Out_channel_temp;
        write_channel_intel(_Out_channel, _318);
        (void)_318;
       } // if _317
       #pragma unroll
       for (int _Z_pipe_b__63 = 0; _Z_pipe_b__63 < 0 + 8; _Z_pipe_b__63++)
       {
        #pragma unroll
        for (int _Z_pipe_p__31 = 0; _Z_pipe_p__31 < 0 + 7; _Z_pipe_p__31++)
        {
         #pragma unroll
         for (int _Z_pipe_l__31 = 0; _Z_pipe_l__31 < 0 + 255; _Z_pipe_l__31++)
         {
          int _319 = _Z_pipe_p__31 * 256;
          int _320 = _319 + _Z_pipe_l__31;
          int _321 = _320 + 1;
          float _323 = _Z_pipe_shreg[_Z_pipe_b__63][_321];
          _Z_pipe_shreg[_Z_pipe_b__63][_320] = _323;
          (void)_323;
         } // for _Z_pipe_l__31
         int _324 = _Z_pipe_p__31 * 256;
         int _325 = _324 + 255;
         int _326 = _324 + 256;
         float _328 = _Z_pipe_shreg[_Z_pipe_b__63][_326];
         float _329 = __fpga_reg(__fpga_reg(_328));
         _Z_pipe_shreg[_Z_pipe_b__63][_325] = _329;
         (void)_329;
        } // for _Z_pipe_p__31
       } // for _Z_pipe_b__63
       int _330 = _Z_pipe_iter_temp;
       int _331 = _330 + 1;
       _Z_pipe_iter_temp = _331;
      } // for _X_s0_jj
     } // for _X_s0_ii
    } // for _X_s0_kk
   } // for _X_s0_k
 } // for _X_s0_i_j
} // kernel kernel_Out
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__unloader_mem_channel float *restrict _unloader_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _332 = _A_extent_1 >> 7;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _332; _unloader_s0_i++)
 {
  int _333 = _B_extent_0 >> 7;
  for (int _unloader_s0_j = _unloader_s0_i; _unloader_s0_j < _333; _unloader_s0_j++)
  {
   #pragma loop_coalesce 3
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 8; _unloader_s0_iii++)
   {
    for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 16; _unloader_s0_ii++)
    {
     for (int _unloader_s0_jj = 0; _unloader_s0_jj < 0 + 16; _unloader_s0_jj++)
     {
      float8 __334 = read_channel_intel(_Out_channel);
      int _335 = _addr_temp;
      int _336 = _335 * 8;
      vstore8(__334, 0, (__address_space__unloader_mem_channel float*)_unloader_mem_channel + _336);
      int _337 = _addr_temp;
      int _338 = _337 + 1;
      _addr_temp = _338;
     } // for _unloader_s0_jj
    } // for _unloader_s0_ii
   } // for _unloader_s0_iii
  } // for _unloader_s0_j
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

