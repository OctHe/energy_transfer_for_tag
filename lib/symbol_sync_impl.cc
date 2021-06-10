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
#include "symbol_sync_impl.h"

namespace gr {
  namespace beamnet {

    symbol_sync::sptr
    symbol_sync::make(int fft_size, const std::vector<gr_complex> &sync_word)
    {
      return gnuradio::get_initial_sptr
        (new symbol_sync_impl(fft_size, sync_word));
    }

    /*
     * The private constructor
     */
    symbol_sync_impl::symbol_sync_impl(int fft_size, const std::vector<gr_complex> &sync_word)
      : gr::block("symbol_sync",
              gr::io_signature::make(1, 1, sizeof(gr_complex)),
              gr::io_signature::make(1, 1, sizeof(float))),
        d_fft_size(fft_size),
        d_sync_word(sync_word)
    {
        d_corr_len = sync_word.size();
    }

    /*
     * Our virtual destructor.
     */
    symbol_sync_impl::~symbol_sync_impl()
    {
    }

    void
    symbol_sync_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        ninput_items_required[0] = noutput_items + d_corr_len;
    }

    int
    symbol_sync_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      const gr_complex *in = (const gr_complex *) input_items[0];
      float *out = (float *) output_items[0];

      // Correlation
      // std::vector<gr_complex> res(noutput_items);
      gr_complex res[noutput_items];

      for(int i = 0; i < noutput_items; i++)
      {
            volk_32fc_x2_conjugate_dot_prod_32fc(res + i, in, d_sync_word.data(), d_corr_len);
            in ++;
      }

      volk_32fc_magnitude_32f(out, res, noutput_items);

      // Tell runtime system how many input items we consumed on
      // each input stream.
      consume_each (noutput_items);

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

