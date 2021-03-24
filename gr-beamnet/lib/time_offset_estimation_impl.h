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

#ifndef INCLUDED_BEAMNET_TIME_OFFSET_ESTIMATION_IMPL_H
#define INCLUDED_BEAMNET_TIME_OFFSET_ESTIMATION_IMPL_H

#include <beamnet/time_offset_estimation.h>

namespace gr {
  namespace beamnet {

    class time_offset_estimation_impl : public time_offset_estimation
    {
     private:
        float d_samp_rate;
        int d_fft_size;
        int d_tx;                   // The number of TX
        int d_center_ind;           // Index of the zero carrier
        float d_msg_samples;          // Send a message after msg_samples points
        int d_count;

     public:
      time_offset_estimation_impl(float samp_rate, int fft_size, int tx, float update_rate);
      ~time_offset_estimation_impl();

      // Where all the action really happens
      int work(int noutput_items,
         gr_vector_const_void_star &input_items,
         gr_vector_void_star &output_items);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_TIME_OFFSET_ESTIMATION_IMPL_H */

