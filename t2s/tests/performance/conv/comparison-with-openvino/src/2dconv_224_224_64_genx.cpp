
#include <cm/cm.h>
#include <cm/cmtl.h>
extern "C" _GENX_MAIN_ void kernel_Z_WAIT_FINISH(
 SurfaceIndex _out__1,
 SurfaceIndex _x,
 SurfaceIndex _y)
{
  int _Z_s0_h_b___block_id_y = cm_group_id(1);
  int _Z_s0_w_coo___block_id_x = cm_group_id(0);
  int ___thread_id_y = cm_local_id(1);
  int ___thread_id_x = cm_local_id(0);
  vector<float, 512> _Z;
  vector<float, 120> _x_im_buf;
  vector<float, 288> _y_im_buf;
  _Z.select<512, 1>(0) = 0.000000;
  for (int _Z_s0_r_cio = 0; _Z_s0_r_cio < 0 + 16; _Z_s0_r_cio++)
  {
    int _66 = (_Z_s0_r_cio*36);
    int _67 = ((_Z_s0_w_coo___block_id_x/4)*8);
    read(_y, (_67*4), (_66+0), _y_im_buf.select<288, 1>(0).format<float, 36, 8>().select<8, 1, 8, 1>(0, 0));
    read(_y, (_67*4), (_66+8), _y_im_buf.select<288, 1>(0).format<float, 36, 8>().select<8, 1, 8, 1>(8, 0));
    read(_y, (_67*4), (_66+16), _y_im_buf.select<288, 1>(0).format<float, 36, 8>().select<8, 1, 8, 1>(16, 0));
    read(_y, (_67*4), (_66+24), _y_im_buf.select<288, 1>(0).format<float, 36, 8>().select<8, 1, 8, 1>(24, 0));
    read(_y, (_67*4), (_66+32), _y_im_buf.select<288, 1>(0).format<float, 36, 8>().select<4, 1, 8, 1>(32, 0));
    #pragma unroll
    for (int _Z_s0_hhh = 0; _Z_s0_hhh < 0 + 8; _Z_s0_hhh++)
    {
      int _68 = (((___thread_id_y*70)+((___thread_id_x*10)+_Z_s0_hhh))*10);
      int _69 = ((((_Z_s0_h_b___block_id_y%4)*256)+(((_Z_s0_w_coo___block_id_x%4)*64)+(((_Z_s0_h_b___block_id_y/4)*16)+_Z_s0_r_cio)))*4);
      read(_x, (_69*4), (_68+0), _x_im_buf.select<120, 1>(0).format<float, 30, 4>().select<16, 1, 4, 1>(0, 0));
      read(_x, (_69*4), (_68+16), _x_im_buf.select<120, 1>(0).format<float, 30, 4>().select<14, 1, 4, 1>(16, 0));
      #pragma unroll
      for (int _Z_s0_www = 0; _Z_s0_www < 0 + 8; _Z_s0_www++)
      {
        #pragma unroll
        for (int _Z_s0_r_kh = 0; _Z_s0_r_kh < 0 + 3; _Z_s0_r_kh++)
        {
          #pragma unroll
          for (int _Z_s0_r_kw = 0; _Z_s0_r_kw < 0 + 3; _Z_s0_r_kw++)
          {
            #pragma unroll
            for (int _Z_s0_r_cii = 0; _Z_s0_r_cii < 0 + 4; _Z_s0_r_cii++)
            {
              _Z.select<8, 1>((((_Z_s0_hhh*8)+_Z_s0_www)*8)) = (_Z.select<8, 1>((((_Z_s0_hhh*8)+_Z_s0_www)*8))+(_y_im_buf.select<8, 1>((((_Z_s0_r_kh*12)+((_Z_s0_r_kw*4)+_Z_s0_r_cii))*8))*_x_im_buf(((((_Z_s0_r_kh*10)+(_Z_s0_r_kw+_Z_s0_www))*4)+_Z_s0_r_cii))));
            } // for _Z_s0_r_cii
          } // for _Z_s0_r_kw
        } // for _Z_s0_r_kh
      } // for _Z_s0_www
    } // for _Z_s0_hhh
  } // for _Z_s0_r_cio
  int _70 = (((___thread_id_y*7)+___thread_id_x)*64);
  int _71 = ((((_Z_s0_h_b___block_id_y%4)*128)+(((_Z_s0_w_coo___block_id_x%4)*32)+((_Z_s0_w_coo___block_id_x/4)+((_Z_s0_h_b___block_id_y/4)*8))))*8);
  write(_out__1, (_71*4), (_70+0), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(0, 0));
  write(_out__1, (_71*4), (_70+8), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(8, 0));
  write(_out__1, (_71*4), (_70+16), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(16, 0));
  write(_out__1, (_71*4), (_70+24), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(24, 0));
  write(_out__1, (_71*4), (_70+32), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(32, 0));
  write(_out__1, (_71*4), (_70+40), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(40, 0));
  write(_out__1, (_71*4), (_70+48), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(48, 0));
  write(_out__1, (_71*4), (_70+56), _Z.select<512, 1>(0).format<float, 64, 8>().select<8, 1, 8, 1>(56, 0));
} // kernel kernel_Z_WAIT_FINISH
