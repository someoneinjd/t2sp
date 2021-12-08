#if (PARAM==0)
//common params
#define KERNEL_NAME	"2dconv_14_14_512"
#define ISA_NAME "2dconv_14_14_512_genx.isa"

#define ITER    100

#define B       4
#define R_CI    512
#define CO      512
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	14
#define	OUTPUT_W_BEFORE_PADDING	14
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					7
#define WWW					7
#define HH					2
#define WW					2
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#elif (PARAM==1)
//common params
#define KERNEL_NAME	"2dconv_28_28_256"
#define ISA_NAME "2dconv_28_28_256_genx.isa"

#define ITER    100

#define B       4
#define R_CI    256
#define CO      512
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	28
#define	OUTPUT_W_BEFORE_PADDING	28
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					4
#define WWW					4
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#elif (PARAM==2)
//common params
#define KERNEL_NAME	"2dconv_28_28_512"
#define ISA_NAME "2dconv_28_28_512_genx.isa"

#define ITER    100

#define B       4
#define R_CI    512
#define CO      512
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	28
#define	OUTPUT_W_BEFORE_PADDING	28
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					7
#define WWW					7
#define HH					4
#define WW					4
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#elif (PARAM==3)
//common params
#define KERNEL_NAME	"2dconv_56_56_128"
#define ISA_NAME "2dconv_56_56_128_genx.isa"

#define ITER    100

#define B       4
#define R_CI    128
#define CO      256
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	56
#define	OUTPUT_W_BEFORE_PADDING	56
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#elif (PARAM==4)
//common params
#define KERNEL_NAME	"2dconv_56_56_256"
#define ISA_NAME "2dconv_56_56_256_genx.isa"

#define ITER    100

#define B       4
#define R_CI    256
#define CO      256
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	56
#define	OUTPUT_W_BEFORE_PADDING	56
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#elif (PARAM==5)
//common params
#define KERNEL_NAME	"2dconv_112_112_64"
#define ISA_NAME "2dconv_112_112_64_genx.isa"

#define ITER    100

#define B       4
#define R_CI    64
#define CO      128
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	112
#define	OUTPUT_W_BEFORE_PADDING	112
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)

#elif (PARAM==6)
//common params
#define KERNEL_NAME	"2dconv_112_112_128"
#define ISA_NAME "2dconv_112_112_128_genx.isa"

#define ITER    100

#define B       4
#define R_CI    128
#define CO      128
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	112
#define	OUTPUT_W_BEFORE_PADDING	112
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)

#elif (PARAM==7)
//common params
#define KERNEL_NAME	"2dconv_224_224_3"
#define ISA_NAME "2dconv_224_224_3_genx.isa"

#define ITER    100

#define B       4
#define R_CI    3
#define CO      64
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	224
#define	OUTPUT_W_BEFORE_PADDING	224
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     1

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    CII*CIO*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (CII*CIO*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(CII*CIO*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)

#elif (PARAM==8)
//common params
#define KERNEL_NAME	"2dconv_224_224_64"
#define ISA_NAME "2dconv_224_224_64_genx.isa"

#define ITER    100

#define B       4
#define R_CI    64
#define CO      64
#define STRIDE_H	1
#define STRIDE_W	1
#define PADDING_H	1
#define PADDING_W	1

//output
#define OUTPUT_H_BEFORE_PADDING	224
#define	OUTPUT_W_BEFORE_PADDING	224
#define OUTPUT_TOTAL_H		OUTPUT_H_BEFORE_PADDING
#define OUTPUT_TOTAL_W		OUTPUT_W_BEFORE_PADDING
#define HHH					8
#define WWW					8
#define HH					7
#define WW					7
#define H					((((OUTPUT_TOTAL_H+HH-1)/HH)+HHH-1)/HHH)
#define W					((((OUTPUT_TOTAL_W+WW-1)/WW)+WWW-1)/WWW)

#define COI     8
#define COO     (CO/COI)
#define CII     4
#define CIO     (R_CI/CII)

//weight
#define R_KW    3
#define R_KH    3

//input
#define INPUT_TOTAL_H     (HHH* HH *H *STRIDE_H +R_KH -STRIDE_H)
#define INPUT_TOTAL_W     (WWW* WW *W *STRIDE_W +R_KW -STRIDE_W)
#define INPUT_HHH       (HHH * STRIDE_H + R_KH - STRIDE_H)
#define INPUT_WWW      (WWW * STRIDE_W + R_KW - STRIDE_W)

//layout
#define LAYOUT_X    R_CI*B*W*H,                      INPUT_WWW*INPUT_HHH*WW*HH
#define WDITH_X     (R_CI*B*W*H)
#define HEIGHT_X	(INPUT_WWW*INPUT_HHH*WW*HH)

#define LAYOUT_Y    CO,          CII*R_KW*R_KH*CIO
#define WDITH_Y     (CO)
#define HEIGHT_Y    (CII*R_KW*R_KH*CIO)

#define RELAYOUT_O  CO*B*W*H,                 WWW*HHH*WW*HH
#define WDITH_O     (CO*B*W*H)
#define HEIGHT_O    (WWW*HHH*WW*HH)

//total size
#define SIZE_X		(R_CI*B*W*H*INPUT_WWW*INPUT_HHH*WW*HH)
#define SIZE_Y		(CO*CII*R_KW*R_KH*CIO)
#define SIZE_O		(CO*B*W*H*WWW*HHH*WW*HH)
#define XMAX        (SIZE_X)
#define WMAX        (SIZE_Y)
#define QMAX        (SIZE_O)

//other params
#define FLOPS   ((double)CO*B*OUTPUT_TOTAL_H*OUTPUT_TOTAL_W*R_CI*R_KH*R_KW*2)

#define GY      (B*H)
#define GX      (COO*W)
#define TY      (HH)
#define TX      (WW)
#endif