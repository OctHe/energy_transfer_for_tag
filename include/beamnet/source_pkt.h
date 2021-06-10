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


#ifndef INCLUDED_BEAMNET_SOURCE_PKT_H
#define INCLUDED_BEAMNET_SOURCE_PKT_H

#include <beamnet/api.h>
#include <gnuradio/sync_block.h>

namespace gr {
  namespace beamnet {

    /*!
     * \brief <+description of block+>
     * \ingroup beamnet
     *
     */
    class BEAMNET_API source_pkt : virtual public gr::sync_block
    {
     public:
      typedef boost::shared_ptr<source_pkt> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of beamnet::source_pkt.
       *
       * To avoid accidental use of raw pointers, beamnet::source_pkt's
       * constructor is in a private implementation
       * class. beamnet::source_pkt::make is the public interface for
       * creating new instances.
       */
      static sptr make(int tx, int index, int fft_size, int hd_len, int pd_len, const std::vector<gr_complex> &sync_word, int baseline);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_SOURCE_PKT_H */

