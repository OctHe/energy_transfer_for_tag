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


#ifndef INCLUDED_BEAMNET_SYMBOL_SYNC_H
#define INCLUDED_BEAMNET_SYMBOL_SYNC_H

#include <beamnet/api.h>
#include <gnuradio/block.h>

namespace gr {
  namespace beamnet {

    /*!
     * \brief <+description of block+>
     * \ingroup beamnet
     *
     */
    class BEAMNET_API symbol_sync : virtual public gr::block
    {
     public:
      typedef boost::shared_ptr<symbol_sync> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of beamnet::symbol_sync.
       *
       * To avoid accidental use of raw pointers, beamnet::symbol_sync's
       * constructor is in a private implementation
       * class. beamnet::symbol_sync::make is the public interface for
       * creating new instances.
       */
      static sptr make(int sym_sync, const std::vector<gr_complex> &sync_word);
    };

  } // namespace beamnet
} // namespace gr

#endif /* INCLUDED_BEAMNET_SYMBOL_SYNC_H */

