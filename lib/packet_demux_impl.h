/* -*- c++ -*- */
/* 
 * Copyright 2021 gr-beamnet author.
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifndef INCLUDED_BEAMNET_PACKET_DEMUX_IMPL_H
#define INCLUDED_BEAMNET_PACKET_DEMUX_IMPL_H

#include <beamnet/packet_demux.h>

namespace gr {
  namespace beamnet {

    enum rx_states_t {
        STATE_RX_SYNC,
        STATE_RX_CE,
        STATE_RX_PD
    };

    class packet_demux_impl : public packet_demux
    {
     private:
         int d_tx;
         int d_fft_size;
         int d_sym_sync;
         int d_sym_pd;
         int d_rx_state;

         unsigned d_sym_offset;
         float d_nrg;

         std::vector<gr_complex> d_ce_word;

     public:
      packet_demux_impl(int tx, int fft_size, int sym_sync, int sym_pd);
      ~packet_demux_impl();

      // Where all the action really happens
      int work(int noutput_items,
         gr_vector_const_void_star &input_items,
         gr_vector_void_star &output_items);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_PACKET_DEMUX_IMPL_H */

