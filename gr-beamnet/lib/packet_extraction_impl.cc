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
#include "packet_extraction_impl.h"

namespace gr {
  namespace beamnet {

    packet_extraction::sptr
    packet_extraction::make(int fft_size, int pkt_size, float thr)
    {
      return gnuradio::get_initial_sptr
        (new packet_extraction_impl(fft_size, pkt_size, thr));
    }

    /*
     * The private constructor
     */
    packet_extraction_impl::packet_extraction_impl(int fft_size, int pkt_size, float thr)
      : gr::block("packet_extraction",
              gr::io_signature::make3(3, 3, sizeof(gr_complex), sizeof(float), sizeof(float)),
              gr::io_signature::make(1, 1, sizeof(gr_complex) * fft_size * pkt_size)),
        d_fft_size(fft_size),
        d_pkt_size(pkt_size),
        d_thr(thr),
        d_pkt_len(fft_size * pkt_size)
    {}

    /*
     * Our virtual destructor.
     */
    packet_extraction_impl::~packet_extraction_impl()
    {
    }

    void
    packet_extraction_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        for (unsigned i = 0; i < ninput_items_required.size(); i++) 
            ninput_items_required[i] = (noutput_items + 2) * d_pkt_len;
    }

    int
    packet_extraction_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      // in_sig: Input of the complex received signal
      // in_ed: Input of the energy detection result
      // in_ss: Input of the symbol sync result
      const gr_complex *in_sig = (const gr_complex *) input_items[0];
      const float *in_ed = (const float *) input_items[1];
      const float *in_ss = (const float *) input_items[2];
      gr_complex *out = (gr_complex *) output_items[0];

      int extracted_pkt = 0;    // The number of extracted packet in this stream
      bool pkt_detected = false, sym_sync = false;

      // Extract the packet from the results of energy detection and symbol synchronization
      unsigned i = 0;
      while(i < noutput_items * d_pkt_len)
      {
          if(in_ed[i] > d_thr)
          {
              extracted_pkt ++;

              // If the packet is detected, then find the start of it in the following (d_pkt_len) samples
              for(unsigned j = 1; j < d_pkt_len; j++)
                    i = (in_ss[i + j] > in_ss[i]) ? (i + j) : i;


              // Output the following (d_pkt_len) samples, and continuously find the next packet
              size_t block_size = output_signature()->sizeof_stream_item (0);
              memcpy(out + (extracted_pkt -1) * d_pkt_len, in_sig + i, block_size);
              i += d_pkt_len;

          }
          else          
              i++;

      }

      // Tell runtime system how many input items we consumed on
      // each input stream.
      consume_each ((i + 1) * d_pkt_len);

      // Tell runtime system how many output items we produced.
      return extracted_pkt;
    }

  } /* namespace beamnet */
} /* namespace gr */

