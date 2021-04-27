#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Copyright 2021 gr-beamnet author.
# 
# This is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this software; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
# 

import numpy as np
from gnuradio import gr
import pmt

class phase_alignment(gr.sync_block):
    """
    docstring for block phase_alignment
    """
    def __init__(self, tx, tag):
        gr.sync_block.__init__(self,
            name="phase_alignment",
            in_sig=None,
            out_sig=None)

        self.tx = tx
        self.tag = tag

        # Inverse of the ce_word matrix
        if tx == 2:
            self.ce_word_inv = np.array([[1./2, 1./2], [1./2, -1./2]])
        elif tx == 4:
            pass

        self.ce_word_rx = np.zeros([tag, tx], dtype = complex)
        self.ch = np.zeros([tag, tx], dtype = complex)
        self.phase = np.zeros([tx, 1], dtype = float)

        self.pkt_num = 0

        self.message_port_register_in(pmt.intern('ce'))
        self.message_port_register_out(pmt.intern('phase'))
        self.set_msg_handler(pmt.intern('ce'), self.ce_and_pa)

    def ce_and_pa(self, msg):

        # Packet counter
        self.pkt_num = self.pkt_num + 1

        if(self.pkt_num <= self.tag):

            # Channel collection
            for tx_index in range(self.tx):
                self.ce_word_rx[self.pkt_num -1][tx_index] = pmt.to_complex(pmt.vector_ref(pmt.cdr(msg), tx_index))

            if(self.pkt_num == self.tag):

                # Channel estimation
                self.ch = np.dot(self.ce_word_rx, self.ce_word_inv)
                for tag_index in range(self.tag):
                    self.ch[tag_index] = self.ch[tag_index] / self.ch[tag_index][0] * np.abs(self.ch[tag_index][0])

                # Phase alignment
                self.phase = self.iterative_phase_alignment(1000, 0.01)

                #  Phase alignment for 1 tag
                if(self.tag == 1):
                    phase_1 = np.zeros([self.tx, 1], dtype = float)
                    for tx_index in range(self.tx):
                        phase_1[tx_index] = - np.angle(self.ch[0][tx_index]) / 2 / np.pi

                    print("The ideal phase for the 1-tag case: ")
                    print(phase_1)
                    print("The result of iterative phase alignment: ")
                    print(self.phase)

                # Message passing
                msg_vec = pmt.make_f32vector(self.tx, 0)
                for tx_index in range(self.tx):
                    pmt.f32vector_set(msg_vec, tx_index, self.phase[tx_index][0])

                msg_pair = pmt.cons(pmt.make_dict(), msg_vec)
                self.message_port_pub(pmt.intern("phase"), msg_pair)

        else:

            # Channel update
            pass
            # Phase alignment

            # Message passing


    def iterative_phase_alignment(self, Nloop, Ndelta):

        phase_now = np.zeros([self.tx, 1], dtype = float)
        phase_max = np.zeros([self.tx, 1], dtype = float)
        power_max = 0

        for ite_index in range(Nloop):

            # Generate random phase
            phase_delta = Ndelta * np.random.rand(self.tx, 1)
            phase_now = phase_now + phase_delta

            bf_weight = np.exp(1j * 2 * np.pi * phase_now)
            
            # Power comparison
            power_now = np.min(np.abs(np.dot(self.ch, bf_weight))**2)

            if power_now > power_max:
                power_max = power_now
                phase_max = phase_now
            else:
                phase_now = phase_max

        phase_now = phase_now - phase_now[0]

        return phase_now
