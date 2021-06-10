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
#include "packet_demux_impl.h"
#include <volk/volk.h>
#include "rx_header.h"

namespace gr {
  namespace beamnet {

    packet_demux::sptr
    packet_demux::make(int tx, int fft_size, int hd_len, int pd_len)
    {
      return gnuradio::get_initial_sptr
        (new packet_demux_impl(tx, fft_size, hd_len, pd_len));
    }

    /*
     * The private constructor
     */
    packet_demux_impl::packet_demux_impl(int tx, int fft_size, int hd_len, int pd_len)
      : gr::sync_block("packet_demux",
              gr::io_signature::make(1, 1, sizeof(gr_complex) * fft_size),
              gr::io_signature::make(0, 0, 0)),
        d_tx(tx),
        d_fft_size(fft_size),
        d_hd_len(hd_len),
        d_pd_len(pd_len),
        d_rx_state(STATE_RX_SYNC)
    {
        d_offset = 0;
        d_nrg = 0;

        d_ce_word.resize(tx);

        message_port_register_out(pmt::mp("ce"));
    }

    /*
     * Our virtual destructor.
     */
    packet_demux_impl::~packet_demux_impl()
    {
    }

    int
    packet_demux_impl::work(int noutput_items,
        gr_vector_const_void_star &input_items,
        gr_vector_void_star &output_items)
    {
      const gr_complex *in = (const gr_complex *) input_items[0];

      float nrg[noutput_items * d_fft_size];

      int DATA_INDEX = 9; // The carrier index of the data (8 is DC value)

      // Demux the packet
        volk_32fc_magnitude_squared_32f(nrg, in, noutput_items * d_fft_size);

        for(int i = 0; i < noutput_items; i++)
        {
            switch(d_rx_state)
            {
                case STATE_RX_SYNC:

                    d_offset ++;

                    if(d_offset == d_hd_len)
                    {
                        d_offset = 0;
                        d_rx_state = STATE_RX_CE;
                    }

                    break;
                    
                case STATE_RX_CE:

                    d_ce_word[d_offset % d_tx] += in[i * d_fft_size + DATA_INDEX];
                    d_offset ++;

                    if(d_offset == d_hd_len * d_tx)
                    {
                        // Message
                        pmt::pmt_t msg_vec = pmt::make_vector(d_tx, pmt::from_complex(gr_complex(0, 0))); 
                        for(int j = 0; j <d_tx; j++)
                        {
                            d_ce_word[j] /= d_hd_len;
                            pmt::vector_set(msg_vec, j, pmt::from_complex(d_ce_word[j])); 
                        }
                        pmt::pmt_t msg_pair = pmt::cons(pmt::make_dict(), msg_vec);
                        message_port_pub(pmt::mp("ce"), msg_pair);

                        for(int j = 0; j <d_tx; j++)
                            d_ce_word[j] = 0;

                        d_offset = 0;
                        d_rx_state = STATE_RX_PD;
                    }

                    break;

                case STATE_RX_PD:

                    // Calculate the energy
                    for(unsigned j = 0; j < d_fft_size; j++)
                        d_nrg += nrg[i * d_fft_size + j];

                    d_offset ++;
        
                    if(d_offset == d_pd_len)
                    {
                        // Output the energy
                        d_nrg = d_nrg / (d_pd_len * d_fft_size);
                        
                        std::cout << "Energy: " << d_nrg << std::endl;
                        
                        d_offset = 0;
                        d_rx_state = STATE_RX_SYNC;
                    }
                    break;

                default:
                    throw std::runtime_error("invalid state");
                    break;
            }
        }

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

