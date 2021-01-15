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
#include <gnuradio/expj.h>
#include "signal_generator_impl.h"

#define GR_M_PI 3.1415926
#define GR_M_TWOPI (2*GR_M_PI)

namespace gr {
  namespace beamnet {


    enum signal_generator_states
    {
        STATE_CHANNEL_ESTIMATION,
        STATE_BEAMFORMING
    };

    signal_generator::sptr
    signal_generator::make(float samp_rate, int fft_size, int tx_index)
    {
      return gnuradio::get_initial_sptr
        (new signal_generator_impl(samp_rate, fft_size, tx_index));
    }

    /*
     * The private constructor
     */
    signal_generator_impl::signal_generator_impl(float samp_rate, int fft_size, int tx_index)
      : gr::sync_block("signal_generator",
              gr::io_signature::make(2, 2, fft_size * sizeof(gr_complex)),
              gr::io_signature::make(1, 1, fft_size * sizeof(gr_complex))),
              d_samp_rate(samp_rate),
              d_fft_size(fft_size),
              d_tx_index(tx_index),
              d_freq_offset(0),
              d_phase_offset(0),
              d_time_offset(0),
              d_samp_offset(0),
              d_state(STATE_CHANNEL_ESTIMATION)
    {

        message_port_register_in(pmt::mp("time_cal"));
        set_msg_handler(pmt::mp("time_cal"),
            boost::bind(&signal_generator_impl::set_time_offset, this, _1));
        message_port_register_in(pmt::mp("freq_cal"));
        set_msg_handler(pmt::mp("freq_cal"),
            boost::bind(&signal_generator_impl::set_freq_offset, this, _1));
    }

    /*
     * Our virtual destructor.
     */
    signal_generator_impl::~signal_generator_impl()
    {
    }

    int
    signal_generator_impl::work(int noutput_items,
        gr_vector_const_void_star &input_items,
        gr_vector_void_star &output_items)
    {
      const gr_complex *in_ce = (const gr_complex *) input_items[0];
      const gr_complex *in_bf = (const gr_complex *) input_items[1];
      gr_complex *out = (gr_complex *) output_items[0];

      // Do <+signal processing+>
        switch(d_state)
        {
            case STATE_CHANNEL_ESTIMATION:
                for(int i = 0; i < noutput_items * d_fft_size; i++)
                {
                    d_phase_offset = d_phase_offset - d_freq_offset / d_samp_rate;
                    out[i] = in_ce[i] * gr_expj(GR_M_TWOPI * d_phase_offset);
                }
                break;

            case STATE_BEAMFORMING:
                memcpy(out, in_bf, noutput_items * d_fft_size);                
                break;

            default:
                break;
        }
      
      // Tell runtime system how many output items we produced.
      return noutput_items;
    }
    
    void signal_generator_impl::set_time_offset(pmt::pmt_t msg)
    {
    }

    void signal_generator_impl::set_freq_offset(pmt::pmt_t msg)
    {
        float new_freq_offset = pmt::to_float(pmt::vector_ref(msg, d_tx_index));

        d_freq_offset = d_freq_offset + new_freq_offset;
        std::cout << d_freq_offset << " " << new_freq_offset << std::endl;


    }
  } /* namespace beamnet */
} /* namespace gr */

