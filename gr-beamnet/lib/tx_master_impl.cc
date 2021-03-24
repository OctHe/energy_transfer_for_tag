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
#include "tx_master_impl.h"
#include "tx_header.h"

namespace gr {
  namespace beamnet {

    tx_master::sptr
    tx_master::make(int tx, int fft_size, int hd_len, int pd_len)
    {
      return gnuradio::get_initial_sptr
        (new tx_master_impl(tx, fft_size, hd_len, pd_len));
    }

    /*
     * The private constructor
     */
    tx_master_impl::tx_master_impl(int tx, int fft_size, int hd_len, int pd_len)
      : gr::sync_block("tx_master",
              gr::io_signature::make(0, 0, 0),
              gr::io_signature::make(1, 1, sizeof(gr_complex) * fft_size)),
      d_tx(tx),
      d_fft_size(fft_size),
      d_hd_len(hd_len),
      d_pd_len(pd_len),
      d_tx_state(STATE_TX_SYNC),
      d_pd_state(STATE_TX_PD_CS)
    {

       d_sync_offset = 0;
       d_ce_offset = 0;
       d_pd_offset = 0;
    }

    /*
     * Our virtual destructor.
     */
    tx_master_impl::~tx_master_impl()
    {
    }

    int
    tx_master_impl::work(int noutput_items,
        gr_vector_const_void_star &input_items,
        gr_vector_void_star &output_items)
    {
      gr_complex *out = (gr_complex *) output_items[0];

      // Signal from master source
      int DATA_INDEX = 9; // The carrier index of the data
      std::vector<gr_complex> sync_signal = {0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0};
      std::vector<gr_complex> ce_signal(d_fft_size, 0); 
       
    std::vector< std::vector<gr_complex> > CE_WORD = {
        {gr_complex(1, 0), gr_complex(1, 0), gr_complex(1, 0), gr_complex(1, 0)},
        {gr_complex(1, 0), gr_complex(0, 1), gr_complex(-1, 0), gr_complex(0, -1)},
        {gr_complex(1, 0), gr_complex(-1, 0), gr_complex(1, 0), gr_complex(-1, 0)},
        {gr_complex(1, 0), gr_complex(0, -1), gr_complex(-1, 0), gr_complex(0, 1)}
        };

      std::vector<gr_complex> pd = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0};

      for(int i = 0; i < noutput_items; i++)
      {
       switch(d_tx_state)
       {
            case STATE_TX_SYNC:

                memcpy(out, sync_signal.data(), sizeof(gr_complex) * d_fft_size);
                out += d_fft_size;
                d_sync_offset ++;

                if(d_sync_offset == d_hd_len)
                {
                    d_sync_offset = 0;
                    d_tx_state = STATE_TX_CE;
                }
                break;

            case STATE_TX_CE:

                ce_signal[DATA_INDEX] = CE_WORD[0][d_ce_offset / d_hd_len];
                memcpy(out, ce_signal.data(), sizeof(gr_complex) * d_fft_size);
                    
                out += d_fft_size;
                d_ce_offset ++;

                if(d_ce_offset == d_hd_len * d_tx)
                {
                    d_ce_offset = 0;
                    d_tx_state = STATE_TX_PD;
                }
                break;

            case STATE_TX_PD:
                switch(d_pd_state)
                {
                    case STATE_TX_PD_CS:

                        memcpy(out, pd.data(), sizeof(gr_complex) * d_fft_size);
                        
                        out += d_fft_size;
                        d_pd_offset ++;
                        
                        break;

                    case STATE_TX_PD_BF:
                        break;

                    default:
                        break;
                }

                if(d_pd_offset == d_pd_len)
                {
                    d_pd_offset = 0;
                    d_tx_state = STATE_TX_SYNC;
                }
                break;

            default:
                break;
        }
       }

      // Tell runtime system how many output items we produced.
      return noutput_items;
    }

  } /* namespace beamnet */
} /* namespace gr */

