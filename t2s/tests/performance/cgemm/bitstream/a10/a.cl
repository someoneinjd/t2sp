/*OpenCL C x86-64-linux-avx-avx2-avx512-avx512_skylake-cm-enable_synthesis-f16c-fma-intel_fpga-opencl-sse41*/
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
channel complex8 _aLoader_channel __attribute__((depth(256))) ;
typedef struct { complex8 s[10]; } _aFeeder_channel_array_t;
channel _aFeeder_channel_array_t _aFeeder_channel __attribute__((depth(256))) ;
channel complex8 _bLoader_channel __attribute__((depth(256))) ;
typedef struct { complex8 s[4]; } _bFeeder_channel_array_t;
channel _bFeeder_channel_array_t _bFeeder_channel __attribute__((depth(256))) ;
channel complex4 _Out_channel __attribute__((depth(256))) ;
// Address spaces for kernel_aLoader
#define __address_space__A_serializer_mem_channel __global
__kernel void kernel_aLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__A_serializer_mem_channel const complex *restrict _A_serializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _393 = _A_extent_1 / 320;
 for (int _aLoader_s0_i = 0; _aLoader_s0_i < 0 + _393; _aLoader_s0_i++)
 {
  int _394 = _B_extent_0 >> 7;
  for (int _aLoader_s0_j = 0; _aLoader_s0_j < 0 + _394; _aLoader_s0_j++)
  {
   int _395 = _A_extent_0 >> 8;
   for (int _aLoader_s0_k = 0; _aLoader_s0_k < 0 + _395; _aLoader_s0_k++)
   {
    for (int _aLoader_s0_kk_ii_iii = 0; _aLoader_s0_kk_ii_iii < 0 + 10240; _aLoader_s0_kk_ii_iii++)
    {
     int _396 = _addr_temp;
     int _397 = _B_extent_0 >> 7;
     int _398 = _A_extent_0 >> 8;
     int _399 = _397 * _398;
     int _400 = _399 * 10240;
     int _401 = _396 / _400;
     int _402 = _401 * _398;
     int _403 = _402 * 10240;
     int _404 = _398 * 10240;
     int _405 = _396 % _404;
     int _406 = _403 + _405;
     int _407 = _406 * 8;
     complex8 _408 = {vload16(0, (__address_space__A_serializer_mem_channel float*)(_A_serializer_mem_channel + _407))};
     write_channel_intel(_aLoader_channel, _408);
     (void)_408;
     int _409 = _396 + 1;
     _addr_temp = _409;
    } // for _aLoader_s0_kk_ii_iii
   } // for _aLoader_s0_k
  } // for _aLoader_s0_j
 } // for _aLoader_s0_i
} // kernel kernel_aLoader
#undef __address_space__A_serializer_mem_channel
// Address spaces for kernel_aFeeder
__kernel void kernel_aFeeder(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0)
{
 _aFeeder_channel_array_t _aFeeder_channel_array;
 complex8 _aFeeder_value_shreg;
 uint _aFeeder_time_stamp_shreg;
 complex8 _aFeeder_in_v_temp;
 uint _aFeeder_cycle_temp;
 complex8 __attribute__((memory, numbanks(16), singlepump, numwriteports(1), numreadports(1))) _aFeeder_DB_0_ibuffer[2][32][32][16];
 #pragma unroll
 for (int _aFeeder_s0_jjj_init = 0; _aFeeder_s0_jjj_init < 0 + 4; _aFeeder_s0_jjj_init++)
 {
  bool _410 = _aFeeder_s0_jjj_init == 0;
  if (_410)
  {
   uint _411 = (uint)(ADD_UINT64_T_SUFFIX(22528));
   _aFeeder_cycle_temp = _411;
  } // if _410
 } // for _aFeeder_s0_jjj_init
 int _412 = _A_extent_0 >> 8;
 int _413 = _A_extent_1 / 320;
 int _414 = _B_extent_0 >> 7;
 int _415 = _413 * _414;
 int _416 = _412 * _415;
 int _417 = _416 * 32768;
 int _418 = _417 + 32768;
 for (int _aFeeder_s0_outermost_loop = 0; _aFeeder_s0_outermost_loop < 0 + _418; _aFeeder_s0_outermost_loop++)
 {
  uint _419 = (uint)(ADD_UINT64_T_SUFFIX(22528));
  uint _420 = _aFeeder_cycle_temp;
  uint _421 = (uint)(ADD_UINT64_T_SUFFIX(32767));
  uint _422 = _420 & _421;
  bool _423 = _419 <= _422;
  uint _424 = (uint)(ADD_UINT64_T_SUFFIX(15));
  uint _425 = _420 >> _424;
  int _426 = (int)(_425);
  int _427 = _A_extent_0 >> 8;
  int _428 = _A_extent_1 / 320;
  int _429 = _B_extent_0 >> 7;
  int _430 = _428 * _429;
  int _431 = _427 * _430;
  bool _432 = _426 < _431;
  bool _433 = _423 && _432;
  if (_433)
  {
   complex8 __434 = read_channel_intel(_aLoader_channel);
   _aFeeder_in_v_temp = __434;
  } // if _433
  #pragma unroll
  for (int _aFeeder_s0_buf = 0; _aFeeder_s0_buf < 0 + 10; _aFeeder_s0_buf++)
  {
   bool _435 = _aFeeder_s0_buf == 0;
   if (_435)
   {
    complex8 _436 = _aFeeder_in_v_temp;
    _aFeeder_value_shreg = _436;
    (void)_436;
    uint _437 = _aFeeder_cycle_temp;
    _aFeeder_time_stamp_shreg = _437;
    (void)_437;
   } // if _435
   else
   {
    complex8 _439 = _aFeeder_value_shreg;
    _aFeeder_value_shreg = _439;
    (void)_439;
    uint _441 = _aFeeder_time_stamp_shreg;
    _aFeeder_time_stamp_shreg = _441;
    (void)_441;
   } // if _435 else
   complex8 _443 = _aFeeder_value_shreg;
   complex8 _444 = __fpga_reg(__fpga_reg(_443));
   _aFeeder_value_shreg = _444;
   (void)_444;
   uint _446 = _aFeeder_time_stamp_shreg;
   uint _447 = __fpga_reg(__fpga_reg(_446));
   _aFeeder_time_stamp_shreg = _447;
   (void)_447;
   uint _448 = (uint)(ADD_UINT64_T_SUFFIX(22528));
   uint _450 = _aFeeder_time_stamp_shreg;
   uint _451 = (uint)(ADD_UINT64_T_SUFFIX(32767));
   uint _452 = _450 & _451;
   bool _453 = _448 <= _452;
   if (_453)
   {
    uint _455 = _aFeeder_time_stamp_shreg;
    uint _456 = (uint)(ADD_UINT64_T_SUFFIX(32767));
    uint _457 = _455 & _456;
    uint _458 = (uint)(ADD_UINT64_T_SUFFIX(22528));
    uint _459 = _457 - _458;
    uint _460 = (uint)(ADD_UINT64_T_SUFFIX(10));
    uint _461 = _459 % _460;
    int _462 = (int)(_461);
    bool _463 = _aFeeder_s0_buf == _462;
    if (_463)
    {
     complex8 _465 = _aFeeder_value_shreg;
     uint _467 = _aFeeder_time_stamp_shreg;
     uint _468 = (uint)(ADD_UINT64_T_SUFFIX(15));
     uint _469 = _467 >> _468;
     uint _470 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _471 = _469 & _470;
     bool _472 = (bool)(_471);
     uint _474 = (uint)(ADD_UINT64_T_SUFFIX(32767));
     uint _475 = _467 & _474;
     uint _476 = (uint)(ADD_UINT64_T_SUFFIX(22528));
     uint _477 = _475 - _476;
     int _478 = (int)(_477);
     int _479 = _478 / 320;
     int _481 = _478 / 10;
     int _482 = _481 & 31;
     _aFeeder_DB_0_ibuffer[_472][_479][_482][_aFeeder_s0_buf] = _465;
    } // if _463
   } // if _453
   uint _484 = _aFeeder_time_stamp_shreg;
   uint _485 = (uint)(ADD_UINT64_T_SUFFIX(15));
   uint _486 = _484 >> _485;
   int _487 = (int)(_486);
   int _488 = _A_extent_0 >> 8;
   int _489 = _A_extent_1 / 320;
   int _490 = _B_extent_0 >> 7;
   int _491 = _489 * _490;
   int _492 = _488 * _491;
   bool _493 = _487 <= _492;
   uint _494 = (uint)(ADD_UINT64_T_SUFFIX(0));
   bool _496 = _494 < _486;
   bool _497 = _493 && _496;
   if (_497)
   {
    uint _499 = _aFeeder_time_stamp_shreg;
    uint _500 = (uint)(ADD_UINT64_T_SUFFIX(15));
    uint _501 = _499 >> _500;
    uint _502 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _503 = _501 & _502;
    bool _504 = (bool)(_503);
    bool _505 = !(_504);
    uint _507 = (uint)(ADD_UINT64_T_SUFFIX(32767));
    uint _508 = _499 & _507;
    int _509 = (int)(_508);
    int _510 = _509 >> 10;
    int _512 = _509 >> 5;
    int _513 = _512 & 31;
    complex8 _514 = _aFeeder_DB_0_ibuffer[_505][_510][_513][_aFeeder_s0_buf];
    _aFeeder_channel_array.s[_aFeeder_s0_buf] = _514;
    (void)_aFeeder_s0_buf;
   } // if _497
  } // for _aFeeder_s0_buf
  uint _516 = _aFeeder_time_stamp_shreg;
  uint _517 = (uint)(ADD_UINT64_T_SUFFIX(15));
  uint _518 = _516 >> _517;
  int _519 = (int)(_518);
  int _520 = _A_extent_0 >> 8;
  int _521 = _A_extent_1 / 320;
  int _522 = _B_extent_0 >> 7;
  int _523 = _521 * _522;
  int _524 = _520 * _523;
  bool _525 = _519 <= _524;
  uint _526 = (uint)(ADD_UINT64_T_SUFFIX(0));
  bool _528 = _526 < _518;
  bool _529 = _525 && _528;
  if (_529)
  {
   write_channel_intel(_aFeeder_channel, _aFeeder_channel_array);
   (void)_aFeeder_channel_array;
  } // if _529
  uint _530 = _aFeeder_cycle_temp;
  uint _531 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _532 = _530 + _531;
  _aFeeder_cycle_temp = _532;
 } // for _aFeeder_s0_outermost_loop
} // kernel kernel_aFeeder
// Address spaces for kernel_bLoader
#define __address_space__B_serializer_mem_channel __global
__kernel void kernel_bLoader(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__B_serializer_mem_channel const complex *restrict _B_serializer_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _533 = _A_extent_1 / 320;
 for (int _bLoader_s0_i = 0; _bLoader_s0_i < 0 + _533; _bLoader_s0_i++)
 {
  int _534 = _B_extent_0 >> 7;
  for (int _bLoader_s0_j = 0; _bLoader_s0_j < 0 + _534; _bLoader_s0_j++)
  {
   int _535 = _A_extent_0 >> 8;
   for (int _bLoader_s0_k = 0; _bLoader_s0_k < 0 + _535; _bLoader_s0_k++)
   {
    for (int _bLoader_s0_kk_jj_jjj = 0; _bLoader_s0_kk_jj_jjj < 0 + 4096; _bLoader_s0_kk_jj_jjj++)
    {
     int _536 = _addr_temp;
     int _537 = _B_extent_0 >> 7;
     int _538 = _A_extent_0 >> 8;
     int _539 = _537 * _538;
     int _540 = _539 * 4096;
     int _541 = _536 % _540;
     int _542 = _541 * 8;
     complex8 _543 = {vload16(0, (__address_space__B_serializer_mem_channel float*)(_B_serializer_mem_channel + _542))};
     write_channel_intel(_bLoader_channel, _543);
     (void)_543;
     int _544 = _536 + 1;
     _addr_temp = _544;
    } // for _bLoader_s0_kk_jj_jjj
   } // for _bLoader_s0_k
  } // for _bLoader_s0_j
 } // for _bLoader_s0_i
} // kernel kernel_bLoader
#undef __address_space__B_serializer_mem_channel
// Address spaces for kernel_bFeeder
__kernel void kernel_bFeeder(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0)
{
 _bFeeder_channel_array_t _bFeeder_channel_array;
 complex8 _bFeeder_value_shreg;
 uint _bFeeder_time_stamp_shreg;
 complex8 _bFeeder_in_v_temp;
 uint _bFeeder_cycle_temp;
 complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _bFeeder_DB_0_ibuffer[2][32][32][4];
 #pragma unroll
 for (int _bFeeder_s0_iii_init = 0; _bFeeder_s0_iii_init < 0 + 10; _bFeeder_s0_iii_init++)
 {
  bool _545 = _bFeeder_s0_iii_init == 0;
  if (_545)
  {
   uint _546 = (uint)(ADD_UINT64_T_SUFFIX(28672));
   _bFeeder_cycle_temp = _546;
  } // if _545
 } // for _bFeeder_s0_iii_init
 int _547 = _A_extent_0 >> 8;
 int _548 = _A_extent_1 / 320;
 int _549 = _B_extent_0 >> 7;
 int _550 = _548 * _549;
 int _551 = _547 * _550;
 int _552 = _551 * 32768;
 int _553 = _552 + 32768;
 for (int _bFeeder_s0_outermost_loop = 0; _bFeeder_s0_outermost_loop < 0 + _553; _bFeeder_s0_outermost_loop++)
 {
  uint _554 = (uint)(ADD_UINT64_T_SUFFIX(28672));
  uint _555 = _bFeeder_cycle_temp;
  uint _556 = (uint)(ADD_UINT64_T_SUFFIX(32767));
  uint _557 = _555 & _556;
  bool _558 = _554 <= _557;
  uint _559 = (uint)(ADD_UINT64_T_SUFFIX(15));
  uint _560 = _555 >> _559;
  int _561 = (int)(_560);
  int _562 = _A_extent_0 >> 8;
  int _563 = _A_extent_1 / 320;
  int _564 = _B_extent_0 >> 7;
  int _565 = _563 * _564;
  int _566 = _562 * _565;
  bool _567 = _561 < _566;
  bool _568 = _558 && _567;
  if (_568)
  {
   complex8 __569 = read_channel_intel(_bLoader_channel);
   _bFeeder_in_v_temp = __569;
  } // if _568
  #pragma unroll
  for (int _bFeeder_s0_buf = 0; _bFeeder_s0_buf < 0 + 4; _bFeeder_s0_buf++)
  {
   bool _570 = _bFeeder_s0_buf == 0;
   if (_570)
   {
    complex8 _571 = _bFeeder_in_v_temp;
    _bFeeder_value_shreg = _571;
    (void)_571;
    uint _572 = _bFeeder_cycle_temp;
    _bFeeder_time_stamp_shreg = _572;
    (void)_572;
   } // if _570
   else
   {
    complex8 _574 = _bFeeder_value_shreg;
    _bFeeder_value_shreg = _574;
    (void)_574;
    uint _576 = _bFeeder_time_stamp_shreg;
    _bFeeder_time_stamp_shreg = _576;
    (void)_576;
   } // if _570 else
   complex8 _578 = _bFeeder_value_shreg;
   complex8 _579 = __fpga_reg(__fpga_reg(_578));
   _bFeeder_value_shreg = _579;
   (void)_579;
   uint _581 = _bFeeder_time_stamp_shreg;
   uint _582 = __fpga_reg(__fpga_reg(_581));
   _bFeeder_time_stamp_shreg = _582;
   (void)_582;
   uint _583 = (uint)(ADD_UINT64_T_SUFFIX(28672));
   uint _585 = _bFeeder_time_stamp_shreg;
   uint _586 = (uint)(ADD_UINT64_T_SUFFIX(32767));
   uint _587 = _585 & _586;
   bool _588 = _583 <= _587;
   if (_588)
   {
    uint _590 = _bFeeder_time_stamp_shreg;
    uint _591 = (uint)(ADD_UINT64_T_SUFFIX(32767));
    uint _592 = _590 & _591;
    uint _593 = (uint)(ADD_UINT64_T_SUFFIX(28672));
    uint _594 = _592 - _593;
    uint _595 = (uint)(ADD_UINT64_T_SUFFIX(3));
    uint _596 = _594 & _595;
    int _597 = (int)(_596);
    bool _598 = _bFeeder_s0_buf == _597;
    if (_598)
    {
     complex8 _600 = _bFeeder_value_shreg;
     uint _602 = _bFeeder_time_stamp_shreg;
     uint _603 = (uint)(ADD_UINT64_T_SUFFIX(15));
     uint _604 = _602 >> _603;
     uint _605 = (uint)(ADD_UINT64_T_SUFFIX(1));
     uint _606 = _604 & _605;
     bool _607 = (bool)(_606);
     uint _609 = (uint)(ADD_UINT64_T_SUFFIX(32767));
     uint _610 = _602 & _609;
     uint _611 = (uint)(ADD_UINT64_T_SUFFIX(28672));
     uint _612 = _610 - _611;
     int _613 = (int)(_612);
     int _614 = _613 >> 7;
     int _616 = _613 >> 2;
     int _617 = _616 & 31;
     _bFeeder_DB_0_ibuffer[_607][_614][_617][_bFeeder_s0_buf] = _600;
    } // if _598
   } // if _588
   uint _619 = _bFeeder_time_stamp_shreg;
   uint _620 = (uint)(ADD_UINT64_T_SUFFIX(15));
   uint _621 = _619 >> _620;
   int _622 = (int)(_621);
   int _623 = _A_extent_0 >> 8;
   int _624 = _A_extent_1 / 320;
   int _625 = _B_extent_0 >> 7;
   int _626 = _624 * _625;
   int _627 = _623 * _626;
   bool _628 = _622 <= _627;
   uint _629 = (uint)(ADD_UINT64_T_SUFFIX(0));
   bool _631 = _629 < _621;
   bool _632 = _628 && _631;
   if (_632)
   {
    uint _634 = _bFeeder_time_stamp_shreg;
    uint _635 = (uint)(ADD_UINT64_T_SUFFIX(15));
    uint _636 = _634 >> _635;
    uint _637 = (uint)(ADD_UINT64_T_SUFFIX(1));
    uint _638 = _636 & _637;
    bool _639 = (bool)(_638);
    bool _640 = !(_639);
    uint _642 = (uint)(ADD_UINT64_T_SUFFIX(32767));
    uint _643 = _634 & _642;
    int _644 = (int)(_643);
    int _645 = _644 >> 10;
    int _647 = _644 & 31;
    complex8 _648 = _bFeeder_DB_0_ibuffer[_640][_645][_647][_bFeeder_s0_buf];
    _bFeeder_channel_array.s[_bFeeder_s0_buf] = _648;
    (void)_bFeeder_s0_buf;
   } // if _632
  } // for _bFeeder_s0_buf
  uint _650 = _bFeeder_time_stamp_shreg;
  uint _651 = (uint)(ADD_UINT64_T_SUFFIX(15));
  uint _652 = _650 >> _651;
  int _653 = (int)(_652);
  int _654 = _A_extent_0 >> 8;
  int _655 = _A_extent_1 / 320;
  int _656 = _B_extent_0 >> 7;
  int _657 = _655 * _656;
  int _658 = _654 * _657;
  bool _659 = _653 <= _658;
  uint _660 = (uint)(ADD_UINT64_T_SUFFIX(0));
  bool _662 = _660 < _652;
  bool _663 = _659 && _662;
  if (_663)
  {
   write_channel_intel(_bFeeder_channel, _bFeeder_channel_array);
   (void)_bFeeder_channel_array;
  } // if _663
  uint _664 = _bFeeder_cycle_temp;
  uint _665 = (uint)(ADD_UINT64_T_SUFFIX(1));
  uint _666 = _664 + _665;
  _bFeeder_cycle_temp = _666;
 } // for _bFeeder_s0_outermost_loop
} // kernel kernel_bFeeder
// Address spaces for kernel_Out
__kernel void kernel_Out(
 const int _A_extent_0,
 const int _A_extent_1,
 const int _B_extent_0)
{
 _bFeeder_channel_array_t _bFeeder_channel_array;
 _aFeeder_channel_array_t _aFeeder_channel_array;
 // produce Z
 complex _Z_shreg[1024][4][10];
 complex _Z_pipe_shreg[4][9217];
 // produce Y
 complex8 _Y_shreg[4];
 complex _Z_temp[4][10];
 // produce X
 complex8 _X_shreg[10];
 complex _Z_shreg_temp;
 int _Z_pipe_iter_temp;
 int _Z_pipe_base_temp;
 _Z_pipe_iter_temp = 10240;
 _Z_pipe_base_temp = 0;
 int _667 = _A_extent_0 >> 8;
 int _668 = _A_extent_1 / 320;
 int _669 = _B_extent_0 >> 7;
 int _670 = _668 * _669;
 int _671 = _667 * _670;
 int _672 = _671 + 1;
 for (int _X_s0_i_j_k = 0; _X_s0_i_j_k < 0 + _672; _X_s0_i_j_k++)
 {
  for (int _X_s0_kk_ii_jj = 0; _X_s0_kk_ii_jj < 0 + 32768; _X_s0_kk_ii_jj++)
  {
   #pragma unroll
   for (int _dummy__1_s0_iii = 0; _dummy__1_s0_iii < 0 + 10; _dummy__1_s0_iii++)
   {
    #pragma unroll
    for (int _dummy_s0_jjj = 0; _dummy_s0_jjj < 0 + 4; _dummy_s0_jjj++)
    {
     complex _674 = _Z_shreg[1023][_dummy_s0_jjj][_dummy__1_s0_iii];
     _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii] = _674;
     #pragma unroll
     for (int _dummy__2_s0_l1 = 0; _dummy__2_s0_l1 < 0 + 1023; _dummy__2_s0_l1++)
     {
      int _675 = 1023 - _dummy__2_s0_l1;
      int _676 = 1022 - _dummy__2_s0_l1;
      complex _678 = _Z_shreg[_676][_dummy_s0_jjj][_dummy__1_s0_iii];
      _Z_shreg[_675][_dummy_s0_jjj][_dummy__1_s0_iii] = _678;
      (void)_678;
     } // for _dummy__2_s0_l1
     complex _679 = _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii];
     _Z_shreg[0][_dummy_s0_jjj][_dummy__1_s0_iii] = _679;
     (void)_679;
    } // for _dummy_s0_jjj
   } // for _dummy__1_s0_iii
   int _680 = _A_extent_0 >> 8;
   int _681 = _A_extent_1 / 320;
   int _682 = _B_extent_0 >> 7;
   int _683 = _681 * _682;
   int _684 = _680 * _683;
   bool _685 = _X_s0_i_j_k < _684;
   if (_685)
   {
    _bFeeder_channel_array_t __686 = read_channel_intel(_bFeeder_channel);
    _bFeeder_channel_array = __686;
    (void)__686;
    _aFeeder_channel_array_t __687 = read_channel_intel(_aFeeder_channel);
    _aFeeder_channel_array = __687;
    (void)__687;
   } // if _685
   #pragma unroll
   for (int _X_s0_iii = 0; _X_s0_iii < 0 + 10; _X_s0_iii++)
   {
    #pragma unroll
    for (int _X_s0_jjj = 0; _X_s0_jjj < 0 + 4; _X_s0_jjj++)
    {
     complex8 _688;
     bool _689 = _X_s0_jjj == 0;
     if (_689)
     {
      complex8 __690 = _aFeeder_channel_array.s[_X_s0_iii];
      _688 = __690;
     } // if _689
     else
     {
      complex8 _692 = _X_shreg[_X_s0_iii];
      _688 = _692;
     } // if _689 else
     complex8 _693 = _688;
     _X_shreg[_X_s0_iii] = _693;
     (void)_693;
     complex8 _695 = _X_shreg[_X_s0_iii];
     complex8 _696 = __fpga_reg(__fpga_reg(_695));
     _X_shreg[_X_s0_iii] = _696;
     (void)_696;
     complex8 _697;
     bool _698 = _X_s0_iii == 0;
     if (_698)
     {
      complex8 __699 = _bFeeder_channel_array.s[_X_s0_jjj];
      _697 = __699;
     } // if _698
     else
     {
      complex8 _701 = _Y_shreg[_X_s0_jjj];
      _697 = _701;
     } // if _698 else
     complex8 _702 = _697;
     _Y_shreg[_X_s0_jjj] = _702;
     (void)_702;
     complex8 _704 = _Y_shreg[_X_s0_jjj];
     complex8 _705 = __fpga_reg(__fpga_reg(_704));
     _Y_shreg[_X_s0_jjj] = _705;
     (void)_705;
     complex _706;
     int _707 = _A_extent_0 >> 8;
     int _708 = _X_s0_i_j_k % _707;
     bool _709 = _708 == 0;
     int _710 = _X_s0_kk_ii_jj >> 10;
     bool _711 = _710 == 0;
     bool _712 = _709 && _711;
     if (_712)
     {
      complex _713 = (complex)(0.000000f, 0.000000f);
      _706 = _713;
     } // if _712
     else
     {
      complex _715 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
      complex _716 = __fpga_reg(_715);
      _706 = _716;
     } // if _712 else
     complex _717 = _706;
     _Z_shreg_temp = _717;
     #pragma unroll
     for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
     {
      complex _718 = _Z_shreg_temp;
      complex _720 = _X_shreg[_X_s0_iii].s[_X_s0_kkk];
      complex _722 = _Y_shreg[_X_s0_jjj].s[_X_s0_kkk];
      complex _723 = (float2)(_720.s0 * _722.s0 - _720.s1 * _722.s1, _720.s0 * _722.s1 + _720.s1 * _722.s0);
      complex _724 = _718 + _723;
      _Z_shreg_temp = _724;
      int _725 = _X_s0_kkk & 3;
      bool _726 = _725 == 3;
      if (_726)
      {
       complex _727 = _Z_shreg_temp;
       complex _728 = __fpga_reg(_727);
       _Z_shreg_temp = _728;
      } // if _726
     } // for _X_s0_kkk
     complex _729 = _Z_shreg_temp;
     _Z_shreg[0][_X_s0_jjj][_X_s0_iii] = _729;
     (void)_729;
     #pragma unroll
     for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
     {
      bool _730 = _X_s0_kkk == 7;
      int _731 = _X_s0_kk_ii_jj >> 10;
      bool _732 = _731 == 31;
      bool _733 = _730 && _732;
      int _734 = _A_extent_0 >> 8;
      int _735 = _X_s0_i_j_k % _734;
      int _736 = _734 + -1;
      bool _737 = _735 == _736;
      bool _738 = _733 && _737;
      if (_738)
      {
       int _739 = _X_s0_iii * 1024;
       complex _741 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
       _Z_pipe_shreg[_X_s0_jjj][_739] = _741;
       (void)_741;
      } // if _738
     } // for _X_s0_kkk
    } // for _X_s0_jjj
   } // for _X_s0_iii
   int _742 = _X_s0_kk_ii_jj & 31;
   bool _743 = _742 == 0;
   int _744 = _X_s0_kk_ii_jj & 1023;
   int _745 = _744 >> 5;
   bool _746 = _745 == 0;
   bool _747 = _743 && _746;
   int _748 = _A_extent_0 >> 8;
   int _749 = _X_s0_i_j_k % _748;
   int _750 = _748 + -1;
   bool _751 = _749 == _750;
   bool _752 = _747 && _751;
   int _753 = _X_s0_kk_ii_jj >> 10;
   bool _754 = _753 == 31;
   bool _755 = _752 && _754;
   if (_755)
   {
    int _756 = _Z_pipe_iter_temp;
    _Z_pipe_base_temp = _756;
   } // if _755
   complex4 _Out_channel_temp;
   #pragma unroll
   for (int _Z_pipe_b__14 = 0; _Z_pipe_b__14 < 0 + 4; _Z_pipe_b__14++)
   {
    complex _758 = _Z_pipe_shreg[_Z_pipe_b__14][0];
    _Out_channel_temp.s[_Z_pipe_b__14] = _758;
    #pragma unroll
    for (int _Z_pipe_b__14_dummy = 0; _Z_pipe_b__14_dummy < 0 + 4; _Z_pipe_b__14_dummy++)
    {
     complex _759 = _Out_channel_temp.s[_Z_pipe_b__14_dummy];
     complex _760 = __fpga_reg(__fpga_reg(_759));
     _Out_channel_temp.s[_Z_pipe_b__14_dummy] = _760;
    } // for _Z_pipe_b__14_dummy
   } // for _Z_pipe_b__14
   int _761 = _Z_pipe_iter_temp;
   int _762 = _Z_pipe_base_temp;
   int _763 = _762 + 10240;
   bool _764 = _761 < _763;
   if (_764)
   {
    complex4 _765 = _Out_channel_temp;
    write_channel_intel(_Out_channel, _765);
    (void)_765;
   } // if _764
   #pragma unroll
   for (int _Z_pipe_b__15 = 0; _Z_pipe_b__15 < 0 + 4; _Z_pipe_b__15++)
   {
    #pragma unroll
    for (int _Z_pipe_p__7 = 0; _Z_pipe_p__7 < 0 + 9; _Z_pipe_p__7++)
    {
     #pragma unroll
     for (int _Z_pipe_l__7 = 0; _Z_pipe_l__7 < 0 + 1023; _Z_pipe_l__7++)
     {
      int _766 = _Z_pipe_p__7 * 1024;
      int _767 = _766 + _Z_pipe_l__7;
      int _768 = _767 + 1;
      complex _770 = _Z_pipe_shreg[_Z_pipe_b__15][_768];
      _Z_pipe_shreg[_Z_pipe_b__15][_767] = _770;
      (void)_770;
     } // for _Z_pipe_l__7
     int _771 = _Z_pipe_p__7 * 1024;
     int _772 = _771 + 1023;
     int _773 = _771 + 1024;
     complex _775 = _Z_pipe_shreg[_Z_pipe_b__15][_773];
     complex _776 = __fpga_reg(__fpga_reg(_775));
     _Z_pipe_shreg[_Z_pipe_b__15][_772] = _776;
     (void)_776;
    } // for _Z_pipe_p__7
   } // for _Z_pipe_b__15
   int _777 = _Z_pipe_iter_temp;
   int _778 = _777 + 1;
   _Z_pipe_iter_temp = _778;
  } // for _X_s0_kk_ii_jj
 } // for _X_s0_i_j_k
} // kernel kernel_Out
// Address spaces for kernel_unloader
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader(
 const int _A_extent_1,
 const int _B_extent_0,
 __address_space__unloader_mem_channel complex *restrict _unloader_mem_channel)
{
 int _addr_temp;
 _addr_temp = 0;
 int _779 = _A_extent_1 / 320;
 for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _779; _unloader_s0_i++)
 {
  int _780 = _B_extent_0 >> 7;
  for (int _unloader_s0_j = 0; _unloader_s0_j < 0 + _780; _unloader_s0_j++)
  {
   for (int _unloader_s0_iii_ii_jj = 0; _unloader_s0_iii_ii_jj < 0 + 10240; _unloader_s0_iii_ii_jj++)
   {
    complex4 __781 = read_channel_intel(_Out_channel);
    int _782 = _addr_temp;
    int _783 = _782 * 4;
    vstore8(__781.t, 0, (__address_space__unloader_mem_channel float*)(_unloader_mem_channel + _783));
    int _784 = _addr_temp;
    int _785 = _784 + 1;
    _addr_temp = _785;
   } // for _unloader_s0_iii_ii_jj
  } // for _unloader_s0_j
 } // for _unloader_s0_i
} // kernel kernel_unloader
#undef __address_space__unloader_mem_channel

