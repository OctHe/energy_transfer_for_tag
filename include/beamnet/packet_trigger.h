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


#ifndef INCLUDED_BEAMNET_PACKET_TRIGGER_H
#define INCLUDED_BEAMNET_PACKET_TRIGGER_H

#include <beamnet/api.h>
#include <gnuradio/block.h>

namespace gr {
  namespace beamnet {

    /*!
     * \brief <+description of block+>
     * \ingroup beamnet
     *
     */
    class BEAMNET_API packet_trigger : virtual public gr::block
    {
     public:
      typedef boost::shared_ptr<packet_trigger> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of beamnet::packet_trigger.
       *
       * To avoid accidental use of raw pointers, beamnet::packet_trigger's
       * constructor is in a private implementation
       * class. beamnet::packet_trigger::make is the public interface for
       * creating new instances.
       */
      static sptr make(int fft_size, int pkt_size, float thr);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_PACKET_TRIGGER_H */

