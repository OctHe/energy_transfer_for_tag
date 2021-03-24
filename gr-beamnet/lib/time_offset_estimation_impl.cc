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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gnuradio/io_signature.h>
#include "time_offset_estimation_impl.h"
#include <gnuradio/math.h>
#include <gnuradio/gr_complex.h>

#define GR_M_PI 3.1415926
#define GR_M_TWOPI (2*GR_M_PI)

namespace gr {
  namespace beamnet {

    time_offset_estimation::sptr
    time_offset_estimation::make(float samp_rate, int fft_size, int tx, float update_rate)
    {
      return gnuradio::get_initial_sptr
        (new time_offset_estimation_impl(samp_rate, fft_size, tx, update_rate));
    }

    /*
     * The private constructor
     */
    time_offset_estimation_impl::time_offset_estimation_impl(float samp_rate, int fft_size, int tx, float update_rate)
      : gr::sync_block("time_offset_estimation",
              gr::io_signature::make(1, 1, fft_size * sizeof(gr_complex)),
              gr::io_signature::make(0, 0, 0)),
              d_samp_rate(samp_rate),
              d_fft_size(fft_size),
              d_center_ind(fft_size / 2),
              d_tx(tx),
              d_msg_samples(update_rate),
              d_count(update_rate)
    {
        message_port_register_out(pmt::mp("time_sync"));
        message_port_register_out(pmt::mp("freq_sync"));
    }

    /*
     * Our virtual destructor.
     */
    time_offset_estimation_impl::~time_offset_estimation_impl()
    {
    }

    int
    time_offset_estimation_impl::work(int noutput_items,
        gr_vector_const_void_star &input_items,
        gr_vector_void_star &output_items)
    {
      const gr_complex *in = (const gr_complex *) input_items[0];

      
        if(d_count > 0)
        {
            d_count -= noutput_items * d_fft_size;

            // Tell runtime system how many output items we produced.
            return noutput_items;
        }
        else
        {
            d_count = d_count + d_msg_samples - noutput_items * d_fft_size;
        }

      // Do time and frequency synchronization of all power sources (TXs) 
        std::vector<float> time_offset(d_tx, 0);

        std::vector<float> p0(d_tx, 0), p1(d_tx, 0);
        float offset;   // temp

        for(int i = 0; i < noutput_items; i++)
        {
            // carrier index: [x 4 3 2 1 0 1 2 3 4]
            for(int j = 0; j < d_tx; j++)
            {

                p0[j] = gr::fast_atan2f(in[d_center_ind -j -1]);   
                p1[j] = gr::fast_atan2f(in[d_center_ind +j +1]);   

                offset = (p1[j] - p0[j]) / GR_M_TWOPI * d_fft_size / ((j +1) *2);
                time_offset[j] = time_offset[j] + offset;

            }
            in += d_fft_size;
        }

        for(int j = 0; j < d_tx; j++)
        {
            time_offset[j] = time_offset[j] / noutput_items;
          }

        // Message to each power source
        pmt::pmt_t time_msg = pmt::make_vector(d_tx, pmt::from_double(0)); 
        pmt::pmt_t freq_msg = pmt::make_vector(d_tx, pmt::from_double(0)); 
        for(int j = 0; j < d_tx; j++)
        {
            pmt::vector_set(time_msg, j, pmt::from_double(time_offset[j])); 
        }

        message_port_pub(pmt::mp("time_sync"), time_msg);

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

