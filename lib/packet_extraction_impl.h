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

#ifndef INCLUDED_BEAMNET_PACKET_EXTRACTION_IMPL_H
#define INCLUDED_BEAMNET_PACKET_EXTRACTION_IMPL_H

#include <beamnet/packet_extraction.h>

namespace gr {
  namespace beamnet {

    class packet_extraction_impl : public packet_extraction
    {
     private:
        float d_samp_rate;
        int d_fft_size;
        int d_sym_pkt;          // Number of symbol in each packet
        int d_detect_size;      // Packet detection buffer size in sample

        float d_inr_samp;       // After detecting a packet, the following d_inr_samp 
                                // is the packet interval in samples: d_inr_samp 
                                // samples do not detect packet.
        int d_tstamp;           // Timestamp in sample
        int d_offset;
        int d_pkt_index;
        float d_peak;

        float d_thr;

        int d_rx_state;

     public:
      packet_extraction_impl(float samp_rate, int fft_size, int d_sym_pkt, int detect_size, float thr, float inr);
      ~packet_extraction_impl();

      // Where all the action really happens
      void forecast (int noutput_items, gr_vector_int &ninput_items_required);

      int general_work(int noutput_items,
           gr_vector_int &ninput_items,
           gr_vector_const_void_star &input_items,
           gr_vector_void_star &output_items);
    };

    enum rx_sync_states_t {
        STATE_RX_ED,            // Energy detection
        STATE_RX_SS,            // Symbol sync
        STATE_RX_DETECTED,      // Packet has been synchronized
        STATE_RX_PKT,
        STATE_RX_INR            // Packet interval
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_PACKET_EXTRACTION_IMPL_H */

