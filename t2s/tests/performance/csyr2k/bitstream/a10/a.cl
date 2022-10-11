/*OpenCL C x86-64-linux-avx-avx2-avx512-avx512_skylake-enable_synthesis-f16c-fma-intel_fpga-opencl-sse41*/
#pragma OPENCL FP_CONTRACT ON
#define float_from_bits(x) as_float(x)
inline float nan_f32() { return NAN; }
inline float neg_inf_f32() { return -INFINITY; }
inline float inf_f32() { return INFINITY; }
inline bool is_nan_f32(float x) { return isnan(x); }
inline bool is_inf_f32(float x) { return isinf(x); }
inline bool is_finite_f32(float x) { return isfinite(x); }
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
typedef union {
    float4 t;
    float2 s[2];
} complex2;
typedef union {
    float8 t;
    float2 s[4];
} complex4;
typedef union {
    float16 t;
    float2 s[8];
} complex8;
inline float2 conjugate(float2 x) { return (float2)(x.s0, -x.s1); }
inline float2 sqrt_c32(float2 x) { return (float2)(sqrt_f32(x.s0), 0.0f); }
inline float2 fast_inverse_c32(float2 x) { return (float2)(fast_inverse_f32(x.s0), 0.0f); }
inline float2 fast_inverse_sqrt_c32(float2 x) { return (float2)(fast_inverse_sqrt_f32(x.s0), 0.0f); }
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
channel complex8 _ALoader_channel __attribute__((depth(0)));
typedef struct
{
    complex8 s[4];
} _AFeeder_channel_array_t;
channel _AFeeder_channel_array_t _AFeeder_channel __attribute__((depth(0)));
channel complex8 _BLoader_channel __attribute__((depth(0)));
typedef struct
{
    complex8 s[4];
} _BFeeder_channel_array_t;
channel _BFeeder_channel_array_t _BFeeder_channel __attribute__((depth(0)));
channel complex4 _Out_channel __attribute__((depth(0)));
channel complex8 _ALoader_T_channel __attribute__((depth(0)));
typedef struct
{
    complex8 s[4];
} _AFeeder_T_channel_array_t;
channel _AFeeder_T_channel_array_t _AFeeder_T_channel __attribute__((depth(0)));
channel complex8 _BLoader_T_channel __attribute__((depth(0)));
typedef struct
{
    complex8 s[4];
} _BFeeder_T_channel_array_t;
channel _BFeeder_T_channel_array_t _BFeeder_T_channel __attribute__((depth(0)));
channel complex4 _Out_T_channel __attribute__((depth(0)));
channel complex4 _E_channel __attribute__((depth(0)));
// Address spaces for kernel_ALoader_1
#define __address_space__ASerializer_mem_channel __global
__kernel void kernel_ALoader_1(
    const int _A_extent_0,
    const int _A_extent_1,
    const int _B_extent_0,
    __address_space__ASerializer_mem_channel const complex *restrict _ASerializer_mem_channel)
{
    int _747 = _A_extent_1 >> 7;
    int _748 = _747 + 1;
    for (int _ALoader_s0_i = 0; _ALoader_s0_i < 0 + _748; _ALoader_s0_i++)
    {
        int _749 = _B_extent_0 >> 7;
        int _750 = _749 - _ALoader_s0_i + ((_ALoader_s0_i < _747) ? 0 : 1);
        for (int _ALoader_s0_j = _ALoader_s0_i; _ALoader_s0_j < _ALoader_s0_i + _750; _ALoader_s0_j++)
        {
            int _751 = _A_extent_0 >> 7;
            for (int _ALoader_s0_k = 0; _ALoader_s0_k < 0 + _751; _ALoader_s0_k++)
            {
#pragma loop_coalesce 3
                for (int _ALoader_s0_kk = 0; _ALoader_s0_kk < 0 + 16; _ALoader_s0_kk++)
                {
                    for (int _ALoader_s0_ii = 0; _ALoader_s0_ii < 0 + 32; _ALoader_s0_ii++)
                    {
                        for (int _ALoader_s0_iii = 0; _ALoader_s0_iii < 0 + 4; _ALoader_s0_iii++)
                        {
                            bool _752 = _ALoader_s0_j == _ALoader_s0_i;
                            bool _753 = _ALoader_s0_k == 0;
                            bool _754 = _752 && _753;
                            int _765 = _A_extent_1 >> 7;
                            bool _766 = _ALoader_s0_i < _765;
                            bool _767 = _754 || _766;
                            if (_767)
                            {
                                complex8 _768;
                                int _769 = _A_extent_1 >> 7;
                                bool _770 = _ALoader_s0_i < _769;
                                if (_770)
                                {
                                    int _21 = _ALoader_s0_iii * 8 + _ALoader_s0_ii * 32 + _ALoader_s0_kk * 1024;
                                    int _22 = _21 + _ALoader_s0_k * 16384;
                                    int _23 = _22 + _ALoader_s0_i * 16384 * _751;
                                    complex8 _784 = {vload16(0, (__address_space__ASerializer_mem_channel float *)(_ASerializer_mem_channel + _23))};
                                    _768 = _784;
                                } // if _770
                                else
                                {
                                    float _34 = float_from_bits(0 /* 0 */);
                                    _768.t = _34;
                                } // if _770 else
                                complex8 _787 = _768;
                                write_channel_intel(_ALoader_channel, _787);
                                (void)_787;
                            } // if _767
                        }     // for _ALoader_s0_iii
                    }         // for _ALoader_s0_ii
                }             // for _ALoader_s0_kk
            }                 // for _ALoader_s0_k
        }                     // for _ALoader_s0_j
    }                         // for _ALoader_s0_i
} // kernel kernel_ALoader_1
#undef __address_space__ASerializer_mem_channel
// Address spaces for kernel_AFeeder_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void
kernel_AFeeder_1()
{
    _AFeeder_channel_array_t _AFeeder_channel_array;
    complex8 _AFeeder_value_shreg;
    uint _AFeeder_time_stamp_shreg;
    complex8 _AFeeder_in_v_temp;
    uint _AFeeder_cycle_temp;
    complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _AFeeder_DB_0_ibuffer[2][16][32][4];
#pragma unroll
    for (int _AFeeder_s0_jjj_init = 0; _AFeeder_s0_jjj_init < 0 + 4; _AFeeder_s0_jjj_init++)
    {
        bool _790 = _AFeeder_s0_jjj_init == 0;
        if (_790)
        {
            uint _791 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            _AFeeder_cycle_temp = _791;
        } // if _790
    }     // for _AFeeder_s0_jjj_init
    while (1)
    {
        uint _792 = (uint)(ADD_UINT64_T_SUFFIX(14336));
        uint _793 = _AFeeder_cycle_temp;
        uint _794 = (uint)(ADD_UINT64_T_SUFFIX(16383));
        uint _795 = _793 & _794;
        bool _796 = _792 <= _795;
        if (_796)
        {
            complex8 __797 = read_channel_intel(_ALoader_channel);
            _AFeeder_in_v_temp = __797;
        } // if _796
#pragma unroll
        for (int _AFeeder_s0_buf = 0; _AFeeder_s0_buf < 0 + 4; _AFeeder_s0_buf++)
        {
            bool _798 = _AFeeder_s0_buf == 0;
            if (_798)
            {
                complex8 _799 = _AFeeder_in_v_temp;
                _AFeeder_value_shreg = _799;
                (void)_799;
                uint _800 = _AFeeder_cycle_temp;
                _AFeeder_time_stamp_shreg = _800;
                (void)_800;
            } // if _798
            else
            {
                complex8 _802 = _AFeeder_value_shreg;
                _AFeeder_value_shreg = _802;
                (void)_802;
                uint _804 = _AFeeder_time_stamp_shreg;
                _AFeeder_time_stamp_shreg = _804;
                (void)_804;
            } // if _798 else
            complex8 _806 = _AFeeder_value_shreg;
            complex8 _807 = __fpga_reg(__fpga_reg(_806));
            _AFeeder_value_shreg = _807;
            (void)_807;
            uint _809 = _AFeeder_time_stamp_shreg;
            uint _810 = __fpga_reg(__fpga_reg(_809));
            _AFeeder_time_stamp_shreg = _810;
            (void)_810;
            uint _811 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            uint _813 = _AFeeder_time_stamp_shreg;
            uint _814 = (uint)(ADD_UINT64_T_SUFFIX(16383));
            uint _815 = _813 & _814;
            bool _816 = _811 <= _815;
            if (_816)
            {
                uint _818 = _AFeeder_time_stamp_shreg;
                uint _819 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _820 = _818 & _819;
                uint _821 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                uint _822 = _820 - _821;
                uint _823 = (uint)(ADD_UINT64_T_SUFFIX(3));
                uint _824 = _822 & _823;
                int _825 = (int)(_824);
                bool _826 = _AFeeder_s0_buf == _825;
                if (_826)
                {
                    complex8 _828 = _AFeeder_value_shreg;
                    uint _830 = _AFeeder_time_stamp_shreg;
                    uint _831 = (uint)(ADD_UINT64_T_SUFFIX(14));
                    uint _832 = _830 >> _831;
                    uint _833 = (uint)(ADD_UINT64_T_SUFFIX(1));
                    uint _834 = _832 & _833;
                    bool _835 = (bool)(_834);
                    uint _837 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                    uint _838 = _830 & _837;
                    uint _839 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                    uint _840 = _838 - _839;
                    int _841 = (int)(_840);
                    int _842 = _841 >> 7;
                    int _844 = _841 >> 2;
                    int _845 = _844 & 31;
                    _AFeeder_DB_0_ibuffer[_835][_842][_845][_AFeeder_s0_buf] = _828;
                } // if _826
            }     // if _816
            uint _846 = (uint)(ADD_UINT64_T_SUFFIX(0));
            uint _848 = _AFeeder_time_stamp_shreg;
            uint _849 = (uint)(ADD_UINT64_T_SUFFIX(14));
            uint _850 = _848 >> _849;
            bool _851 = _846 < _850;
            if (_851)
            {
                uint _853 = _AFeeder_time_stamp_shreg;
                uint _854 = (uint)(ADD_UINT64_T_SUFFIX(14));
                uint _855 = _853 >> _854;
                uint _856 = (uint)(ADD_UINT64_T_SUFFIX(1));
                uint _857 = _855 & _856;
                bool _858 = (bool)(_857);
                bool _859 = !(_858);
                uint _861 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _862 = _853 & _861;
                int _863 = (int)(_862);
                int _864 = _863 >> 10;
                int _866 = _863 >> 5;
                int _867 = _866 & 31;
                complex8 _868 = _AFeeder_DB_0_ibuffer[_859][_864][_867][_AFeeder_s0_buf];
                _AFeeder_channel_array.s[_AFeeder_s0_buf] = _868;
                (void)_AFeeder_s0_buf;
            } // if _851
        }     // for _AFeeder_s0_buf
        uint _869 = (uint)(ADD_UINT64_T_SUFFIX(0));
        uint _871 = _AFeeder_time_stamp_shreg;
        uint _872 = (uint)(ADD_UINT64_T_SUFFIX(14));
        uint _873 = _871 >> _872;
        bool _874 = _869 < _873;
        if (_874)
        {
            write_channel_intel(_AFeeder_channel, _AFeeder_channel_array);
            (void)_AFeeder_channel_array;
        } // if _874
        uint _875 = _AFeeder_cycle_temp;
        uint _876 = (uint)(ADD_UINT64_T_SUFFIX(1));
        uint _877 = _875 + _876;
        _AFeeder_cycle_temp = _877;
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
    int _879 = _A_extent_1 >> 7;
    int _880 = _879 + 1;
    for (int _BLoader_s0_i = 0; _BLoader_s0_i < 0 + _880; _BLoader_s0_i++)
    {
        int _881 = _B_extent_0 >> 7;
        int _882 = _881 - _BLoader_s0_i + ((_BLoader_s0_i < _879) ? 0 : 1);
        for (int _BLoader_s0_j = _BLoader_s0_i; _BLoader_s0_j < _BLoader_s0_i + _882; _BLoader_s0_j++)
        {
            int _883 = _A_extent_0 >> 7;
            for (int _BLoader_s0_k = 0; _BLoader_s0_k < 0 + _883; _BLoader_s0_k++)
            {
#pragma loop_coalesce 3
                for (int _BLoader_s0_kk = 0; _BLoader_s0_kk < 0 + 16; _BLoader_s0_kk++)
                {
                    for (int _BLoader_s0_jj = 0; _BLoader_s0_jj < 0 + 32; _BLoader_s0_jj++)
                    {
                        for (int _BLoader_s0_jjj = 0; _BLoader_s0_jjj < 0 + 4; _BLoader_s0_jjj++)
                        {
                            bool _884 = _BLoader_s0_j == _BLoader_s0_i;
                            bool _885 = _BLoader_s0_k == 0;
                            bool _886 = _884 && _885;
                            int _897 = _A_extent_1 >> 7;
                            bool _898 = _BLoader_s0_i < _897;
                            bool _899 = _886 || _898;
                            if (_899)
                            {
                                complex8 _900;
                                int _901 = _A_extent_1 >> 7;
                                bool _902 = _BLoader_s0_i < _901;
                                if (_902)
                                {
                                    int _18 = _BLoader_s0_jjj * 8 + _BLoader_s0_jj * 32 + _BLoader_s0_kk * 1024;
                                    int _19 = _18 + _BLoader_s0_k * 16384;
                                    int _20 = _19 + _BLoader_s0_j * 16384 * _883;
                                    complex8 _911 = {vload16(0, (__address_space__BSerializer_mem_channel float *)(_BSerializer_mem_channel + _20))};
                                    _900 = _911;
                                } // if _902
                                else
                                {
                                    float _34 = float_from_bits(0 /* 0 */);
                                    _900.t = _34;
                                } // if _902 else
                                complex8 _914 = _900;
                                write_channel_intel(_BLoader_channel, _914);
                                (void)_914;
                            } // if _899
                        }     // for _BLoader_s0_jjj
                    }         // for _BLoader_s0_jj
                }             // for _BLoader_s0_kk
            }                 // for _BLoader_s0_k
        }                     // for _BLoader_s0_j
    }                         // for _BLoader_s0_i
} // kernel kernel_BLoader_1
#undef __address_space__BSerializer_mem_channel
// Address spaces for kernel_BFeeder_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void
kernel_BFeeder_1()
{
    _BFeeder_channel_array_t _BFeeder_channel_array;
    complex8 _BFeeder_value_shreg;
    uint _BFeeder_time_stamp_shreg;
    complex8 _BFeeder_in_v_temp;
    uint _BFeeder_cycle_temp;
    complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _BFeeder_DB_0_ibuffer[2][16][32][4];
#pragma unroll
    for (int _BFeeder_s0_iii_init = 0; _BFeeder_s0_iii_init < 0 + 4; _BFeeder_s0_iii_init++)
    {
        bool _917 = _BFeeder_s0_iii_init == 0;
        if (_917)
        {
            uint _918 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            _BFeeder_cycle_temp = _918;
        } // if _917
    }     // for _BFeeder_s0_iii_init
    while (1)
    {
        uint _919 = (uint)(ADD_UINT64_T_SUFFIX(14336));
        uint _920 = _BFeeder_cycle_temp;
        uint _921 = (uint)(ADD_UINT64_T_SUFFIX(16383));
        uint _922 = _920 & _921;
        bool _923 = _919 <= _922;
        if (_923)
        {
            complex8 __924 = read_channel_intel(_BLoader_channel);
            _BFeeder_in_v_temp = __924;
        } // if _923
#pragma unroll
        for (int _BFeeder_s0_buf = 0; _BFeeder_s0_buf < 0 + 4; _BFeeder_s0_buf++)
        {
            bool _925 = _BFeeder_s0_buf == 0;
            if (_925)
            {
                complex8 _926 = _BFeeder_in_v_temp;
                _BFeeder_value_shreg = _926;
                (void)_926;
                uint _927 = _BFeeder_cycle_temp;
                _BFeeder_time_stamp_shreg = _927;
                (void)_927;
            } // if _925
            else
            {
                complex8 _929 = _BFeeder_value_shreg;
                _BFeeder_value_shreg = _929;
                (void)_929;
                uint _931 = _BFeeder_time_stamp_shreg;
                _BFeeder_time_stamp_shreg = _931;
                (void)_931;
            } // if _925 else
            complex8 _933 = _BFeeder_value_shreg;
            complex8 _934 = __fpga_reg(__fpga_reg(_933));
            _BFeeder_value_shreg = _934;
            (void)_934;
            uint _936 = _BFeeder_time_stamp_shreg;
            uint _937 = __fpga_reg(__fpga_reg(_936));
            _BFeeder_time_stamp_shreg = _937;
            (void)_937;
            uint _938 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            uint _940 = _BFeeder_time_stamp_shreg;
            uint _941 = (uint)(ADD_UINT64_T_SUFFIX(16383));
            uint _942 = _940 & _941;
            bool _943 = _938 <= _942;
            if (_943)
            {
                uint _945 = _BFeeder_time_stamp_shreg;
                uint _946 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _947 = _945 & _946;
                uint _948 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                uint _949 = _947 - _948;
                uint _950 = (uint)(ADD_UINT64_T_SUFFIX(3));
                uint _951 = _949 & _950;
                int _952 = (int)(_951);
                bool _953 = _BFeeder_s0_buf == _952;
                if (_953)
                {
                    complex8 _955 = _BFeeder_value_shreg;
                    uint _957 = _BFeeder_time_stamp_shreg;
                    uint _958 = (uint)(ADD_UINT64_T_SUFFIX(14));
                    uint _959 = _957 >> _958;
                    uint _960 = (uint)(ADD_UINT64_T_SUFFIX(1));
                    uint _961 = _959 & _960;
                    bool _962 = (bool)(_961);
                    uint _964 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                    uint _965 = _957 & _964;
                    uint _966 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                    uint _967 = _965 - _966;
                    int _968 = (int)(_967);
                    int _969 = _968 >> 7;
                    int _971 = _968 >> 2;
                    int _972 = _971 & 31;
                    _BFeeder_DB_0_ibuffer[_962][_969][_972][_BFeeder_s0_buf] = _955;
                } // if _953
            }     // if _943
            uint _973 = (uint)(ADD_UINT64_T_SUFFIX(0));
            uint _975 = _BFeeder_time_stamp_shreg;
            uint _976 = (uint)(ADD_UINT64_T_SUFFIX(14));
            uint _977 = _975 >> _976;
            bool _978 = _973 < _977;
            if (_978)
            {
                uint _980 = _BFeeder_time_stamp_shreg;
                uint _981 = (uint)(ADD_UINT64_T_SUFFIX(14));
                uint _982 = _980 >> _981;
                uint _983 = (uint)(ADD_UINT64_T_SUFFIX(1));
                uint _984 = _982 & _983;
                bool _985 = (bool)(_984);
                bool _986 = !(_985);
                uint _988 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _989 = _980 & _988;
                int _990 = (int)(_989);
                int _991 = _990 >> 10;
                int _993 = _990 & 31;
                complex8 _994 = _BFeeder_DB_0_ibuffer[_986][_991][_993][_BFeeder_s0_buf];
                _BFeeder_channel_array.s[_BFeeder_s0_buf] = _994;
                (void)_BFeeder_s0_buf;
            } // if _978
        }     // for _BFeeder_s0_buf
        uint _995 = (uint)(ADD_UINT64_T_SUFFIX(0));
        uint _997 = _BFeeder_time_stamp_shreg;
        uint _998 = (uint)(ADD_UINT64_T_SUFFIX(14));
        uint _999 = _997 >> _998;
        bool _1000 = _995 < _999;
        if (_1000)
        {
            write_channel_intel(_BFeeder_channel, _BFeeder_channel_array);
            (void)_BFeeder_channel_array;
        } // if _1000
        uint _1001 = _BFeeder_cycle_temp;
        uint _1002 = (uint)(ADD_UINT64_T_SUFFIX(1));
        uint _1003 = _1001 + _1002;
        _BFeeder_cycle_temp = _1003;
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
    complex _Z_shreg[1024][4][4];
    complex _Z_pipe_shreg[4][3073];
    // produce Y
    complex8 _Y_shreg[4];
    complex _Z_temp[4][4];
    // produce X
    complex8 _X_shreg[4];
    complex _Z_shreg_temp;
    int _Z_pipe_iter_temp;
    int _Z_pipe_base_temp;
    _Z_pipe_iter_temp = 4096;
    _Z_pipe_base_temp = 0;
    int _244 = _A_extent_1 >> 7;
    int _246 = _B_extent_0 >> 7;
    int _243 = (2 * _246 - _244 + 1) * _244 / 2;
    int _245 = _243 + 1;
    for (int _X_s0_i_j = 0; _X_s0_i_j < 0 + _245; _X_s0_i_j++)
    {
        int _1009 = _A_extent_0 >> 7;
        for (int _X_s0_k = 0; _X_s0_k < 0 + _1009; _X_s0_k++)
        {
            for (int _X_s0_kk_ii_jj = 0; _X_s0_kk_ii_jj < 0 + 16384; _X_s0_kk_ii_jj++)
            {
#pragma unroll
                for (int _dummy__1_s0_iii = 0; _dummy__1_s0_iii < 0 + 4; _dummy__1_s0_iii++)
                {
#pragma unroll
                    for (int _dummy_s0_jjj = 0; _dummy_s0_jjj < 0 + 4; _dummy_s0_jjj++)
                    {
                        complex _1011 = _Z_shreg[1023][_dummy_s0_jjj][_dummy__1_s0_iii];
                        _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii] = _1011;
#pragma unroll
                        for (int _dummy__2_s0_l1 = 0; _dummy__2_s0_l1 < 0 + 1023; _dummy__2_s0_l1++)
                        {
                            int _1012 = 1023 - _dummy__2_s0_l1;
                            int _1013 = 1022 - _dummy__2_s0_l1;
                            complex _1015 = _Z_shreg[_1013][_dummy_s0_jjj][_dummy__1_s0_iii];
                            _Z_shreg[_1012][_dummy_s0_jjj][_dummy__1_s0_iii] = _1015;
                            (void)_1015;
                        } // for _dummy__2_s0_l1
                        complex _1016 = _Z_temp[_dummy_s0_jjj][_dummy__1_s0_iii];
                        _Z_shreg[0][_dummy_s0_jjj][_dummy__1_s0_iii] = _1016;
                        (void)_1016;
                    } // for _dummy_s0_jjj
                }     // for _dummy__1_s0_iii
                bool _1018 = _X_s0_i_j < _243;
                if (_1018)
                {
                    _BFeeder_channel_array_t __1019 = read_channel_intel(_BFeeder_channel);
                    _BFeeder_channel_array = __1019;
                    (void)__1019;
                    _AFeeder_channel_array_t __1020 = read_channel_intel(_AFeeder_channel);
                    _AFeeder_channel_array = __1020;
                    (void)__1020;
                } // if _1018
#pragma unroll
                for (int _X_s0_iii = 0; _X_s0_iii < 0 + 4; _X_s0_iii++)
                {
#pragma unroll
                    for (int _X_s0_jjj = 0; _X_s0_jjj < 0 + 4; _X_s0_jjj++)
                    {
                        complex8 _1021;
                        bool _1022 = _X_s0_jjj == 0;
                        if (_1022)
                        {
                            complex8 __1023 = _AFeeder_channel_array.s[_X_s0_iii];
                            _1021 = __1023;
                        } // if _1022
                        else
                        {
                            complex8 _1025 = _X_shreg[_X_s0_iii];
                            _1021 = _1025;
                        } // if _1022 else
                        complex8 _1026 = _1021;
                        _X_shreg[_X_s0_iii] = _1026;
                        (void)_1026;
                        complex8 _1028 = _X_shreg[_X_s0_iii];
                        complex8 _1029 = __fpga_reg(__fpga_reg(_1028));
                        _X_shreg[_X_s0_iii] = _1029;
                        (void)_1029;
                        complex8 _1030;
                        bool _1031 = _X_s0_iii == 0;
                        if (_1031)
                        {
                            complex8 __1032 = _BFeeder_channel_array.s[_X_s0_jjj];
                            _1030 = __1032;
                        } // if _1031
                        else
                        {
                            complex8 _1034 = _Y_shreg[_X_s0_jjj];
                            _1030 = _1034;
                        } // if _1031 else
                        complex8 _1035 = _1030;
                        _Y_shreg[_X_s0_jjj] = _1035;
                        (void)_1035;
                        complex8 _1037 = _Y_shreg[_X_s0_jjj];
                        complex8 _1038 = __fpga_reg(__fpga_reg(_1037));
                        _Y_shreg[_X_s0_jjj] = _1038;
                        (void)_1038;
                        complex _1039;
                        bool _1040 = _X_s0_k == 0;
                        int _1041 = _X_s0_kk_ii_jj >> 10;
                        bool _1042 = _1041 == 0;
                        bool _1043 = _1040 && _1042;
                        if (_1043)
                        {
                            complex _1044 = (complex)(0.000000f, 0.000000f);
                            _1039 = _1044;
                        } // if _1043
                        else
                        {
                            complex _1046 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
                            complex _1047 = __fpga_reg(_1046);
                            _1039 = _1047;
                        } // if _1043 else
                        complex _1048 = _1039;
                        _Z_shreg_temp = _1048;
#pragma unroll
                        for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
                        {
                            complex _1049 = _Z_shreg_temp;
                            complex _1051 = _X_shreg[_X_s0_iii].s[_X_s0_kkk];
                            complex _1053 = _Y_shreg[_X_s0_jjj].s[_X_s0_kkk];
                            complex _1054 = (float2)(_1051.s0 * _1053.s0 - _1051.s1 * _1053.s1, _1051.s0 * _1053.s1 + _1051.s1 * _1053.s0);
                            complex _1055 = _1049 + _1054;
                            _Z_shreg_temp = _1055;
                            int _1056 = _X_s0_kkk & 3;
                            bool _1057 = _1056 == 3;
                            if (_1057)
                            {
                                complex _1058 = _Z_shreg_temp;
                                complex _1059 = __fpga_reg(_1058);
                                _Z_shreg_temp = _1059;
                            } // if _1057
                        }     // for _X_s0_kkk
                        complex _1060 = _Z_shreg_temp;
                        _Z_shreg[0][_X_s0_jjj][_X_s0_iii] = _1060;
                        (void)_1060;
#pragma unroll
                        for (int _X_s0_kkk = 0; _X_s0_kkk < 0 + 8; _X_s0_kkk++)
                        {
                            bool _1061 = _X_s0_kkk == 7;
                            int _1062 = _X_s0_kk_ii_jj >> 10;
                            bool _1063 = _1062 == 15;
                            bool _1064 = _1061 && _1063;
                            int _1065 = _A_extent_0 >> 7;
                            int _1066 = _1065 + -1;
                            bool _1067 = _X_s0_k == _1066;
                            bool _1068 = _1064 && _1067;
                            if (_1068)
                            {
                                int _1069 = _X_s0_iii * 1024;
                                complex _1071 = _Z_shreg[0][_X_s0_jjj][_X_s0_iii];
                                _Z_pipe_shreg[_X_s0_jjj][_1069] = _1071;
                                (void)_1071;
                            } // if _1068
                        }     // for _X_s0_kkk
                    }         // for _X_s0_jjj
                }             // for _X_s0_iii
                int _1072 = _X_s0_kk_ii_jj & 31;
                bool _1073 = _1072 == 0;
                int _1074 = _X_s0_kk_ii_jj & 1023;
                int _1075 = _1074 >> 5;
                bool _1076 = _1075 == 0;
                bool _1077 = _1073 && _1076;
                int _1078 = _A_extent_0 >> 7;
                int _1079 = _1078 + -1;
                bool _1080 = _X_s0_k == _1079;
                bool _1081 = _1077 && _1080;
                int _1082 = _X_s0_kk_ii_jj >> 10;
                bool _1083 = _1082 == 15;
                bool _1084 = _1081 && _1083;
                bool _1086 = _X_s0_i_j < _243;
                bool _1087 = _1084 && _1086;
                if (_1087)
                {
                    int _1088 = _Z_pipe_iter_temp;
                    _Z_pipe_base_temp = _1088;
                } // if _1087
                complex4 _Out_channel_temp;
#pragma unroll
                for (int _Z_pipe_b__62 = 0; _Z_pipe_b__62 < 0 + 4; _Z_pipe_b__62++)
                {
                    complex _1090 = _Z_pipe_shreg[_Z_pipe_b__62][0];
                    _Out_channel_temp.s[_Z_pipe_b__62] = _1090;
#pragma unroll
                    for (int _Z_pipe_b__62_dummy = 0; _Z_pipe_b__62_dummy < 0 + 4; _Z_pipe_b__62_dummy++)
                    {
                        complex _1091 = _Out_channel_temp.s[_Z_pipe_b__62_dummy];
                        complex _1092 = __fpga_reg(__fpga_reg(_1091));
                        _Out_channel_temp.s[_Z_pipe_b__62_dummy] = _1092;
                    } // for _Z_pipe_b__62_dummy
                }     // for _Z_pipe_b__62
                int _1093 = _Z_pipe_iter_temp;
                int _1094 = _Z_pipe_base_temp;
                int _1095 = _1094 + 4096;
                bool _1096 = _1093 < _1095;
                if (_1096)
                {
                    complex4 _1097 = _Out_channel_temp;
                    write_channel_intel(_Out_channel, _1097);
                    (void)_1097;
                } // if _1096
#pragma unroll
                for (int _Z_pipe_b__63 = 0; _Z_pipe_b__63 < 0 + 4; _Z_pipe_b__63++)
                {
#pragma unroll
                    for (int _Z_pipe_p__31 = 0; _Z_pipe_p__31 < 0 + 3; _Z_pipe_p__31++)
                    {
#pragma unroll
                        for (int _Z_pipe_l__31 = 0; _Z_pipe_l__31 < 0 + 1023; _Z_pipe_l__31++)
                        {
                            int _1098 = _Z_pipe_p__31 * 1024;
                            int _1099 = _1098 + _Z_pipe_l__31;
                            int _1100 = _1099 + 1;
                            complex _1102 = _Z_pipe_shreg[_Z_pipe_b__63][_1100];
                            _Z_pipe_shreg[_Z_pipe_b__63][_1099] = _1102;
                            (void)_1102;
                        } // for _Z_pipe_l__31
                        int _1103 = _Z_pipe_p__31 * 1024;
                        int _1104 = _1103 + 1023;
                        int _1105 = _1103 + 1024;
                        complex _1107 = _Z_pipe_shreg[_Z_pipe_b__63][_1105];
                        complex _1108 = __fpga_reg(__fpga_reg(_1107));
                        _Z_pipe_shreg[_Z_pipe_b__63][_1104] = _1108;
                        (void)_1108;
                    } // for _Z_pipe_p__31
                }     // for _Z_pipe_b__63
                int _1109 = _Z_pipe_iter_temp;
                int _1110 = _1109 + 1;
                _Z_pipe_iter_temp = _1110;
            } // for _X_s0_kk_ii_jj
        }     // for _X_s0_k
    }         // for _X_s0_i_j
} // kernel kernel_Out_1
// Address spaces for kernel_ALoader_T_1
#define __address_space__ASerializer_T_mem_channel __global
__kernel void kernel_ALoader_T_1(
    const int _A_extent_0,
    const int _A_extent_1,
    const int _B_extent_0,
    __address_space__ASerializer_T_mem_channel const complex *restrict _ASerializer_T_mem_channel)
{
    int _1112 = _B_extent_0 >> 7;
    int _1113 = _1112 + 1;
    for (int _ALoader_T_s0_j = 0; _ALoader_T_s0_j < 0 + _1113; _ALoader_T_s0_j++)
    {
        int _1114 = _A_extent_1 >> 7;
        int _1115 = _1114 - _ALoader_T_s0_j + ((_ALoader_T_s0_j < _1112) ? 0 : 1);
        for (int _ALoader_T_s0_i = _ALoader_T_s0_j; _ALoader_T_s0_i < _ALoader_T_s0_j + _1115; _ALoader_T_s0_i++)
        {
            int _1116 = _A_extent_0 >> 7;
            for (int _ALoader_T_s0_k = 0; _ALoader_T_s0_k < 0 + _1116; _ALoader_T_s0_k++)
            {
#pragma loop_coalesce 3
                for (int _ALoader_T_s0_kk = 0; _ALoader_T_s0_kk < 0 + 16; _ALoader_T_s0_kk++)
                {
                    for (int _ALoader_T_s0_ii = 0; _ALoader_T_s0_ii < 0 + 32; _ALoader_T_s0_ii++)
                    {
                        for (int _ALoader_T_s0_iii = 0; _ALoader_T_s0_iii < 0 + 4; _ALoader_T_s0_iii++)
                        {
                            bool _1117 = _ALoader_T_s0_i == _ALoader_T_s0_j;
                            bool _1118 = _ALoader_T_s0_k == 0;
                            bool _1119 = _1117 && _1118;
                            int _1130 = _B_extent_0 >> 7;
                            bool _1131 = _ALoader_T_s0_j < _1130;
                            bool _1132 = _1119 || _1131;
                            if (_1132)
                            {
                                complex8 _1133;
                                int _1134 = _B_extent_0 >> 7;
                                bool _1135 = _ALoader_T_s0_j < _1134;
                                if (_1135)
                                {
                                    int _18 = _ALoader_T_s0_iii * 8 + _ALoader_T_s0_ii * 32 + _ALoader_T_s0_kk * 1024;
                                    int _19 = _18 + _ALoader_T_s0_k * 16384;
                                    int _20 = _19 + _ALoader_T_s0_i * 16384 * _1116;
                                    complex8 _1144 = {vload16(0, (__address_space__ASerializer_T_mem_channel float *)(_ASerializer_T_mem_channel + _20))};
                                    _1133 = _1144;
                                } // if _1135
                                else
                                {
                                    float _373 = float_from_bits(0 /* 0 */);
                                    _1133.t = _373;
                                } // if _1135 else
                                complex8 _1147 = _1133;
                                write_channel_intel(_ALoader_T_channel, _1147);
                                (void)_1147;
                            } // if _1132
                        }     // for _ALoader_T_s0_iii
                    }         // for _ALoader_T_s0_ii
                }             // for _ALoader_T_s0_kk
            }                 // for _ALoader_T_s0_k
        }                     // for _ALoader_T_s0_i
    }                         // for _ALoader_T_s0_j
} // kernel kernel_ALoader_T_1
#undef __address_space__ASerializer_T_mem_channel
// Address spaces for kernel_AFeeder_T_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void
kernel_AFeeder_T_1()
{
    _AFeeder_T_channel_array_t _AFeeder_T_channel_array;
    complex8 _AFeeder_T_value_shreg;
    uint _AFeeder_T_time_stamp_shreg;
    complex8 _AFeeder_T_in_v_temp;
    uint _AFeeder_T_cycle_temp;
    complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _AFeeder_T_DB_0_ibuffer[2][16][32][4];
#pragma unroll
    for (int _AFeeder_T_s0_jjj_init = 0; _AFeeder_T_s0_jjj_init < 0 + 4; _AFeeder_T_s0_jjj_init++)
    {
        bool _1150 = _AFeeder_T_s0_jjj_init == 0;
        if (_1150)
        {
            uint _1151 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            _AFeeder_T_cycle_temp = _1151;
        } // if _1150
    }     // for _AFeeder_T_s0_jjj_init
    while (1)
    {
        uint _1152 = (uint)(ADD_UINT64_T_SUFFIX(14336));
        uint _1153 = _AFeeder_T_cycle_temp;
        uint _1154 = (uint)(ADD_UINT64_T_SUFFIX(16383));
        uint _1155 = _1153 & _1154;
        bool _1156 = _1152 <= _1155;
        if (_1156)
        {
            complex8 __1157 = read_channel_intel(_ALoader_T_channel);
            _AFeeder_T_in_v_temp = __1157;
        } // if _1156
#pragma unroll
        for (int _AFeeder_T_s0_buf = 0; _AFeeder_T_s0_buf < 0 + 4; _AFeeder_T_s0_buf++)
        {
            bool _1158 = _AFeeder_T_s0_buf == 0;
            if (_1158)
            {
                complex8 _1159 = _AFeeder_T_in_v_temp;
                _AFeeder_T_value_shreg = _1159;
                (void)_1159;
                uint _1160 = _AFeeder_T_cycle_temp;
                _AFeeder_T_time_stamp_shreg = _1160;
                (void)_1160;
            } // if _1158
            else
            {
                complex8 _1162 = _AFeeder_T_value_shreg;
                _AFeeder_T_value_shreg = _1162;
                (void)_1162;
                uint _1164 = _AFeeder_T_time_stamp_shreg;
                _AFeeder_T_time_stamp_shreg = _1164;
                (void)_1164;
            } // if _1158 else
            complex8 _1166 = _AFeeder_T_value_shreg;
            complex8 _1167 = __fpga_reg(__fpga_reg(_1166));
            _AFeeder_T_value_shreg = _1167;
            (void)_1167;
            uint _1169 = _AFeeder_T_time_stamp_shreg;
            uint _1170 = __fpga_reg(__fpga_reg(_1169));
            _AFeeder_T_time_stamp_shreg = _1170;
            (void)_1170;
            uint _1171 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            uint _1173 = _AFeeder_T_time_stamp_shreg;
            uint _1174 = (uint)(ADD_UINT64_T_SUFFIX(16383));
            uint _1175 = _1173 & _1174;
            bool _1176 = _1171 <= _1175;
            if (_1176)
            {
                uint _1178 = _AFeeder_T_time_stamp_shreg;
                uint _1179 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _1180 = _1178 & _1179;
                uint _1181 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                uint _1182 = _1180 - _1181;
                uint _1183 = (uint)(ADD_UINT64_T_SUFFIX(3));
                uint _1184 = _1182 & _1183;
                int _1185 = (int)(_1184);
                bool _1186 = _AFeeder_T_s0_buf == _1185;
                if (_1186)
                {
                    complex8 _1188 = _AFeeder_T_value_shreg;
                    uint _1190 = _AFeeder_T_time_stamp_shreg;
                    uint _1191 = (uint)(ADD_UINT64_T_SUFFIX(14));
                    uint _1192 = _1190 >> _1191;
                    uint _1193 = (uint)(ADD_UINT64_T_SUFFIX(1));
                    uint _1194 = _1192 & _1193;
                    bool _1195 = (bool)(_1194);
                    uint _1197 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                    uint _1198 = _1190 & _1197;
                    uint _1199 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                    uint _1200 = _1198 - _1199;
                    int _1201 = (int)(_1200);
                    int _1202 = _1201 >> 7;
                    int _1204 = _1201 >> 2;
                    int _1205 = _1204 & 31;
                    _AFeeder_T_DB_0_ibuffer[_1195][_1202][_1205][_AFeeder_T_s0_buf] = _1188;
                } // if _1186
            }     // if _1176
            uint _1206 = (uint)(ADD_UINT64_T_SUFFIX(0));
            uint _1208 = _AFeeder_T_time_stamp_shreg;
            uint _1209 = (uint)(ADD_UINT64_T_SUFFIX(14));
            uint _1210 = _1208 >> _1209;
            bool _1211 = _1206 < _1210;
            if (_1211)
            {
                uint _1213 = _AFeeder_T_time_stamp_shreg;
                uint _1214 = (uint)(ADD_UINT64_T_SUFFIX(14));
                uint _1215 = _1213 >> _1214;
                uint _1216 = (uint)(ADD_UINT64_T_SUFFIX(1));
                uint _1217 = _1215 & _1216;
                bool _1218 = (bool)(_1217);
                bool _1219 = !(_1218);
                uint _1221 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _1222 = _1213 & _1221;
                int _1223 = (int)(_1222);
                int _1224 = _1223 >> 10;
                int _1226 = _1223 & 31;
                complex8 _1227 = _AFeeder_T_DB_0_ibuffer[_1219][_1224][_1226][_AFeeder_T_s0_buf];
                _AFeeder_T_channel_array.s[_AFeeder_T_s0_buf] = _1227;
                (void)_AFeeder_T_s0_buf;
            } // if _1211
        }     // for _AFeeder_T_s0_buf
        uint _1228 = (uint)(ADD_UINT64_T_SUFFIX(0));
        uint _1230 = _AFeeder_T_time_stamp_shreg;
        uint _1231 = (uint)(ADD_UINT64_T_SUFFIX(14));
        uint _1232 = _1230 >> _1231;
        bool _1233 = _1228 < _1232;
        if (_1233)
        {
            write_channel_intel(_AFeeder_T_channel, _AFeeder_T_channel_array);
            (void)_AFeeder_T_channel_array;
        } // if _1233
        uint _1234 = _AFeeder_T_cycle_temp;
        uint _1235 = (uint)(ADD_UINT64_T_SUFFIX(1));
        uint _1236 = _1234 + _1235;
        _AFeeder_T_cycle_temp = _1236;
    } // while _AFeeder_T_s0_outermost_loop_infinite
} // kernel kernel_AFeeder_T_1
// Address spaces for kernel_BLoader_T_1
#define __address_space__BSerializer_T_mem_channel __global
__kernel void kernel_BLoader_T_1(
    const int _A_extent_0,
    const int _A_extent_1,
    const int _B_extent_0,
    __address_space__BSerializer_T_mem_channel const complex *restrict _BSerializer_T_mem_channel)
{
    int _1238 = _B_extent_0 >> 7;
    int _1239 = _1238 + 1;
    for (int _BLoader_T_s0_j = 0; _BLoader_T_s0_j < 0 + _1239; _BLoader_T_s0_j++)
    {
        int _1240 = _A_extent_1 >> 7;
        int _1241 = _1240 - _BLoader_T_s0_j + ((_BLoader_T_s0_j < _1238) ? 0 : 1);
        for (int _BLoader_T_s0_i = _BLoader_T_s0_j; _BLoader_T_s0_i < _BLoader_T_s0_j + _1241; _BLoader_T_s0_i++)
        {
            int _1242 = _A_extent_0 >> 7;
            for (int _BLoader_T_s0_k = 0; _BLoader_T_s0_k < 0 + _1242; _BLoader_T_s0_k++)
            {
#pragma loop_coalesce 3
                for (int _BLoader_T_s0_kk = 0; _BLoader_T_s0_kk < 0 + 16; _BLoader_T_s0_kk++)
                {
                    for (int _BLoader_T_s0_jj = 0; _BLoader_T_s0_jj < 0 + 32; _BLoader_T_s0_jj++)
                    {
                        for (int _BLoader_T_s0_jjj = 0; _BLoader_T_s0_jjj < 0 + 4; _BLoader_T_s0_jjj++)
                        {
                            bool _1243 = _BLoader_T_s0_i == _BLoader_T_s0_j;
                            bool _1244 = _BLoader_T_s0_k == 0;
                            bool _1245 = _1243 && _1244;
                            int _1256 = _B_extent_0 >> 7;
                            bool _1257 = _BLoader_T_s0_j < _1256;
                            bool _1258 = _1245 || _1257;
                            if (_1258)
                            {
                                complex8 _1259;
                                int _1260 = _B_extent_0 >> 7;
                                bool _1261 = _BLoader_T_s0_j < _1260;
                                if (_1261)
                                {
                                    int _18 = _BLoader_T_s0_jjj * 8 + _BLoader_T_s0_jj * 32 + _BLoader_T_s0_kk * 1024;
                                    int _19 = _18 + _BLoader_T_s0_k * 16384;
                                    int _20 = _19 + _BLoader_T_s0_j * 16384 * _1242;
                                    complex8 _1275 = {vload16(0, (__address_space__BSerializer_T_mem_channel float *)(_BSerializer_T_mem_channel + _20))};
                                    _1259 = _1275;
                                } // if _1261
                                else
                                {
                                    float _498 = float_from_bits(0 /* 0 */);
                                    _1259.t = _498;
                                } // if _1261 else
                                complex8 _1278 = _1259;
                                write_channel_intel(_BLoader_T_channel, _1278);
                                (void)_1278;
                            } // if _1258
                        }     // for _BLoader_T_s0_jjj
                    }         // for _BLoader_T_s0_jj
                }             // for _BLoader_T_s0_kk
            }                 // for _BLoader_T_s0_k
        }                     // for _BLoader_T_s0_i
    }                         // for _BLoader_T_s0_j
} // kernel kernel_BLoader_T_1
#undef __address_space__BSerializer_T_mem_channel
// Address spaces for kernel_BFeeder_T_1
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel void
kernel_BFeeder_T_1()
{
    _BFeeder_T_channel_array_t _BFeeder_T_channel_array;
    complex8 _BFeeder_T_value_shreg;
    uint _BFeeder_T_time_stamp_shreg;
    complex8 _BFeeder_T_in_v_temp;
    uint _BFeeder_T_cycle_temp;
    complex8 __attribute__((memory, numbanks(4), singlepump, numwriteports(1), numreadports(1))) _BFeeder_T_DB_0_ibuffer[2][16][32][4];
#pragma unroll
    for (int _BFeeder_T_s0_iii_init = 0; _BFeeder_T_s0_iii_init < 0 + 4; _BFeeder_T_s0_iii_init++)
    {
        bool _1281 = _BFeeder_T_s0_iii_init == 0;
        if (_1281)
        {
            uint _1282 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            _BFeeder_T_cycle_temp = _1282;
        } // if _1281
    }     // for _BFeeder_T_s0_iii_init
    while (1)
    {
        uint _1283 = (uint)(ADD_UINT64_T_SUFFIX(14336));
        uint _1284 = _BFeeder_T_cycle_temp;
        uint _1285 = (uint)(ADD_UINT64_T_SUFFIX(16383));
        uint _1286 = _1284 & _1285;
        bool _1287 = _1283 <= _1286;
        if (_1287)
        {
            complex8 __1288 = read_channel_intel(_BLoader_T_channel);
            _BFeeder_T_in_v_temp = __1288;
        } // if _1287
#pragma unroll
        for (int _BFeeder_T_s0_buf = 0; _BFeeder_T_s0_buf < 0 + 4; _BFeeder_T_s0_buf++)
        {
            bool _1289 = _BFeeder_T_s0_buf == 0;
            if (_1289)
            {
                complex8 _1290 = _BFeeder_T_in_v_temp;
                _BFeeder_T_value_shreg = _1290;
                (void)_1290;
                uint _1291 = _BFeeder_T_cycle_temp;
                _BFeeder_T_time_stamp_shreg = _1291;
                (void)_1291;
            } // if _1289
            else
            {
                complex8 _1293 = _BFeeder_T_value_shreg;
                _BFeeder_T_value_shreg = _1293;
                (void)_1293;
                uint _1295 = _BFeeder_T_time_stamp_shreg;
                _BFeeder_T_time_stamp_shreg = _1295;
                (void)_1295;
            } // if _1289 else
            complex8 _1297 = _BFeeder_T_value_shreg;
            complex8 _1298 = __fpga_reg(__fpga_reg(_1297));
            _BFeeder_T_value_shreg = _1298;
            (void)_1298;
            uint _1300 = _BFeeder_T_time_stamp_shreg;
            uint _1301 = __fpga_reg(__fpga_reg(_1300));
            _BFeeder_T_time_stamp_shreg = _1301;
            (void)_1301;
            uint _1302 = (uint)(ADD_UINT64_T_SUFFIX(14336));
            uint _1304 = _BFeeder_T_time_stamp_shreg;
            uint _1305 = (uint)(ADD_UINT64_T_SUFFIX(16383));
            uint _1306 = _1304 & _1305;
            bool _1307 = _1302 <= _1306;
            if (_1307)
            {
                uint _1309 = _BFeeder_T_time_stamp_shreg;
                uint _1310 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _1311 = _1309 & _1310;
                uint _1312 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                uint _1313 = _1311 - _1312;
                uint _1314 = (uint)(ADD_UINT64_T_SUFFIX(3));
                uint _1315 = _1313 & _1314;
                int _1316 = (int)(_1315);
                bool _1317 = _BFeeder_T_s0_buf == _1316;
                if (_1317)
                {
                    complex8 _1319 = _BFeeder_T_value_shreg;
                    uint _1321 = _BFeeder_T_time_stamp_shreg;
                    uint _1322 = (uint)(ADD_UINT64_T_SUFFIX(14));
                    uint _1323 = _1321 >> _1322;
                    uint _1324 = (uint)(ADD_UINT64_T_SUFFIX(1));
                    uint _1325 = _1323 & _1324;
                    bool _1326 = (bool)(_1325);
                    uint _1328 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                    uint _1329 = _1321 & _1328;
                    uint _1330 = (uint)(ADD_UINT64_T_SUFFIX(14336));
                    uint _1331 = _1329 - _1330;
                    int _1332 = (int)(_1331);
                    int _1333 = _1332 >> 7;
                    int _1335 = _1332 >> 2;
                    int _1336 = _1335 & 31;
                    _BFeeder_T_DB_0_ibuffer[_1326][_1333][_1336][_BFeeder_T_s0_buf] = _1319;
                } // if _1317
            }     // if _1307
            uint _1337 = (uint)(ADD_UINT64_T_SUFFIX(0));
            uint _1339 = _BFeeder_T_time_stamp_shreg;
            uint _1340 = (uint)(ADD_UINT64_T_SUFFIX(14));
            uint _1341 = _1339 >> _1340;
            bool _1342 = _1337 < _1341;
            if (_1342)
            {
                uint _1344 = _BFeeder_T_time_stamp_shreg;
                uint _1345 = (uint)(ADD_UINT64_T_SUFFIX(14));
                uint _1346 = _1344 >> _1345;
                uint _1347 = (uint)(ADD_UINT64_T_SUFFIX(1));
                uint _1348 = _1346 & _1347;
                bool _1349 = (bool)(_1348);
                bool _1350 = !(_1349);
                uint _1352 = (uint)(ADD_UINT64_T_SUFFIX(16383));
                uint _1353 = _1344 & _1352;
                int _1354 = (int)(_1353);
                int _1355 = _1354 >> 10;
                int _1357 = _1354 >> 5;
                int _1358 = _1357 & 31;
                complex8 _1359 = _BFeeder_T_DB_0_ibuffer[_1350][_1355][_1358][_BFeeder_T_s0_buf];
                _BFeeder_T_channel_array.s[_BFeeder_T_s0_buf] = _1359;
                (void)_BFeeder_T_s0_buf;
            } // if _1342
        }     // for _BFeeder_T_s0_buf
        uint _1360 = (uint)(ADD_UINT64_T_SUFFIX(0));
        uint _1362 = _BFeeder_T_time_stamp_shreg;
        uint _1363 = (uint)(ADD_UINT64_T_SUFFIX(14));
        uint _1364 = _1362 >> _1363;
        bool _1365 = _1360 < _1364;
        if (_1365)
        {
            write_channel_intel(_BFeeder_T_channel, _BFeeder_T_channel_array);
            (void)_BFeeder_T_channel_array;
        } // if _1365
        uint _1366 = _BFeeder_T_cycle_temp;
        uint _1367 = (uint)(ADD_UINT64_T_SUFFIX(1));
        uint _1368 = _1366 + _1367;
        _BFeeder_T_cycle_temp = _1368;
    } // while _BFeeder_T_s0_outermost_loop_infinite
} // kernel kernel_BFeeder_T_1
// Address spaces for kernel_Out_T_1
__kernel void kernel_Out_T_1(
    const int _A_extent_0,
    const int _A_extent_1,
    const int _B_extent_0)
{
    _BFeeder_T_channel_array_t _BFeeder_T_channel_array;
    _AFeeder_T_channel_array_t _AFeeder_T_channel_array;
    // produce Z_T
    complex _Z_T_shreg[1024][4][4];
    complex _Z_T_pipe_shreg[4][3073];
    // produce Y_T
    complex8 _Y_T_shreg[4];
    complex _Z_T_temp[4][4];
    complex _Z_temp[4][4];
    // produce X_T
    complex8 _X_T_shreg[4];
    complex _Z_T_shreg_temp;
    int _Z_T_pipe_iter_temp;
    int _Z_T_pipe_base_temp;
    _Z_T_pipe_iter_temp = 4096;
    _Z_T_pipe_base_temp = 0;
    int _588 = _B_extent_0 >> 7;
    int _590 = _A_extent_1 >> 7;
    int _591 = (2 * _588 - _590 + 1) * _590 / 2;
    int _589 = _591 + 1;
    for (int _X_T_s0_j_i = 0; _X_T_s0_j_i < 0 + _589; _X_T_s0_j_i++)
    {
        int _1374 = _A_extent_0 >> 7;
        for (int _X_T_s0_k = 0; _X_T_s0_k < 0 + _1374; _X_T_s0_k++)
        {
            for (int _X_T_s0_kk_jj_ii = 0; _X_T_s0_kk_jj_ii < 0 + 16384; _X_T_s0_kk_jj_ii++)
            {
#pragma unroll
                for (int _dummy__4_s0_jjj = 0; _dummy__4_s0_jjj < 0 + 4; _dummy__4_s0_jjj++)
                {
#pragma unroll
                    for (int _dummy__3_s0_iii = 0; _dummy__3_s0_iii < 0 + 4; _dummy__3_s0_iii++)
                    {
                        complex _1376 = _Z_T_shreg[1023][_dummy__3_s0_iii][_dummy__4_s0_jjj];
                        _Z_T_temp[_dummy__3_s0_iii][_dummy__4_s0_jjj] = _1376;
#pragma unroll
                        for (int _dummy__5_s0_l1 = 0; _dummy__5_s0_l1 < 0 + 1023; _dummy__5_s0_l1++)
                        {
                            int _1377 = 1023 - _dummy__5_s0_l1;
                            int _1378 = 1022 - _dummy__5_s0_l1;
                            complex _1380 = _Z_T_shreg[_1378][_dummy__3_s0_iii][_dummy__4_s0_jjj];
                            _Z_T_shreg[_1377][_dummy__3_s0_iii][_dummy__4_s0_jjj] = _1380;
                            (void)_1380;
                        } // for _dummy__5_s0_l1
                        complex _1381 = _Z_T_temp[_dummy__3_s0_iii][_dummy__4_s0_jjj];
                        _Z_T_shreg[0][_dummy__3_s0_iii][_dummy__4_s0_jjj] = _1381;
                        (void)_1381;
                    } // for _dummy__3_s0_iii
                }     // for _dummy__4_s0_jjj
                bool _1383 = _X_T_s0_j_i < _591;
                if (_1383)
                {
                    _BFeeder_T_channel_array_t __1384 = read_channel_intel(_BFeeder_T_channel);
                    _BFeeder_T_channel_array = __1384;
                    (void)__1384;
                    _AFeeder_T_channel_array_t __1385 = read_channel_intel(_AFeeder_T_channel);
                    _AFeeder_T_channel_array = __1385;
                    (void)__1385;
                } // if _1383
#pragma unroll
                for (int _X_T_s0_jjj = 0; _X_T_s0_jjj < 0 + 4; _X_T_s0_jjj++)
                {
#pragma unroll
                    for (int _X_T_s0_iii = 0; _X_T_s0_iii < 0 + 4; _X_T_s0_iii++)
                    {
                        complex8 _1386;
                        bool _1387 = _X_T_s0_jjj == 0;
                        if (_1387)
                        {
                            complex8 __1388 = _AFeeder_T_channel_array.s[_X_T_s0_iii];
                            _1386 = __1388;
                        } // if _1387
                        else
                        {
                            complex8 _1390 = _X_T_shreg[_X_T_s0_iii];
                            _1386 = _1390;
                        } // if _1387 else
                        complex8 _1391 = _1386;
                        _X_T_shreg[_X_T_s0_iii] = _1391;
                        (void)_1391;
                        complex8 _1393 = _X_T_shreg[_X_T_s0_iii];
                        complex8 _1394 = __fpga_reg(__fpga_reg(_1393));
                        _X_T_shreg[_X_T_s0_iii] = _1394;
                        (void)_1394;
                        complex8 _1395;
                        bool _1396 = _X_T_s0_iii == 0;
                        if (_1396)
                        {
                            complex8 __1397 = _BFeeder_T_channel_array.s[_X_T_s0_jjj];
                            _1395 = __1397;
                        } // if _1396
                        else
                        {
                            complex8 _1399 = _Y_T_shreg[_X_T_s0_jjj];
                            _1395 = _1399;
                        } // if _1396 else
                        complex8 _1400 = _1395;
                        _Y_T_shreg[_X_T_s0_jjj] = _1400;
                        (void)_1400;
                        complex8 _1402 = _Y_T_shreg[_X_T_s0_jjj];
                        complex8 _1403 = __fpga_reg(__fpga_reg(_1402));
                        _Y_T_shreg[_X_T_s0_jjj] = _1403;
                        (void)_1403;
                        complex _1404;
                        bool _1405 = _X_T_s0_k == 0;
                        int _1406 = _X_T_s0_kk_jj_ii >> 10;
                        bool _1407 = _1406 == 0;
                        bool _1408 = _1405 && _1407;
                        if (_1408)
                        {
                            complex _1409 = (complex)(0.000000f, 0.000000f);
                            _1404 = _1409;
                        } // if _1408
                        else
                        {
                            complex _1411 = _Z_T_shreg[0][_X_T_s0_iii][_X_T_s0_jjj];
                            complex _1412 = __fpga_reg(_1411);
                            _1404 = _1412;
                        } // if _1408 else
                        complex _1413 = _1404;
                        _Z_T_shreg_temp = _1413;
#pragma unroll
                        for (int _X_T_s0_kkk = 0; _X_T_s0_kkk < 0 + 8; _X_T_s0_kkk++)
                        {
                            complex _1414 = _Z_T_shreg_temp;
                            complex _1416 = _X_T_shreg[_X_T_s0_iii].s[_X_T_s0_kkk];
                            complex _1418 = _Y_T_shreg[_X_T_s0_jjj].s[_X_T_s0_kkk];
                            complex _1419 = (float2)(_1416.s0 * _1418.s0 - _1416.s1 * _1418.s1, _1416.s0 * _1418.s1 + _1416.s1 * _1418.s0);
                            complex _1420 = _1414 + _1419;
                            _Z_T_shreg_temp = _1420;
                            int _1421 = _X_T_s0_kkk & 3;
                            bool _1422 = _1421 == 3;
                            if (_1422)
                            {
                                complex _1423 = _Z_T_shreg_temp;
                                complex _1424 = __fpga_reg(_1423);
                                _Z_T_shreg_temp = _1424;
                            } // if _1422
                        }     // for _X_T_s0_kkk
                        complex _1425 = _Z_T_shreg_temp;
                        _Z_T_shreg[0][_X_T_s0_iii][_X_T_s0_jjj] = _1425;
                        (void)_1425;
#pragma unroll
                        for (int _X_T_s0_kkk = 0; _X_T_s0_kkk < 0 + 8; _X_T_s0_kkk++)
                        {
                            bool _1426 = _X_T_s0_kkk == 7;
                            int _1427 = _X_T_s0_kk_jj_ii >> 10;
                            bool _1428 = _1427 == 15;
                            bool _1429 = _1426 && _1428;
                            int _1430 = _A_extent_0 >> 7;
                            int _1431 = _1430 + -1;
                            bool _1432 = _X_T_s0_k == _1431;
                            bool _1433 = _1429 && _1432;
                            if (_1433)
                            {
                                int _1434 = _X_T_s0_jjj * 1024;
                                complex _1436 = _Z_T_shreg[0][_X_T_s0_iii][_X_T_s0_jjj];
                                _Z_T_pipe_shreg[_X_T_s0_iii][_1434] = _1436;
                                (void)_1436;
                            } // if _1433
                        }     // for _X_T_s0_kkk
                    }         // for _X_T_s0_iii
                }             // for _X_T_s0_jjj
                int _1437 = _X_T_s0_kk_jj_ii & 31;
                bool _1438 = _1437 == 0;
                int _1439 = _X_T_s0_kk_jj_ii & 1023;
                int _1440 = _1439 >> 5;
                bool _1441 = _1440 == 0;
                bool _1442 = _1438 && _1441;
                int _1443 = _A_extent_0 >> 7;
                int _1444 = _1443 + -1;
                bool _1445 = _X_T_s0_k == _1444;
                bool _1446 = _1442 && _1445;
                int _1447 = _X_T_s0_kk_jj_ii >> 10;
                bool _1448 = _1447 == 15;
                bool _1449 = _1446 && _1448;
                bool _1451 = _X_T_s0_j_i < _591;
                bool _1452 = _1449 && _1451;
                if (_1452)
                {
                    int _1453 = _Z_T_pipe_iter_temp;
                    _Z_T_pipe_base_temp = _1453;
                } // if _1452
                complex4 _Out_T_channel_temp;
#pragma unroll
                for (int _Z_T_pipe_b__62 = 0; _Z_T_pipe_b__62 < 0 + 4; _Z_T_pipe_b__62++)
                {
                    complex _1455 = _Z_T_pipe_shreg[_Z_T_pipe_b__62][0];
                    _Out_T_channel_temp.s[_Z_T_pipe_b__62] = _1455;
#pragma unroll
                    for (int _Z_T_pipe_b__62_dummy = 0; _Z_T_pipe_b__62_dummy < 0 + 4; _Z_T_pipe_b__62_dummy++)
                    {
                        complex _1456 = _Out_T_channel_temp.s[_Z_T_pipe_b__62_dummy];
                        complex _1457 = __fpga_reg(__fpga_reg(_1456));
                        _Out_T_channel_temp.s[_Z_T_pipe_b__62_dummy] = _1457;
                    } // for _Z_T_pipe_b__62_dummy
                }     // for _Z_T_pipe_b__62
                int _1458 = _Z_T_pipe_iter_temp;
                int _1459 = _Z_T_pipe_base_temp;
                int _1460 = _1459 + 4096;
                bool _1461 = _1458 < _1460;
                if (_1461)
                {
                    complex4 _1462 = _Out_T_channel_temp;
                    write_channel_intel(_Out_T_channel, _1462);
                    (void)_1462;
                } // if _1461
#pragma unroll
                for (int _Z_T_pipe_b__63 = 0; _Z_T_pipe_b__63 < 0 + 4; _Z_T_pipe_b__63++)
                {
#pragma unroll
                    for (int _Z_T_pipe_p__31 = 0; _Z_T_pipe_p__31 < 0 + 3; _Z_T_pipe_p__31++)
                    {
#pragma unroll
                        for (int _Z_T_pipe_l__31 = 0; _Z_T_pipe_l__31 < 0 + 1023; _Z_T_pipe_l__31++)
                        {
                            int _1463 = _Z_T_pipe_p__31 * 1024;
                            int _1464 = _1463 + _Z_T_pipe_l__31;
                            int _1465 = _1464 + 1;
                            complex _1467 = _Z_T_pipe_shreg[_Z_T_pipe_b__63][_1465];
                            _Z_T_pipe_shreg[_Z_T_pipe_b__63][_1464] = _1467;
                            (void)_1467;
                        } // for _Z_T_pipe_l__31
                        int _1468 = _Z_T_pipe_p__31 * 1024;
                        int _1469 = _1468 + 1023;
                        int _1470 = _1468 + 1024;
                        complex _1472 = _Z_T_pipe_shreg[_Z_T_pipe_b__63][_1470];
                        complex _1473 = __fpga_reg(__fpga_reg(_1472));
                        _Z_T_pipe_shreg[_Z_T_pipe_b__63][_1469] = _1473;
                        (void)_1473;
                    } // for _Z_T_pipe_p__31
                }     // for _Z_T_pipe_b__63
                int _1474 = _Z_T_pipe_iter_temp;
                int _1475 = _1474 + 1;
                _Z_T_pipe_iter_temp = _1475;
            } // for _X_T_s0_kk_jj_ii
        }     // for _X_T_s0_k
    }         // for _X_T_s0_j_i
} // kernel kernel_Out_T_1
// Address spaces for kernel_E_1
__kernel void kernel_E_1(
    const int _A_extent_1,
    const int _B_extent_0)
{
    int _1477 = _A_extent_1 >> 7;
    for (int _E_s0_i = 0; _E_s0_i < 0 + _1477; _E_s0_i++)
    {
        int _1478 = _B_extent_0 >> 7;
        int _1479 = _1478 - _E_s0_i;
        for (int _E_s0_j = _E_s0_i; _E_s0_j < _E_s0_i + _1479; _E_s0_j++)
        {
#pragma loop_coalesce 3
            for (int _E_s0_iii = 0; _E_s0_iii < 0 + 4; _E_s0_iii++)
            {
                for (int _E_s0_ii = 0; _E_s0_ii < 0 + 32; _E_s0_ii++)
                {
                    for (int _E_s0_jj = 0; _E_s0_jj < 0 + 32; _E_s0_jj++)
                    {
                        complex4 __1480 = read_channel_intel(_Out_channel);
                        complex4 __1481 = read_channel_intel(_Out_T_channel);
                        complex4 _1482 = {__1480.t + __1481.t};
                        write_channel_intel(_E_channel, _1482);
                        (void)_1482;
                    } // for _E_s0_iii
                }     // for _E_s0_jj
            }         // for _E_s0_ii
        }             // for _E_s0_j
    }                 // for _E_s0_i
} // kernel kernel_E_1
// Address spaces for kernel_unloader_1
#define __address_space__unloader_mem_channel __global
__kernel void kernel_unloader_1(
    const int _A_extent_1,
    const int _B_extent_0,
    __address_space__unloader_mem_channel complex *restrict _unloader_mem_channel)
{
    int _addr_temp;
    _addr_temp = 0;
    int _1484 = _A_extent_1 >> 7;
    for (int _unloader_s0_i = 0; _unloader_s0_i < 0 + _1484; _unloader_s0_i++)
    {
        int _1485 = _B_extent_0 >> 7;
        int _1486 = _1485 - _unloader_s0_i;
        for (int _unloader_s0_j = _unloader_s0_i; _unloader_s0_j < _unloader_s0_i + _1486; _unloader_s0_j++)
        {
#pragma loop_coalesce 3
            for (int _unloader_s0_iii = 0; _unloader_s0_iii < 0 + 4; _unloader_s0_iii++)
            {
                for (int _unloader_s0_ii = 0; _unloader_s0_ii < 0 + 32; _unloader_s0_ii++)
                {
                    for (int _unloader_s0_jj = 0; _unloader_s0_jj < 0 + 32; _unloader_s0_jj++)
                    {
                        complex4 __1487 = read_channel_intel(_E_channel);
                        int _1488 = _addr_temp;
                        int _1489 = _1488 * 4;
                        vstore8(__1487.t, 0, (__address_space__unloader_mem_channel float *)(_unloader_mem_channel + _1489));
                        int _1490 = _addr_temp;
                        int _1491 = _1490 + 1;
                        _addr_temp = _1491;
                    } // for _unloader_s0_iii
                }     // for _unloader_s0_jj
            }         // for _unloader_s0_ii
        }             // for _unloader_s0_j
    }                 // for _unloader_s0_i
} // kernel kernel_unloader_1
#undef __address_space__unloader_mem_channel
