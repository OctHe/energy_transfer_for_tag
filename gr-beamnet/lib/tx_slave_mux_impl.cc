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
#include "tx_slave_mux_impl.h"
#include "tx_header.h"

namespace gr {
  namespace beamnet {

    tx_slave_mux::sptr
    tx_slave_mux::make(int tx, int fft_size, int hd_len, int pd_len)
    {
      return gnuradio::get_initial_sptr
        (new tx_slave_mux_impl(tx, fft_size, hd_len, pd_len));
    }

    /*
     * The private constructor
     */
    tx_slave_mux_impl::tx_slave_mux_impl(int tx, int fft_size, int hd_len, int pd_len)
      : gr::block("tx_slave_mux",
              gr::io_signature::make2(2, 2, sizeof(gr_complex), sizeof(char)),
              gr::io_signature::make(1, 1, sizeof(gr_complex))),
      d_tx(tx),
      d_fft_size(fft_size),
      d_hd_len(hd_len),
      d_tx_state(STATE_RX_SYNC)
    {
       d_pkt_size = fft_size * (hd_len * tx + pd_len);
       d_pkt_offset = 0;
    }

    /*
     * Our virtual destructor.
     */
    tx_slave_mux_impl::~tx_slave_mux_impl()
    {
    }

    void
    tx_slave_mux_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        ninput_items_required[0] = d_pkt_size;
        ninput_items_required[1] = noutput_items;
    }

    int
    tx_slave_mux_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      const gr_complex *in_pkt = (const gr_complex *) input_items[0];
      const char *in_trg = (const char *) input_items[1];
      gr_complex *out = (gr_complex *) output_items[0];

      // Packet mux
      for(unsigned i = 0; i < noutput_items; )
      {
          switch(d_tx_state)
          {
              case STATE_RX_SYNC:
                  
                  if(in_trg[i] == 1)
                      out[i++] = 0;
                  else
                      d_tx_state = STATE_TX_PKT;

                  break;

              case STATE_TX_PKT:

                  // if(d_pkt_offset < d_fft_size * d_hd_len)
                  // {
                  //     // Slaves do not send sync words
                  //     out[i] = 0;
                  //
                  //     d_pkt_offset ++;
                  //     i++;
                  // }
                  // else
                  // {
                    out[i] = in_pkt[i];
                  
                    d_pkt_offset ++;
                    i++;
                    
                    if(d_pkt_offset == d_pkt_size)
                    {
                        d_pkt_offset = 0;
                        // d_tx_state = STATE_RX_SYNC;
                    }
                  // }

                  break;

              default:
                  break;
          }
      }

      // Tell runtime system how many input items we consumed on
      // each input stream.
      consume (0, d_pkt_size);
      consume (1, noutput_items);

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

