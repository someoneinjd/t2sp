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
channel complex8 _ALoader_channel __attribute__((depth(256))) ;
typedef struct { complex8 s[4]; } _AFeeder_channel_array_t;
channel _AFeeder_channel_array_t _AFeeder_channel __attribute__((depth(256))) ;
channel complex8 _BLoader_channel __attribute__((depth(256))) ;
typedef struct { complex8 s[8]; } _BFeeder_channel_array_t;
channel _BFeeder_channel_array_t _BFeeder_channel __attribute__((depth(256))) ;
channel complex8 _Out_channel __attribute__((depth(0))) ;
// Address spaces for kernel_ALoader_1
#define __address_space__ASerializer_mem_channel __global
__kernel void kernel_ALoader_1(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__ASerializer_mem_channel const complex *restrict _ASerializer_mem_channel)
{
 int _373 = _A_extent_1 >> 6;
 int _374 = _373 + 1;
 for (int _ALoader_s0_i = 0; _ALoader_s0_i < 0 + _374; _ALoader_s0_i++)
 {
  int _375 = _B_extent_0 >> 7;
  for (int _ALoader_s0_j = 0; _ALoader_s0_j < 0 + _375; _ALoader_s0_j++)
  {
   int _376 = _A_extent_0 >> 6;
   int _377 = _376 - _ALoader_s0_i + ((_ALoader_s0_i < _373) ? 0 : 1);
   for (int _ALoader_s0_k = _ALoader_s0_i; _ALoader_s0_k < _ALoader_s0_i + _377; _ALoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 8; _ALoader_s0_kk++)
    {
     for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 16; _ALoader_s0_ii++)
     {
      for (int _ALoader_s0_iii = 0; _ALoader_s0_iii < 0 + 4; _ALoader_s0_iii++)
      {
        bool _378 = _ALoader_s0_j == 0;
        bool _379 = _ALoader_s0_k == _ALoader_s0_i;
        bool _380 = _378 && _379;
        int _391 = _A_extent_1 >> 6;
        bool _392 = _ALoader_s0_i < _391;
        bool _393 = _380 || _392;
        if (_393)
        {
         complex8 _394;
         int _395 = _A_extent_1 >> 6;
         bool _396 = _ALoader_s0_i < _395;
         if (_396)
         {
          int _18 = _ALoader_s0_iii*8 + _ALoader_s0_ii*32 + _ALoader_s0_kk*512;
          int _19 = _18 + _ALoader_s0_k*4096;
          int _20 = _19 + _ALoader_s0_i*4096*_376;
          complex8 _410 = {vload16(0, (__address_space__ASerializer_mem_channel float*)(_ASerializer_mem_channel + _20))};
          _394 = _410;
         } // if _396
         else
         {
          float _34 = float_from_bits(0 /* 0 */);
          _394.t = _34;
         } // if _396 else
         complex8 _413 = _394;
         write_channel_intel(_ALoader_channel, _413);
         (void)_413;
        } // if _393
      } // for _ALoader_s0_iii
     } // for _ALoader_s0_ii
    } // for _ALoader_s0_kk
   } // for _ALoader_s0_k
  } // for _ALoader_s0_j
 } // for _ALoader_s0_i
} // kernel kernel_ALoader_1
#undef __address_space__ASerializer_mem_channel
// Address spaces for kernel_AFeeder_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_AFeeder_1(
)
{
 _AFeeder_channel_array_t _AFeeder_channel_array;
 complex8 _AFeeder_value_shreg;
 uint _AFeeder_time_stamp_shreg;
 complex8 _AFeeder_in_v_temp;
 uint _AFeeder_cycle_temp;
 complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _AFeeder_DB_0_ibuffer[2][8][16][4];
 #pragma unroll
 for (int _AFeeder_s0_jjj_init = 0; _AFeeder_s0_jjj_init < 0 + 8; _AFeeder_s0_jjj_init++)
 {
  bool _416 = _AFeeder_s0_jjj_init == 0;
  if (_416)
  {
   uint _417 = (uint)(ADD_UINT64_T_SUFFIX(1536));
   _AFeeder_cycle_temp = _417;
  } // if _416
 } // for _AFeeder_s0_jjj_init
 while(1)
 {
  uint _418 = (uint)(ADD_UINT64_T_SUFFIX(1536));
  uint _419 = _AFeeder_cycle_temp;
  uint _420 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _421 = _419 & _420;
  bool _422 = _418 <= _421;
  if (_422)
  {
   complex8 __423 = read_channel_intel(_ALoader_channel);
   _AFeeder_in_v_temp = __423;
  } // if _422
  #pragma unroll
  for (int _AFeeder_s0_buf = 0; _AFeeder_s0_buf < 0 + 4; _AFeeder_s0_buf++)
  {
   bool _424 = _AFeeder_s0_buf == 0;
   if (_424)
   {
    complex8 _425 = _AFeeder_in_v_temp;
    _AFeeder_value_shreg = _425;
    (void)_425;
    uint _426 = _AFeeder_cycle_temp;
    _AFeeder_time_stamp_shreg = _426;
    (void)_426;
   } // if _424
   else
   {
    complex8 _428 = _AFeeder_value_shreg;
    _AFeeder_value_shreg = _428;
    (void)_428;
    uint _430 = _AFeeder_time_stamp_shreg;
    _AFeeder_time_stamp_shreg = _430;
    (void)_430;
   } // if _424 else
   complex8 _432 = _AFeeder_value_shreg;
   complex8 _433 = __fpga_reg(__fpga_reg(_432));
   _AFeeder_value_shreg = _433;
   (void)_433;
   uint _435 = _AFeeder_time_stamp_shreg;
   uint _436 = __fpga_reg(__fpga_reg(_435));
   _AFeeder_time_stamp_shreg = _436;
   (void)_436;
   uint _437 = (uint)(ADD_UINT64_T_SUFFIX(1536));
   uint _439 = _AFeeder_time_stamp_shreg;
   uint _440 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _441 = _439 & _440;
   bool _442 = _437 <= _441;
   if (_442)
   {
    uint _444 = _AFeeder_time_stamp_shreg;
    uint _445 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _446 = _444 & _445;
    uint _447 = (uint)(ADD_UINT64_T_SUFFIX(1536));
    uint _448 = _446 - _447;
    uint _449 = (uint)(ADD_UINT64_T_SUFFIX(3));
    uint _450 = _448 & _449;
    int _451 = (int)(_450);
    bool _452 = _AFeeder_s0_buf == _451;
    if (_452)
    {
     complex8 _454 = _AFeeder_value_shreg;
     uint _456 = _AFeeder_time_stamp_shreg;
     uint _457 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _458 = _456 >> _457;
     uint _459 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _460 = _458 & _459;
     bool _461 = (bool)(_460);
     uint _463 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _464 = _456 & _463;
     uint _465 = (uint)(ADD_UINT64_T_SUFFIX(1536));
     uint _466 = _464 - _465;
     int _467 = (int)(_466);
     int _468 = _467 >> 6;
     int _470 = _467 >> 2;
     int _471 = _470 & 15;
     _AFeeder_DB_0_ibuffer[_461][_468][_471][_AFeeder_s0_buf] = _454;
    } // if _452
   } // if _442
   uint _472 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _474 = _AFeeder_time_stamp_shreg;
   uint _475 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _476 = _474 >> _475;
   bool _477 = _472 < _476;
   if (_477)
   {
    uint _479 = _AFeeder_time_stamp_shreg;
    uint _480 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _481 = _479 >> _480;
    uint _482 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _483 = _481 & _482;
    bool _484 = (bool)(_483);
    bool _485 = !(_484);
    uint _487 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _488 = _479 & _487;
    int _489 = (int)(_488);
    int _490 = _489 >> 8;
    int _492 = _489 >> 4;
    int _493 = _492 & 15;
    complex8 _494 = _AFeeder_DB_0_ibuffer[_485][_490][_493][_AFeeder_s0_buf];
    _AFeeder_channel_array.s[_AFeeder_s0_buf] = _494;
    (void)_AFeeder_s0_buf;
   } // if _477
  } // for _AFeeder_s0_buf
  uint _495 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _497 = _AFeeder_time_stamp_shreg;
  uint _498 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _499 = _497 >> _498;
  bool _500 = _495 < _499;
  if (_500)
  {
   write_channel_intel(_AFeeder_channel, _AFeeder_channel_array);
   (void)_AFeeder_channel_array;
  } // if _500
  uint _501 = _AFeeder_cycle_temp;
  uint _502 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _503 = _501 + _502;
  _AFeeder_cycle_temp = _503;
 } // while _AFeeder_s0_outermost_loop_infinite
} // kernel kernel_AFeeder_1
// Address spaces for kernel_BLoader_1
#define __address_space__BSerializer_mem_channel __global
__kernel void kernel_BLoader_1(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__BSerializer_mem_channel const complex *restrict _BSerializer_mem_channel)
{
 int _505 = _A_extent_1 >> 6;
 int _506 = _505 + 1;
 for (int _BLoader_s0_i = 0; _BLoader_s0_i < 0 + _506; _BLoader_s0_i++)
 {
  int _507 = _B_extent_0 >> 7;
  for (int _BLoader_s0_j = 0; _BLoader_s0_j < 0 + _507; _BLoader_s0_j++)
  {
   int _508 = _A_extent_0 >> 6;
   int _509 = _508 - _BLoader_s0_i + ((_BLoader_s0_i < _505) ? 0 : 1);
   for (int _BLoader_s0_k = _BLoader_s0_i; _BLoader_s0_k < _BLoader_s0_i + _509; _BLoader_s0_k++)
   {
    #pragma loop_coalesce 3
    for (int _BLoader_s0_kk = 0; _BLoader_s0_kk < 0 + 8; _BLoader_s0_kk++)
    {
     for (int _BLoader_s0_jj = 0; _BLoader_s0_jj < 0 + 16; _BLoader_s0_jj++)
     {
      for (int _BLoader_s0_jjj = 0; _BLoader_s0_jjj < 0 + 8; _BLoader_s0_jjj++)
      {
        bool _510 = _BLoader_s0_j == 0;
        bool _511 = _BLoader_s0_k == _BLoader_s0_i;
        bool _512 = _510 && _511;
        int _523 = _A_extent_1 >> 6;
        bool _524 = _BLoader_s0_i < _523;
        bool _525 = _512 || _524;
        if (_525)
        {
         complex8 _526;
         int _527 = _A_extent_1 >> 6;
         bool _528 = _BLoader_s0_i < _527;
         if (_528)
         {
          int _18 = _BLoader_s0_jjj*8 + _BLoader_s0_jj*64 + _BLoader_s0_kk*1024;
          int _19 = _18 + _BLoader_s0_k*8192;
          int _20 = _19 + _BLoader_s0_j*8192*_508;
          complex8 _537 = {vload16(0, (__address_space__BSerializer_mem_channel float*)(_BSerializer_mem_channel + _20))};
          _526 = _537;
         } // if _528
         else
         {
          float _34 = float_from_bits(0 /* 0 */);
          _526.t = _34;
         } // if _528 else
         complex8 _540 = _526;
         write_channel_intel(_BLoader_channel, _540);
         (void)_540;
        } // if _525
       } // for _BLoader_s0_jjj
     } // for _BLoader_s0_jj
    } // for _BLoader_s0_kk
   } // for _BLoader_s0_k
  } // for _BLoader_s0_j
 } // for _BLoader_s0_i
} // kernel kernel_BLoader_1
#undef __address_space__BSerializer_mem_channel
// Address spaces for kernel_BFeeder_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void kernel_BFeeder_1(
)
{
 _BFeeder_channel_array_t _BFeeder_channel_array;
 complex8 _BFeeder_value_shreg;
 uint _BFeeder_time_stamp_shreg;
 complex8 _BFeeder_in_v_temp;
 uint _BFeeder_cycle_temp;
 complex8 __attribute__((memory, numbanks(8), singlepump, numwriteports(1), numreadports(1))) _BFeeder_DB_0_ibuffer[2][8][16][8];
 #pragma unroll
 for (int _BFeeder_s0_iii_init = 0; _BFeeder_s0_iii_init < 0 + 4; _BFeeder_s0_iii_init++)
 {
  bool _543 = _BFeeder_s0_iii_init == 0;
  if (_543)
  {
   uint _544 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   _BFeeder_cycle_temp = _544;
  } // if _543
 } // for _BFeeder_s0_iii_init
 while(1)
 {
  uint _545 = (uint)(ADD_UINT64_T_SUFFIX(1024));
  uint _546 = _BFeeder_cycle_temp;
  uint _547 = (uint)(ADD_UINT64_T_SUFFIX(2047));
  uint _548 = _546 & _547;
  bool _549 = _545 <= _548;
  if (_549)
  {
   complex8 __550 = read_channel_intel(_BLoader_channel);
   _BFeeder_in_v_temp = __550;
  } // if _549
  #pragma unroll
  for (int _BFeeder_s0_buf = 0; _BFeeder_s0_buf < 0 + 8; _BFeeder_s0_buf++)
  {
   bool _551 = _BFeeder_s0_buf == 0;
   if (_551)
   {
    complex8 _552 = _BFeeder_in_v_temp;
    _BFeeder_value_shreg = _552;
    (void)_552;
    uint _553 = _BFeeder_cycle_temp;
    _BFeeder_time_stamp_shreg = _553;
    (void)_553;
   } // if _551
   else
   {
    complex8 _555 = _BFeeder_value_shreg;
    _BFeeder_value_shreg = _555;
    (void)_555;
    uint _557 = _BFeeder_time_stamp_shreg;
    _BFeeder_time_stamp_shreg = _557;
    (void)_557;
   } // if _551 else
   complex8 _559 = _BFeeder_value_shreg;
   complex8 _560 = __fpga_reg(__fpga_reg(_559));
   _BFeeder_value_shreg = _560;
   (void)_560;
   uint _562 = _BFeeder_time_stamp_shreg;
   uint _563 = __fpga_reg(__fpga_reg(_562));
   _BFeeder_time_stamp_shreg = _563;
   (void)_563;
   uint _564 = (uint)(ADD_UINT64_T_SUFFIX(1024));
   uint _566 = _BFeeder_time_stamp_shreg;
   uint _567 = (uint)(ADD_UINT64_T_SUFFIX(2047));
   uint _568 = _566 & _567;
   bool _569 = _564 <= _568;
   if (_569)
   {
    uint _571 = _BFeeder_time_stamp_shreg;
    uint _572 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _573 = _571 & _572;
    uint _574 = (uint)(ADD_UINT64_T_SUFFIX(1024));
    uint _575 = _573 - _574;
    uint _576 = (uint)(ADD_UINT64_T_SUFFIX(7));
    uint _577 = _575 & _576;
    int _578 = (int)(_577);
    bool _579 = _BFeeder_s0_buf == _578;
    if (_579)
    {
     complex8 _581 = _BFeeder_value_shreg;
     uint _583 = _BFeeder_time_stamp_shreg;
     uint _584 = (uint)(ADD_UINT64_T_SUFFIX(11));
     uint _585 = _583 >> _584;
     uint _586 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _587 = _585 & _586;
     bool _588 = (bool)(_587);
     uint _590 = (uint)(ADD_UINT64_T_SUFFIX(2047));
     uint _591 = _583 & _590;
     uint _592 = (uint)(ADD_UINT64_T_SUFFIX(1024));
     uint _593 = _591 - _592;
     int _594 = (int)(_593);
     int _595 = _594 >> 7;
     int _597 = _594 >> 3;
     int _598 = _597 & 15;
     _BFeeder_DB_0_ibuffer[_588][_595][_598][_BFeeder_s0_buf] = _581;
    } // if _579
   } // if _569
   uint _599 = (uint)(ADD_UINT64_T_SUFFIX(0));
   uint _601 = _BFeeder_time_stamp_shreg;
   uint _602 = (uint)(ADD_UINT64_T_SUFFIX(11));
   uint _603 = _601 >> _602;
   bool _604 = _599 < _603;
   if (_604)
   {
    uint _606 = _BFeeder_time_stamp_shreg;
    uint _607 = (uint)(ADD_UINT64_T_SUFFIX(11));
    uint _608 = _606 >> _607;
    uint _609 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _610 = _608 & _609;
    bool _611 = (bool)(_610);
    bool _612 = !(_611);
    uint _614 = (uint)(ADD_UINT64_T_SUFFIX(2047));
    uint _615 = _606 & _614;
    int _616 = (int)(_615);
    int _617 = _616 >> 8;
    int _619 = _616 & 15;
    complex8 _620 = _BFeeder_DB_0_ibuffer[_612][_617][_619][_BFeeder_s0_buf];
    _BFeeder_channel_array.s[_BFeeder_s0_buf] = _620;
    (void)_BFeeder_s0_buf;
   } // if _604
  } // for _BFeeder_s0_buf
  uint _621 = (uint)(ADD_UINT64_T_SUFFIX(0));
  uint _623 = _BFeeder_time_stamp_shreg;
  uint _624 = (uint)(ADD_UINT64_T_SUFFIX(11));
  uint _625 = _623 >> _624;
  bool _626 = _621 < _625;
  if (_626)
  {
   write_channel_intel(_BFeeder_channel, _BFeeder_channel_array);
   (void)_BFeeder_channel_array;
  } // if _626
  uint _627 = _BFeeder_cycle_temp;
  uint _628 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _629 = _627 + _628;
  _BFeeder_cycle_temp = _629;
 } // while _BFeeder_s0_outermost_loop_infinite
} // kernel kernel_BFeeder_1
// Address spaces for kernel_Out_1
__kernel void kernel_Out_1(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0)
{
 _BFeeder_channel_array_t _BFeeder_channel_array;
 _AFeeder_channel_array_t _AFeeder_channel_array;
 // produce Z
 complex _Z_shreg[256][8][4];
 complex _Z_pipe_shreg[8][769];
 // produce Y
 complex8 _Y_shreg[8];
 complex _Z_temp[8][4];
 // produce X
 complex8 _X_shreg[4];
 complex _Z_shreg_temp;
 int _Z_pipe_iter_temp;
 int _Z_pipe_base_temp;
 _Z_pipe_iter_temp = 1024;
 _Z_pipe_base_temp = 0;
 int _631 = _A_extent_1 >> 6;
 int _632 = _631 + 1;
 for (int _X_s0_i = 0; _X_s0_i < 0 + _632; _X_s0_i++)
 {
  int _633 = _B_extent_0 >> 7;
  for (int _X_s0_j = 0; _X_s0_j < 0 + _633; _X_s0_j++)
  {
   int _634 = _A_extent_0 >> 6;
   int _635 = _634 - _X_s0_i + ((_X_s0_i < _631) ? 0 : 1);
   for (int _X_s0_k = _X_s0_i; _X_s0_k < _X_s0_i + _635; _X_s0_k++)
   {
    for (int _X_s0_kk_ii_jj = 0; _X_s0_kk_ii_jj < 0 + 2048; _X_s0_kk_ii_jj++)
    {
     #pragma unroll
     for (int _dummy__1_s0_iii = 0; _dummy__1_s0_iii < 0 + 4; _dummy__1_s0_iii++)
     {
      #pragma unroll
      for (int _dummy_s0_jjj = 0; _dummy_s0_jjj < 0 + 8; _dummy_s0_jjj++)
      {
       complex _637 = _Z_shreg[255][_dummy_s0_jjj][_dummy__1_s0_iii];
       _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii] = _637;
       #pragma unroll
       for (int _dummy__2_s0_l1 = 0; _dummy__2_s0_l1 < 0 + 255; _dummy__2_s0_l1++)
       {
        int _638 = 255 - _dummy__2_s0_l1;
        int _639 = 254 - _dummy__2_s0_l1;
        complex _641 = _Z_shreg[_639][_dummy_s0_jjj][_dummy__1_s0_iii];
        _Z_shreg[_638][_dummy_s0_jjj][_dummy__1_s0_iii] = _641;
        (void)_641;
       } // for _dummy__2_s0_l1
       complex _642 = _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii];
       _Z_shreg[0][_dummy_s0_jjj][_dummy__1_s0_iii] = _642;
       (void)_642;
      } // for _dummy_s0_jjj
     } // for _dummy__1_s0_iii
     int _643 = _A_extent_1 >> 6;
     bool _644 = _X_s0_i < _643;
     if (_644)
     {
      _BFeeder_channel_array_t __645 = read_channel_intel(_BFeeder_channel);
      _BFeeder_channel_array = __645;
      (void)__645;
      _AFeeder_channel_array_t __646 = read_channel_intel(_AFeeder_channel);
      _AFeeder_channel_array = __646;
      (void)__646;
     } // if _644
     #pragma unroll
     for (int _X_s0_iii = 0; _X_s0_iii < 0 + 4; _X_s0_iii++)
     {
      #pragma unroll
      for (int _X_s0_jjj = 0; _X_s0_jjj < 0 + 8; _X_s0_jjj++)
      {
       complex8 _647;
       bool _648 = _X_s0_jjj == 0;
       if (_648)
       {
        complex8 __649 = _AFeeder_channel_array.s[_X_s0_iii];
        _647 = __649;
       } // if _648
       else
       {
        complex8 _651 = _X_shreg[_X_s0_iii];
        _647 = _651;
       } // if _648 else
       complex8 _652 = _647;
       _X_shreg[_X_s0_iii] = _652;
       (void)_652;
       complex8 _654 = _X_shreg[_X_s0_iii];
       complex8 _655 = __fpga_reg(__fpga_reg(_654));
       _X_shreg[_X_s0_iii] = _655;
       (void)_655;
       complex8 _656;
       bool _657 = _X_s0_iii == 0;
       if (_657)
       {
        complex8 __658 = _BFeeder_channel_array.s[_X_s0_jjj];
        _656 = __658;
       } // if _657
       else
       {
        complex8 _660 = _Y_shreg[_X_s0_jjj];
        _656 = _660;
       } // if _657 else
       complex8 _661 = _656;
       _Y_shreg[_X_s0_jjj] = _661;
       (void)_661;
       complex8 _663 = _Y_shreg[_X_s0_jjj];
       complex8 _664 = __fpga_reg(__fpga_reg(_663));
       _Y_shreg[_X_s0_jjj] = _664;
       (void)_664;
       complex _665;
       bool _666 = _X_s0_k == _X_s0_i;
       int _667 = _X_s0_kk_ii_jj >> 8;
       bool _668 = _667 == 0;
       bool _669 = _666 && _668;
       if (_669)
       {
        complex _670 = (complex)(0.000000f, 0.000000f);
        _665 = _670;
       } // if _669
       else
       {
        complex _672 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
        complex _673 = __fpga_reg(_672);
        _665 = _673;
       } // if _669 else
       complex _674 = _665;
       _Z_shreg_temp = _674;
       #pragma unroll
       for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
       {
        complex _675 = _Z_shreg_temp;
        complex _677 = _X_shreg[_X_s0_iii].s[_X_s0_kkk];
        complex _679 = _Y_shreg[_X_s0_jjj].s[_X_s0_kkk];
        complex _680 = (float2)(_677.s0 * _679.s0 - _677.s1 * _679.s1, _677.s0 * _679.s1 + _677.s1 * _679.s0);
        complex _681 = _675 + _680;
        _Z_shreg_temp = _681;
        int _682 = _X_s0_kkk & 3;
        bool _683 = _682 == 3;
        if (_683)
        {
         complex _684 = _Z_shreg_temp;
         complex _685 = __fpga_reg(_684);
         _Z_shreg_temp = _685;
        } // if _683
       } // for _X_s0_kkk
       complex _686 = _Z_shreg_temp;
       _Z_shreg[0][_X_s0_jjj][_X_s0_iii] = _686;
       (void)_686;
       #pragma unroll
       for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
       {
        bool _687 = _X_s0_kkk == 7;
        int _688 = _X_s0_kk_ii_jj >> 8;
        bool _689 = _688 == 7;
        bool _690 = _687 && _689;
        int _691 = _A_extent_0 >> 6;
        int _692 = _691 + -1;
        bool _693 = _X_s0_k == _692;
        bool _694 = _690 && _693;
        if (_694)
        {
         int _695 = _X_s0_iii * 256;
         complex _697 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
         _Z_pipe_shreg[_X_s0_jjj][_695] = _697;
         (void)_697;
        } // if _694
       } // for _X_s0_kkk
      } // for _X_s0_jjj
     } // for _X_s0_iii
     int _698 = _X_s0_kk_ii_jj & 15;
     bool _699 = _698 == 0;
     int _700 = _X_s0_kk_ii_jj & 255;
     int _701 = _700 >> 4;
     bool _702 = _701 == 0;
     bool _703 = _699 && _702;
     int _704 = _A_extent_0 >> 6;
     int _705 = _704 + -1;
     bool _706 = _X_s0_k == _705;
     bool _707 = _703 && _706;
     int _708 = _X_s0_kk_ii_jj >> 8;
     bool _709 = _708 == 7;
     bool _710 = _707 && _709;
     int _711 = _A_extent_1 >> 6;
     bool _712 = _X_s0_i < _711;
     bool _713 = _710 && _712;
     if (_713)
     {
      int _714 = _Z_pipe_iter_temp;
      _Z_pipe_base_temp = _714;
     } // if _713
     complex8 _Out_channel_temp;
     #pragma unroll
     for (int _Z_pipe_b__62 = 0; _Z_pipe_b__62 < 0 + 8; _Z_pipe_b__62++)
     {
      complex _716 = _Z_pipe_shreg[_Z_pipe_b__62][0];
      _Out_channel_temp.s[_Z_pipe_b__62] = _716;
      #pragma unroll
      for (int _Z_pipe_b__62_dummy = 0; _Z_pipe_b__62_dummy < 0 + 8; _Z_pipe_b__62_dummy++)
      {
       complex _717 = _Out_channel_temp.s[_Z_pipe_b__62_dummy];
       complex _718 = __fpga_reg(__fpga_reg(_717));
       _Out_channel_temp.s[_Z_pipe_b__62_dummy] = _718;
      } // for _Z_pipe_b__62_dummy
     } // for _Z_pipe_b__62
     int _719 = _Z_pipe_iter_temp;
     int _720 = _Z_pipe_base_temp;
     int _721 = _720 + 1024;
     bool _722 = _719 < _721;
     if (_722)
     {
      complex8 _723 = _Out_channel_temp;
      write_channel_intel(_Out_channel, _723);
      (void)_723;
     } // if _722
     #pragma unroll
     for (int _Z_pipe_b__63 = 0; _Z_pipe_b__63 < 0 + 8; _Z_pipe_b__63++)
     {
      #pragma unroll
      for (int _Z_pipe_p__31 = 0; _Z_pipe_p__31 < 0 + 3; _Z_pipe_p__31++)
      {
       #pragma unroll
       for (int _Z_pipe_l__31 = 0; _Z_pipe_l__31 < 0 + 255; _Z_pipe_l__31++)
       {
        int _724 = _Z_pipe_p__31 * 256;
        int _725 = _724 + _Z_pipe_l__31;
        int _726 = _725 + 1;
        complex _728 = _Z_pipe_shreg[_Z_pipe_b__63][_726];
        _Z_pipe_shreg[_Z_pipe_b__63][_725] = _728;
        (void)_728;
       } // for _Z_pipe_l__31
       int _729 = _Z_pipe_p__31 * 256;
       int _730 = _729 + 255;
       int _731 = _729 + 256;
       complex _733 = _Z_pipe_shreg[_Z_pipe_b__63][_731];
       complex _734 = __fpga_reg(__fpga_reg(_733));
       _Z_pipe_shreg[_Z_pipe_b__63][_730] = _734;
       (void)_734;
      } // for _Z_pipe_p__31
     } // for _Z_pipe_b__63
     int _735 = _Z_pipe_iter_temp;
     int _736 = _735 + 1;
     _Z_pipe_iter_temp = _736;
    } // for _X_s0_kk_ii_jj
   } // for _X_s0_k
  } // for _X_s0_j
 } // for _X_s0_i
} // kernel kernel_Out_1
// Address spaces for kernel_unloader_1
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader_1(
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__unloader_mem_channel complex *restrict _unloader_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _737 = _A_extent_1 >> 6;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _737; _unloader_s0_i++)
 {
  int _738 = _B_extent_0 >> 7;
  for (int _unloader_s0_j = 0; _unloader_s0_j < 0 + _738; _unloader_s0_j++)
  {
   for (int _unloader_s0_iii_ii_jj = 0; _unloader_s0_iii_ii_jj < 0 + 1024; _unloader_s0_iii_ii_jj++)
   {
    complex8 __739 = read_channel_intel(_Out_channel);
    int _740 = _addr_temp;
    int _741 = _740 * 8;
    vstore16(__739.t, 0, (__address_space__unloader_mem_channel float*)(_unloader_mem_channel + _741));
    int _742 = _addr_temp;
    int _743 = _742 + 1;
    _addr_temp = _743;
   } // for _unloader_s0_iii_ii_jj
  } // for _unloader_s0_j
 } // for _unloader_s0_i
} // kernel kernel_unloader_1
#undef __address_space__unloader_mem_channel

