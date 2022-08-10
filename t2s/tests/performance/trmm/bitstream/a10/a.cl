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
  for (int _ALoader_s0_j = 0; _ALoader_s0_j < 0 + _2; _ALoader_s0_j++)
  {
   int _3 = _A_extent_0 >> 7;
   int _4 = _3 - _ALoader_s0_i + ((_ALoader_s0_i < _0) ? 0 : 1);
   for (int _ALoader_s0_k = _ALoader_s0_i; _ALoader_s0_k < _ALoader_s0_i + _4; _ALoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 8; _ALoader_s0_kk++)
    {
     for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 16; _ALoader_s0_ii++)
     {
      for (int _ALoader_s0_iii = 0; _ALoader_s0_iii < 0 + 8; _ALoader_s0_iii++)
      {
       bool _6 = _ALoader_s0_j == 0;
       bool _7 = _ALoader_s0_i == _ALoader_s0_k;
       bool _10 = _6 && _7;
       int _11 = _A_extent_1 >> 7;
       bool _12 = _ALoader_s0_i < _11;
       bool _13 = _10 || _12;
       if (_13)
       {
        float16 _15;
        int _16 = _A_extent_1 >> 7;
        bool _17 = _ALoader_s0_i < _16;
        if (_17)
        {
         int _18 = _ALoader_s0_iii*16 + _ALoader_s0_ii*128 + _ALoader_s0_kk*2048;
         int _19 = _18 + _ALoader_s0_k*16384;
         int _20 = _19 + _ALoader_s0_i*16384*_3;
         float16 _30 = vload16(0, (__address_space__ASerializer_mem_channel float*)_ASerializer_mem_channel + _20);
         _15 = _30;
        } // if _17
        else
        {
         float _31 = float_from_bits(0 /* 0 */);
         float16 _32 = _31;
         _15 = _32;
        } // if _17 else
        float16 _33 = _15;
        write_channel_intel(_ALoader_channel, _33);
        (void)_33;
       } // if _13
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
  bool _36 = _AFeeder_s0_jjj_init == 0;
  if (_36)
  {
   uint _37 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   _AFeeder_cycle_temp = _37;
  } // if _36
 } // for _AFeeder_s0_jjj_init
 while(1)
 {
  uint _38 = (uint)(ADD_UINT64_T_SUFFIX(1024));
  uint _39 = _AFeeder_cycle_temp;
  uint _40 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _41 = _39 & _40;
  bool _42 = _38 <= _41;
  if (_42)
  {
   float16 __43 = read_channel_intel(_ALoader_channel);
   _AFeeder_in_v_temp = __43;
  } // if _42
  #pragma unroll
  for (int _AFeeder_s0_buf = 0; _AFeeder_s0_buf < 0 + 8; _AFeeder_s0_buf++)
  {
   bool _44 = _AFeeder_s0_buf == 0;
   if (_44)
   {
    float16 _45 = _AFeeder_in_v_temp;
    _AFeeder_value_shreg = _45;
    (void)_45;
    uint _46 = _AFeeder_cycle_temp;
    _AFeeder_time_stamp_shreg = _46;
    (void)_46;
   } // if _44
   else
   {
    float16 _48 = _AFeeder_value_shreg;
    _AFeeder_value_shreg = _48;
    (void)_48;
    uint _50 = _AFeeder_time_stamp_shreg;
    _AFeeder_time_stamp_shreg = _50;
    (void)_50;
   } // if _44 else
   float16 _52 = _AFeeder_value_shreg;
   float16 _53 = __fpga_reg(__fpga_reg(_52));
   _AFeeder_value_shreg = _53;
   (void)_53;
   uint _55 = _AFeeder_time_stamp_shreg;
   uint _56 = __fpga_reg(__fpga_reg(_55));
   _AFeeder_time_stamp_shreg = _56;
   (void)_56;
   uint _57 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   uint _59 = _AFeeder_time_stamp_shreg;
   uint _60 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _61 = _59 & _60;
   bool _62 = _57 <= _61;
   if (_62)
   {
    uint _64 = _AFeeder_time_stamp_shreg;
    uint _65 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _66 = _64 & _65;
    uint _67 = (uint)(ADD_UINT64_T_SUFFIX(1024));
    uint _68 = _66 - _67;
    uint _69 = (uint)(ADD_UINT64_T_SUFFIX(7));
    uint _70 = _68 & _69;
    int _71 = (int)(_70);
    bool _72 = _AFeeder_s0_buf == _71;
    if (_72)
    {
     float16 _74 = _AFeeder_value_shreg;
     uint _76 = _AFeeder_time_stamp_shreg;
     uint _77 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _78 = _76 >> _77;
     uint _79 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _80 = _78 & _79;
     bool _81 = (bool)(_80);
     uint _83 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _84 = _76 & _83;
     uint _85 = (uint)(ADD_UINT64_T_SUFFIX(1024));
     uint _86 = _84 - _85;
     int _87 = (int)(_86);
     int _88 = _87 >> 7;
     int _90 = _87 >> 3;
     int _91 = _90 & 15;
     _AFeeder_DB_0_ibuffer[_81][_88][_91][_AFeeder_s0_buf] = _74;
    } // if _72
   } // if _62
   uint _92 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _94 = _AFeeder_time_stamp_shreg;
   uint _95 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _96 = _94 >> _95;
   bool _97 = _92 < _96;
   if (_97)
   {
    uint _99 = _AFeeder_time_stamp_shreg;
    uint _100 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _101 = _99 & _100;
    int _102 = (int)(_101);
    uint _103 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _104 = _99 >> _103;
    uint _105 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _106 = _104 & _105;
    bool _107 = (bool)(_106);
    bool _108 = !(_107);
    int _109 = _102 >> 8;
    int _110 = _102 >> 4;
    int _111 = _110 & 15;
    float16 _112 = _AFeeder_DB_0_ibuffer[_108][_109][_111][_AFeeder_s0_buf];
    _AFeeder_channel_array.s[_AFeeder_s0_buf] = _112;
    (void)_AFeeder_s0_buf;
   } // if _97
  } // for _AFeeder_s0_buf
  uint _113 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _115 = _AFeeder_time_stamp_shreg;
  uint _116 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _117 = _115 >> _116;
  bool _118 = _113 < _117;
  if (_118)
  {
   write_channel_intel(_AFeeder_channel, _AFeeder_channel_array);
   (void)_AFeeder_channel_array;
  } // if _118
  uint _119 = _AFeeder_cycle_temp;
  uint _120 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _121 = _119 + _120;
  _AFeeder_cycle_temp = _121;
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
 int _122 = _A_extent_1 >> 7;
 int _123 = _122 + 1;
 for (int _BLoader_s0_i = 0; _BLoader_s0_i < 0 + _123; _BLoader_s0_i++)
 {
  int _124 = _B_extent_0 >> 7;
  for (int _BLoader_s0_j = 0; _BLoader_s0_j < 0 + _124; _BLoader_s0_j++)
  {
   int _125 = _A_extent_0 >> 7;
   int _126 = _125 - _BLoader_s0_i + ((_BLoader_s0_i < _122) ? 0 : 1);
   for (int _BLoader_s0_k = _BLoader_s0_i; _BLoader_s0_k < _BLoader_s0_i + _126; _BLoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _BLoader_s0_kk = 0; _BLoader_s0_kk < 0 + 8; _BLoader_s0_kk++)
    {
     for (int _BLoader_s0_jj = 0; _BLoader_s0_jj < 0 + 16; _BLoader_s0_jj++)
     {
      for (int _BLoader_s0_jjj = 0; _BLoader_s0_jjj < 0 + 8; _BLoader_s0_jjj++)
      {
       bool _128 = _BLoader_s0_j == 0;
       bool _129 = _BLoader_s0_i == _BLoader_s0_k;
       bool _132 = _128 && _129;
       int _133 = _A_extent_1 >> 7; 
       bool _134 = _BLoader_s0_i < _133;
       bool _135 = _132 || _134;
       if (_135)
       {
        float16 _136;
        int _137 = _A_extent_1 >> 7;
        bool _138 = _BLoader_s0_i < _137;
        if (_138)
        {
         int _18 = _BLoader_s0_jjj*16 + _BLoader_s0_jj*128 + _BLoader_s0_kk*2048;
         int _19 = _18 + _BLoader_s0_k*16384;
         int _20 = _19 + _BLoader_s0_j*16384*_125;
         float16 _147 = vload16(0, (__address_space__BSerializer_mem_channel float*)_BSerializer_mem_channel + _20);
         _136 = _147;
        } // if _138
        else
        {
         float _148 = float_from_bits(0 /* 0 */);
         float16 _149 = _148;
         _136 = _149;
        } // if _138 else
        float16 _150 = _136;
        write_channel_intel(_BLoader_channel, _150);
        (void)_150;
       } // if _135
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
  bool _153 = _BFeeder_s0_iii_init == 0;
  if (_153)
  {
   uint _154 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   _BFeeder_cycle_temp = _154;
  } // if _153
 } // for _BFeeder_s0_iii_init
 while(1)
 {
  uint _155 = (uint)(ADD_UINT64_T_SUFFIX(1024));
  uint _156 = _BFeeder_cycle_temp;
  uint _157 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _158 = _156 & _157;
  bool _159 = _155 <= _158;
  if (_159)
  {
   float16 __160 = read_channel_intel(_BLoader_channel);
   _BFeeder_in_v_temp = __160;
  } // if _159
  #pragma unroll
  for (int _BFeeder_s0_buf = 0; _BFeeder_s0_buf < 0 + 8; _BFeeder_s0_buf++)
  {
   bool _161 = _BFeeder_s0_buf == 0;
   if (_161)
   {
    float16 _162 = _BFeeder_in_v_temp;
    _BFeeder_value_shreg = _162;
    (void)_162;
    uint _163 = _BFeeder_cycle_temp;
    _BFeeder_time_stamp_shreg = _163;
    (void)_163;
   } // if _161
   else
   {
    float16 _165 = _BFeeder_value_shreg;
    _BFeeder_value_shreg = _165;
    (void)_165;
    uint _167 = _BFeeder_time_stamp_shreg;
    _BFeeder_time_stamp_shreg = _167;
    (void)_167;
   } // if _161 else
   float16 _169 = _BFeeder_value_shreg;
   float16 _170 = __fpga_reg(__fpga_reg(_169));
   _BFeeder_value_shreg = _170;
   (void)_170;
   uint _172 = _BFeeder_time_stamp_shreg;
   uint _173 = __fpga_reg(__fpga_reg(_172));
   _BFeeder_time_stamp_shreg = _173;
   (void)_173;
   uint _174 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   uint _176 = _BFeeder_time_stamp_shreg;
   uint _177 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _178 = _176 & _177;
   bool _179 = _174 <= _178;
   if (_179)
   {
    uint _181 = _BFeeder_time_stamp_shreg;
    uint _182 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _183 = _181 & _182;
    uint _184 = (uint)(ADD_UINT64_T_SUFFIX(1024));
    uint _185 = _183 - _184;
    uint _186 = (uint)(ADD_UINT64_T_SUFFIX(7));
    uint _187 = _185 & _186;
    int _188 = (int)(_187);
    bool _189 = _BFeeder_s0_buf == _188;
    if (_189)
    {
     float16 _191 = _BFeeder_value_shreg;
     uint _193 = _BFeeder_time_stamp_shreg;
     uint _194 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _195 = _193 >> _194;
     uint _196 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _197 = _195 & _196;
     bool _198 = (bool)(_197);
     uint _200 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _201 = _193 & _200;
     uint _202 = (uint)(ADD_UINT64_T_SUFFIX(1024));
     uint _203 = _201 - _202;
     int _204 = (int)(_203);
     int _205 = _204 >> 7;
     int _207 = _204 >> 3;
     int _208 = _207 & 15;
     _BFeeder_DB_0_ibuffer[_198][_205][_208][_BFeeder_s0_buf] = _191;
    } // if _189
   } // if _179
   uint _209 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _211 = _BFeeder_time_stamp_shreg;
   uint _212 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _213 = _211 >> _212;
   bool _214 = _209 < _213;
   if (_214)
   {
    uint _216 = _BFeeder_time_stamp_shreg;
    uint _217 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _218 = _216 & _217;
    int _219 = (int)(_218);
    uint _220 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _221 = _216 >> _220;
    uint _222 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _223 = _221 & _222;
    bool _224 = (bool)(_223);
    bool _225 = !(_224);
    int _226 = _219 >> 8;
    int _227 = _219 & 15;
    float16 _228 = _BFeeder_DB_0_ibuffer[_225][_226][_227][_BFeeder_s0_buf];
    _BFeeder_channel_array.s[_BFeeder_s0_buf] = _228;
    (void)_BFeeder_s0_buf;
   } // if _214
  } // for _BFeeder_s0_buf
  uint _229 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _231 = _BFeeder_time_stamp_shreg;
  uint _232 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _233 = _231 >> _232;
  bool _234 = _229 < _233;
  if (_234)
  {
   write_channel_intel(_BFeeder_channel, _BFeeder_channel_array);
   (void)_BFeeder_channel_array;
  } // if _234
  uint _235 = _BFeeder_cycle_temp;
  uint _236 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _237 = _235 + _236;
  _BFeeder_cycle_temp = _237;
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
 int _238 = _A_extent_1 >> 7;
 int _239 = _238 + 1;
 for (int _X_s0_i = 0; _X_s0_i < 0 + _239; _X_s0_i++)
 {
  int _240 = _B_extent_0 >> 7;
  for (int _X_s0_j = 0; _X_s0_j < 0 + _240; _X_s0_j++)
  {
   int _241 = _A_extent_0 >> 7;
   int _242 = _241 - _X_s0_i + ((_X_s0_i < _238) ? 0 : 1);
   for (int _X_s0_k = _X_s0_i; _X_s0_k < _X_s0_i + _242; _X_s0_k++)
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
         float _244 = _Z_shreg[255][_dummy_s0_jjj][_dummy__1_s0_iii];
         _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii] = _244;
         #pragma unroll
         for (int _dummy__2_s0_l1 = 0; _dummy__2_s0_l1 < 0 + 255; _dummy__2_s0_l1++)
         {
          int _245 = 255 - _dummy__2_s0_l1;
          int _246 = 254 - _dummy__2_s0_l1;
          float _248 = _Z_shreg[_246][_dummy_s0_jjj][_dummy__1_s0_iii];
          _Z_shreg[_245][_dummy_s0_jjj][_dummy__1_s0_iii] = _248;
          (void)_248;
         } // for _dummy__2_s0_l1
         float _249 = _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii];
         _Z_shreg[0][_dummy_s0_jjj][_dummy__1_s0_iii] = _249;
         (void)_249;
        } // for _dummy_s0_jjj
       } // for _dummy__1_s0_iii
       int _250 = _A_extent_1 >> 7;
       bool _251 = _X_s0_i < _250;
       if (_251)
       {
        _BFeeder_channel_array_t __252 = read_channel_intel(_BFeeder_channel);
        _BFeeder_channel_array = __252;
        (void)__252;
        _AFeeder_channel_array_t __253 = read_channel_intel(_AFeeder_channel);
        _AFeeder_channel_array = __253;
        (void)__253;
       } // if _251
       #pragma unroll
       for (int _X_s0_iii = 0; _X_s0_iii < 0 + 8; _X_s0_iii++)
       {
        #pragma unroll
        for (int _X_s0_jjj = 0; _X_s0_jjj < 0 + 8; _X_s0_jjj++)
        {
         float16 _254;
         bool _255 = _X_s0_jjj == 0;
         if (_255)
         {
          float16 __256 = _AFeeder_channel_array.s[_X_s0_iii];
          _254 = __256;
         } // if _255
         else
         {
          float16 _258 = _X_shreg[_X_s0_iii];
          _254 = _258;
         } // if _255 else
         float16 _259 = _254;
         _X_shreg[_X_s0_iii] = _259;
         (void)_259;
         float16 _261 = _X_shreg[_X_s0_iii];
         float16 _262 = __fpga_reg(__fpga_reg(_261));
         _X_shreg[_X_s0_iii] = _262;
         (void)_262;
         float16 _263;
         bool _264 = _X_s0_iii == 0;
         if (_264)
         {
          float16 __265 = _BFeeder_channel_array.s[_X_s0_jjj];
          _263 = __265;
         } // if _264
         else
         {
          float16 _267 = _Y_shreg[_X_s0_jjj];
          _263 = _267;
         } // if _264 else
         float16 _268 = _263;
         _Y_shreg[_X_s0_jjj] = _268;
         (void)_268;
         float16 _270 = _Y_shreg[_X_s0_jjj];
         float16 _271 = __fpga_reg(__fpga_reg(_270));
         _Y_shreg[_X_s0_jjj] = _271;
         (void)_271;
         float _272;
         bool _273 = _X_s0_k == _X_s0_i;
         bool _274 = _X_s0_kk == 0;
         bool _275 = _273 && _274;
         if (_275)
         {
          float _276 = float_from_bits(0 /* 0 */);
          _272 = _276;
         } // if _275
         else
         {
          float _278 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
          float _279 = __fpga_reg(_278);
          _272 = _279;
         } // if _275 else
         float _280 = _272;
         _Z_shreg_temp = _280;
         #pragma unroll
         for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 16; _X_s0_kkk++)
         {
          float _281 = _Z_shreg_temp;
          float _283 = _X_shreg[_X_s0_iii][_X_s0_kkk];
          float _285 = _Y_shreg[_X_s0_jjj][_X_s0_kkk];
          float _286 = _283 * _285;
          float _287 = _281 + _286;
          _Z_shreg_temp = _287;
          int _288 = _X_s0_kkk & 3;
          bool _289 = _288 == 3;
          if (_289)
          {
           float _290 = _Z_shreg_temp;
           float _291 = __fpga_reg(_290);
           _Z_shreg_temp = _291;
          } // if _289
         } // for _X_s0_kkk
         float _292 = _Z_shreg_temp;
         _Z_shreg[0][_X_s0_jjj][_X_s0_iii] = _292;
         (void)_292;
         #pragma unroll
         for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 16; _X_s0_kkk++)
         {
          bool _293 = _X_s0_kkk == 15;
          bool _294 = _X_s0_kk == 7;
          bool _295 = _293 && _294;
          int _296 = _A_extent_0 >> 7;
          int _297 = _296 + -1;
          bool _298 = _X_s0_k == _297;
          bool _299 = _295 && _298;
          if (_299)
          {
           int _300 = _X_s0_iii * 256;
           float _302 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
           _Z_pipe_shreg[_X_s0_jjj][_300] = _302;
           (void)_302;
          } // if _299
         } // for _X_s0_kkk
        } // for _X_s0_jjj
       } // for _X_s0_iii
       bool _303 = _X_s0_jj == 0;
       bool _304 = _X_s0_ii == 0;
       bool _305 = _303 && _304;
       int _306 = _A_extent_0 >> 7;
       int _307 = _306 + -1;
       bool _308 = _X_s0_k == _307;
       bool _309 = _305 && _308;
       bool _310 = _X_s0_kk == 7;
       bool _311 = _309 && _310;
       int _312 = _A_extent_1 >> 7;
       bool _313 = _X_s0_i < _312;
       bool _314 = _311 && _313;
       if (_314)
       {
        int _315 = _Z_pipe_iter_temp;
        _Z_pipe_base_temp = _315;
       } // if _314
       float8 _Out_channel_temp;
       #pragma unroll
       for (int _Z_pipe_b__62 = 0; _Z_pipe_b__62 < 0 + 8; _Z_pipe_b__62++)
       {
        float _317 = _Z_pipe_shreg[_Z_pipe_b__62][0];
        _Out_channel_temp[_Z_pipe_b__62] = _317;
        #pragma unroll
        for (int _Z_pipe_b__62_dummy = 0; _Z_pipe_b__62_dummy < 0 + 8; _Z_pipe_b__62_dummy++)
        {
         float _318 = _Out_channel_temp[_Z_pipe_b__62_dummy];
         float _319 = __fpga_reg(__fpga_reg(_318));
         _Out_channel_temp[_Z_pipe_b__62_dummy] = _319;
        } // for _Z_pipe_b__62_dummy
       } // for _Z_pipe_b__62
       int _320 = _Z_pipe_iter_temp;
       int _321 = _Z_pipe_base_temp;
       int _322 = _321 + 2048;
       bool _323 = _320 < _322;
       if (_323)
       {
        float8 _324 = _Out_channel_temp;
        write_channel_intel(_Out_channel, _324);
       } // if _323
       #pragma unroll
       for (int _Z_pipe_b__63 = 0; _Z_pipe_b__63 < 0 + 8; _Z_pipe_b__63++)
       {
        #pragma unroll
        for (int _Z_pipe_p__31 = 0; _Z_pipe_p__31 < 0 + 7; _Z_pipe_p__31++)
        {
         #pragma unroll
         for (int _Z_pipe_l__31 = 0; _Z_pipe_l__31 < 0 + 255; _Z_pipe_l__31++)
         {
          int _325 = _Z_pipe_p__31 * 256;
          int _326 = _325 + _Z_pipe_l__31;
          int _327 = _326 + 1;
          float _329 = _Z_pipe_shreg[_Z_pipe_b__63][_327];
          _Z_pipe_shreg[_Z_pipe_b__63][_326] = _329;
          (void)_329;
         } // for _Z_pipe_l__31
         int _330 = _Z_pipe_p__31 * 256;
         int _331 = _330 + 255;
         int _332 = _330 + 256;
         float _334 = _Z_pipe_shreg[_Z_pipe_b__63][_332];
         float _335 = __fpga_reg(__fpga_reg(_334));
         _Z_pipe_shreg[_Z_pipe_b__63][_331] = _335;
         (void)_335;
        } // for _Z_pipe_p__31
       } // for _Z_pipe_b__63
       int _336 = _Z_pipe_iter_temp;
       int _337 = _336 + 1;
       _Z_pipe_iter_temp = _337;
      } // for _X_s0_jj
     } // for _X_s0_ii
    } // for _X_s0_kk
   } // for _X_s0_k
  } // for _X_s0_j
 } // for _X_s0_i
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
 int _338 = _A_extent_1 >> 7;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _338; _unloader_s0_i++)
 {
  int _339 = _B_extent_0 >> 7;
  for (int _unloader_s0_j = 0; _unloader_s0_j < 0 + _339; _unloader_s0_j++)
  {
   #pragma loop_coalesce 3
   for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 8; _unloader_s0_iii++)
   {
    for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 16; _unloader_s0_ii++)
    {
     for (int _unloader_s0_jj = 0; _unloader_s0_jj < 0 + 16; _unloader_s0_jj++)
     {
      float8 __340 = read_channel_intel(_Out_channel);
      int _341 = _addr_temp;
      int _342 = _341 * 8;
      vstore8(__340, 0, (__address_space__unloader_mem_channel float*)_unloader_mem_channel + _342);
      int _343 = _addr_temp;
      int _344 = _343 + 1;
      _addr_temp = _344;
     } // for _unloader_s0_jj
    } // for _unloader_s0_ii
   } // for _unloader_s0_iii
  } // for _unloader_s0_j
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

