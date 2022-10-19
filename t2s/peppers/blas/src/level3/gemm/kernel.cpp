#include "Halide.h"

// Constant parameters of the kernel (dimensions of the systolic array)
#include "parameters.h"

using namespace Halide;

int main()
{
    // Dependences
    #define P               kkk,      jjj,  iii,  jj, ii, kk,     k,  j,i
    #define P_kkk_minus_1   kkk-1,    jjj,  iii,  jj, ii, kk,     k,  j,i
    #define P_kk_minus_1    kkk+KKK-1,jjj,  iii,  jj, ii, kk-1,   k,  j,i
    #define P_k_minus_1     kkk+KKK-1,jjj,  iii,  jj, ii, kk+KK-1,k-1,j,i
    #define P_jjj_minus_1   kkk,      jjj-1,iii,  jj, ii, kk,     k,  j,i
    #define P_iii_minus_1   kkk,      jjj,  iii-1,jj, ii, kk,     k,  j,i
    #define P_Out                     jjj,  iii,  jj, ii,             j,i

    // Loop indices before tiling. They might be bigger than the matrices' actual dimensions, due to the fix dimensions of the systolic array.
    #define total_i         (iii + III * ii + III * II * i)
    #define total_j         (jjj + JJJ * jj + JJJ * JJ * j)
    #define total_k         (kkk + KKK * kk + KKK * KK * k)

    // Matrices' dimensions.
    #define MATRICES_I      (A.dim(0).extent())
    #define MATRICES_K      (A.dim(1).extent())
    #define MATRICES_J      (B.dim(1).extent())

    // Are the loop indices within the range of the matrices' dimensions?
    #define addr_A_in_range select(TransA = 'N', total_i < MATRICES_I && total_k < MATRICES_K, total_k < MATRICES_I && total_i < MATRICES_K)
    #define addr_B_in_range select(TransB = 'N', total_k < MATRICES_K && total_j < MATRICES_J, total_j < MATRICES_K && total_k < MATRICES_J)
    #define addr_C_in_range (total_i < MATRICES_I && total_j < MATRICES_J)

    // Addresses of matrices
    #define addr_A          select(TransA = 'N', total_i + MATRICES_I * total_k, total_k + MATRICES_I * total_i)
    #define addr_B          select(TransA = 'N', total_k + MATRICES_K * total_j, total_j + MATRICES_K * total_k)
    #define addr_output     (total_i + MATRICES_I * total_j)

    // Outer loop bounds, which are determined by the matrices' dimensions
    #define I (MATRICES_I / (III * II))
    #define J (MATRICES_J / (JJJ * JJ))
    #define K (MATRICES_K / (KKK * KK))

    // Inputs. The matrices have been linearized into vectors. We will access them explicitly according to transpose and leading dimension info.
    Param<char> TransA, TransB;
    Param<CONST_TYPE> alpha, beta;
    ImageParam A("A", TTYPE, 1), B("B", TTYPE, 1), C("C", TTYPE, 1);

    // UREs
    Var kkk("kkk"), jjj("jjj"), iii("iii"), jj("jj"), ii("ii"), kk("kk"), k("k"), j("j"), i("i");
    URE X("X", TTYPE, {P}), Y("Y", TTYPE, {P}), Z("Z", TTYPE, {P}), Product("Product"), Out("Out");
    X(P) = select(jjj == 0, select(addr_A_in_range, A(addr_A), 0), X(P_jjj_minus_1));
    Y(P) = select(iii == 0, select(addr_B_in_range, B(addr_B), 0), Y(P_iii_minus_1));
    Z(P) = select(kkk == 0 && kk == 0 && k == 0, 0,
                select(kkk == 0, select(kk == 0, Z(P_k_minus_1), Z(P_kk_minus_1)), Z(P_kkk_minus_1)))
                + X(P) * Y(P);
    Product(P_Out) = select(kkk == KKK-1 && kk == KK-1 && k == K-1, Z(P));

    // Output, which is actually connected to C. So we read C(i,j) and then overwrite it. There should be no worry of data race.
    // Note that in this URE, the select does not have a false branch. So only when address of matrix C is within range,
    // we will overwrite C.
    Out(P_Out) = select(addr_C_in_range, select(alpha == 0, 0, alpha * Product(P_Out)) + select(beta == 0, 0, beta * C(P_Out));

    // Put the UREs that compute A*B (i.e. X, Y, Z and Product) inside the same loop nest.
    X.merge_ures(Y, Z, Product);

    // Explicitly set the loop bounds
    X.set_bounds(jjj, 0, JJJ, iii, 0, III, kkk, 0, KKK)
     .set_bounds(jj,  0, JJ,  ii,  0, II,  kk,  0, KK)
     .set_bounds(j,   0, J,   i,   0, I,   k,   0, K);

    // Create a systolic array
    X.space_time_transform(jjj, iii);

    // I/O network
    Stensor DA("aLoader", DRAM), SA("aFeeder", SRAM), DB("bLoader", DRAM), SB("bFeeder", SRAM), DC("cLoader", DRAM);
    Stensor ROut("collector", REG), DOut("unloader", DRAM), Output("Output");
    A   >> DA.out(kkk)              >> FIFO(256) >> SA.scope(k).out(kkk, iii) >> FIFO(256);
    B   >> DB.out(kkk)              >> FIFO(256) >> SB.scope(k).out(kkk, jjj) >> FIFO(256);
    C   >> DC.out(jjj)              >> FIFO(256);
    Out >> ROut.scope(iii).out(jjj) >> FIFO(256) >> DOut >> Output(addr_output);

    // Compile the kernel to an FPGA bitstream, and expose a C interface for the host to invoke
    Output.compile_to_host(INTERFACE_FILE, { TransA, TransB, alpha, beta, A, B, C }, KERNEL, IntelFPGA);

    return 0;
}
