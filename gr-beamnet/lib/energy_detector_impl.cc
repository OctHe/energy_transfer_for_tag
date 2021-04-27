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
#include "energy_detector_impl.h"

namespace gr {
  namespace beamnet {

    energy_detector::sptr
    energy_detector::make(int pkt_size)
    {
      return gnuradio::get_initial_sptr
        (new energy_detector_impl(pkt_size));
    }

    /*
     * The private constructor
     */
    energy_detector_impl::energy_detector_impl(int pkt_size)
      : gr::block("energy_detector",
              gr::io_signature::make(1, 1, sizeof(gr_complex)),
              gr::io_signature::make(1, 1, sizeof(float))),
      d_pkt_size(pkt_size)
    {
    }

    /*
     * Our virtual destructor.
     */
    energy_detector_impl::~energy_detector_impl()
    {
    }

    void
    energy_detector_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        ninput_items_required[0] = noutput_items + d_pkt_size;
    }

    int
    energy_detector_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      const gr_complex *in = (const gr_complex *) input_items[0];
      float *out = (float *) output_items[0];

      float res[noutput_items + d_pkt_size];

      // Calculate the energy  
        volk_32fc_magnitude_squared_32f(res, in, noutput_items + d_pkt_size);

        out[0] = 0;
        for(int i = 0; i < d_pkt_size; i++)
            out[0] += res[i];

        for(int i = 1; i < noutput_items; i++)
            out[i] = out[i-1] + res[i-1 + d_pkt_size] - res[i-1];
        
        for(int i = 0; i < noutput_items; i++)
            out[i] = out[i] / d_pkt_size;

      // Tell runtime system how many input items we consumed on
      // each input stream.
      consume_each (noutput_items);

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

