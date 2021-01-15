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

#ifndef INCLUDED_BEAMNET_SIGNAL_GENERATOR_IMPL_H
#define INCLUDED_BEAMNET_SIGNAL_GENERATOR_IMPL_H

#include <beamnet/signal_generator.h>

namespace gr {
  namespace beamnet {

    class signal_generator_impl : public signal_generator
    {
     private:
         float d_samp_rate;
         int d_fft_size;
         int d_tx_index;
         float d_freq_offset;   // Freq offset sent from the receiver
         float d_phase_offset;  // Phase offset caused by freq offset
         float d_time_offset;   // Time offset sent from the receiver
         int d_samp_offset;     // Sample offset caused by time offset
         int d_state;

     public:
      signal_generator_impl(float samp_rate, int fft_size, int tx_index);
      ~signal_generator_impl();

      // Where all the action really happens
      int work(int noutput_items,
         gr_vector_const_void_star &input_items,
         gr_vector_void_star &output_items);

      void set_time_offset(pmt::pmt_t msg);
      void set_freq_offset(pmt::pmt_t msg);

    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_SIGNAL_GENERATOR_IMPL_H */

