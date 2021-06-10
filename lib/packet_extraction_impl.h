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
        int d_skip_samp;  // Skip the samples after finishing the packet extraction
        int d_fft_size;
        int d_pkt_size;  // Packet size in sample

        int d_offset;
        int d_pkt_index;
        float d_peak;

        int d_rx_state;

        float d_thr;

     public:
      packet_extraction_impl(float samp_rate, int fft_size, int pkt_size, float thr);
      ~packet_extraction_impl();

      // Where all the action really happens
      void forecast (int noutput_items, gr_vector_int &ninput_items_required);

      int general_work(int noutput_items,
           gr_vector_int &ninput_items,
           gr_vector_const_void_star &input_items,
           gr_vector_void_star &output_items);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_PACKET_EXTRACTION_IMPL_H */

