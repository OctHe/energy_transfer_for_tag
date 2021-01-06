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
#include <volk/volk.h>
#include "correlation_detector_impl.h"

namespace gr {
  namespace beamnet {

    correlation_detector::sptr
    correlation_detector::make(int len, float threshold, float deviation)
    {
      return gnuradio::get_initial_sptr
        (new correlation_detector_impl(len, threshold, deviation));
    }

    /*
     * The private constructor
     */
    correlation_detector_impl::correlation_detector_impl(int len, float threshold, float deviation)
      : gr::block("correlation_detector",
              gr::io_signature::make(1, 1, sizeof(gr_complex)),
              gr::io_signature::make(1, 1, sizeof(float))),
              d_length(len),
              d_threshold(threshold),
              d_deviation(deviation)
    {
        d_detect = false;
        d_sent = false;
        d_debug_num = 40;
        message_port_register_out(pmt::mp("target"));

    }

    /*
     * Our virtual destructor.
     */
    correlation_detector_impl::~correlation_detector_impl()
    {
    }

    void
    correlation_detector_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        ninput_items_required[0] = noutput_items + 2 * d_length;
    }

    int
    correlation_detector_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      const gr_complex *in = (const gr_complex *) input_items[0];
      float *out = (float *) output_items[0];
      gr_complex result[noutput_items];

      // Detect the plateau as the frame start
      for(int i = 0; i < noutput_items; i++)
      {
            // input 2 vectors
            gr_complex ivec1[d_length], ivec2[d_length];

            for(int j = 0; j < d_length; j++)
            {
                ivec1[j] = in[i + j];
                ivec2[j] = in[i + d_length + j];
            }

            // correlation
            volk_32fc_x2_conjugate_dot_prod_32fc(result + i, ivec1, ivec2, d_length);
      }

      volk_32fc_magnitude_32f(out, result, noutput_items);

      for(int i = 0; i < noutput_items -1; i++)
      {
          // energy detection
          if((out[i+1] > d_threshold) && (out[i] <= d_threshold))
          {
              d_detect = true;
              break;
          }
          // sent the target when detect the energy
          if(d_detect && !d_sent && (out[i] > d_threshold) && (std::fabs(out[i+1] - out[i]) <= d_deviation))
          {
              if(d_debug_num == 0)
                  break;
              else
                  d_debug_num --;

              pmt::pmt_t target_msg = pmt::make_vector(d_length, pmt::from_complex(gr_complex(0, 0))); 
              for(int j = 0; j < d_length; j++)
                pmt::vector_set(target_msg, j, pmt::from_complex(in[i+j])); 

              pmt::pmt_t msg_pair = pmt::cons(pmt::make_dict(), target_msg);
              message_port_pub(pmt::mp("target"), msg_pair);
             
              d_sent = true;
              break;
          }
         
        if((out[i+1] <= d_threshold) && (out[i] > d_threshold))
        {
            d_detect = false;
            d_sent = false;
            break;
        }
      }


      // Tell runtime system how many input items we consumed on
      // each input stream.
      consume_each (noutput_items);

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

