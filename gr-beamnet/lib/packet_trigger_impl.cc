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
#include "packet_trigger_impl.h"

namespace gr {
  namespace beamnet {

    enum trigger_states_t {
      STATE_NOISE,          // No packet detected
      STATE_DETECTED,       // Packet detected and sync
      STATE_PKT             // Packet
    };

    packet_trigger::sptr
    packet_trigger::make(int fft_size, int pkt_size, float thr)
    {
      return gnuradio::get_initial_sptr
        (new packet_trigger_impl(fft_size, pkt_size, thr));
    }

    /*
     * The private constructor
     */
    packet_trigger_impl::packet_trigger_impl(int fft_size, int pkt_size, float thr)
      : gr::block("packet_trigger",
              gr::io_signature::make(2, 2, sizeof(float)),
              gr::io_signature::make(1, 1, sizeof(char))),
        d_fft_size(fft_size),
        d_pkt_size(pkt_size),
        d_thr(thr),
        d_state(STATE_NOISE),
        d_find_trig(false),
        d_detect_offset(0),
        d_pkt_offset(0),
        d_pkt_len(fft_size * pkt_size)
    {}

    /*
     * Our virtual destructor.
     */
    packet_trigger_impl::~packet_trigger_impl()
    {
    }

    void
    packet_trigger_impl::forecast (int noutput_items, gr_vector_int &ninput_items_required)
    {
      /* <+forecast+> e.g. ninput_items_required[0] = noutput_items */
        for (unsigned i = 0; i < ninput_items_required.size(); i++) 
            ninput_items_required[i] = noutput_items + d_pkt_len;
    }

    int
    packet_trigger_impl::general_work (int noutput_items,
                       gr_vector_int &ninput_items,
                       gr_vector_const_void_star &input_items,
                       gr_vector_void_star &output_items)
    {
      // in_ed: Input of the energy detection result
      // in_ss: Input of the symbol sync result
      const float *in_ed = (const float *) input_items[0];
      const float *in_ss = (const float *) input_items[1];
      char *out = (char *) output_items[0];

      size_t block_size = output_signature()->sizeof_stream_item (0);
      memset(out, 0, block_size * noutput_items);
      // If detect the packet start, output 1
      for(unsigned i = 0; i < noutput_items;)
      {
          switch(d_state)
          {
              case STATE_NOISE:

                    if(in_ed[i] > d_thr)
                        d_state = STATE_DETECTED;
                    else
                        i ++;

                    break;
                  
              case STATE_DETECTED:

                    // If the trigger is detected, change to the trigger
                    if(d_find_trig)
                    {
                        i = d_detect_offset;
                        out[i] = 1;

                        d_find_trig = false;
                        d_state = STATE_PKT;
                    }

                    // Find the start of it in the following (d_pkt_len) samples
                    for(unsigned j = 1; j < d_pkt_len; j++)
                        i = (in_ss[i + j] > in_ss[i]) ? (i + j) : i;

                    // If the trigger is in the next stream
                    if(i >= noutput_items)
                    {
                        d_find_trig = true;
                        d_detect_offset = i - noutput_items;
                    }
                    else
                    {
                        out[i] = 1;
                        
                        d_state = STATE_PKT;
                    }
                    break;

              case STATE_PKT:

                    i ++;
                    d_pkt_offset ++;
                    if(d_pkt_offset >= (d_pkt_len -1))
                    {
                        d_pkt_offset = 0;
                        d_state = STATE_NOISE;
                    }
                    break;

              default:
                    throw std::runtime_error("invalid state");
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

