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

#ifndef INCLUDED_BEAMNET_PACKET_TRIGGER_IMPL_H
#define INCLUDED_BEAMNET_PACKET_TRIGGER_IMPL_H

#include <beamnet/packet_trigger.h>

namespace gr {
  namespace beamnet {

    class packet_trigger_impl : public packet_trigger
    {
     private:
        int d_fft_size;
        int d_pkt_size; // Packet size in symbol
        int d_pkt_len;  // Packet size in sample

        float d_thr;

        int d_state;
        bool d_find_trig; // An indicator about the trigger
        int d_detect_offset;
        int d_pkt_offset;

     public:
      packet_trigger_impl(int fft_size, int pkt_size, float thr);
      ~packet_trigger_impl();

      // Where all the action really happens
      void forecast (int noutput_items, gr_vector_int &ninput_items_required);

      int general_work(int noutput_items,
           gr_vector_int &ninput_items,
           gr_vector_const_void_star &input_items,
           gr_vector_void_star &output_items);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_PACKET_TRIGGER_IMPL_H */
