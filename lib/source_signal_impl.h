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

#ifndef INCLUDED_BEAMNET_SOURCE_SIGNAL_IMPL_H
#define INCLUDED_BEAMNET_SOURCE_SIGNAL_IMPL_H

#define TWO_PI 6.2831852

#include <beamnet/source_signal.h>

namespace gr {
  namespace beamnet {

    class source_signal_impl : public source_signal
    {
     private:
      int d_tx;
      int d_index;
      int d_fft_size;
      int d_null_len;
      int d_pd_len;

      gr_complex d_weight;

      std::vector<gr_complex> d_sync_word;
      std::vector< std::vector<gr_complex> > d_ce_word;

      int d_tx_state;
      int d_pd_state;
      int d_baseline; // 1: baseline (blind beamforming) algorithm; 0: use the proposed algorithm

      int d_offset;

     public:
      source_signal_impl(int tx, int index, int fft_size, int hd_len, int pd_len, const std::vector<gr_complex> &sync_word, int baseline);
      ~source_signal_impl();

      void phase_msg(pmt::pmt_t msg);

      // Where all the action really happens
      int work(int noutput_items,
         gr_vector_const_void_star &input_items,
         gr_vector_void_star &output_items);
    };

    enum tx_states_t {
        STATE_TX_PKT,

        STATE_TX_NULL,
        STATE_TX_SYNC,
        STATE_TX_CE,
        STATE_TX_PD,

        STATE_TX_PD_CS,
        STATE_TX_PD_BF,

        STATE_RX_SYNC

    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_SOURCE_SIGNAL_IMPL_H */

