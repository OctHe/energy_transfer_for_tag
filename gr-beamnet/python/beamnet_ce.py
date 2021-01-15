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

class beamnet_ce(gr.basic_block):
    """
    docstring for block beamnet_ce
    """
    def __init__(self, fft_size, length, tx_num, tx_ch_index):
        gr.basic_block.__init__(self,
            name="beamnet_ce",
            in_sig=None,
            out_sig=None)

        self.fft_size = fft_size
        self.length = length
        self.tx_num = tx_num
        self.tx_ch_index = tx_ch_index
        
        self.message_port_register_out(pmt.intern('ch_out'))
        self.message_port_register_in(pmt.intern('ch_in'))
        self.set_msg_handler(pmt.intern('ch_in'), self.target_channel)
 
    def target_channel(self, msg):

        ch_t = np.zeros(self.length, dtype=complex)
        for index in range(self.length):
            ch_t[index] = pmt.to_complex(pmt.vector_ref(pmt.cdr(msg), index))

        ch_t = np.reshape(ch_t, (-1, self.fft_size))
        ch_f = np.fft.fftshift(np.fft.fft(ch_t, self.fft_size, 1), 1)

        # 2 channels to calculate CFO
        target_ch_0 = np.zeros([self.tx_num, 2], dtype=complex)
        target_ch_1 = np.zeros([self.tx_num, 2], dtype=complex)
        for index in range(self.tx_num):
            target_ch_0[0, index] = ch_f[0, self.tx_ch_index - (index+1)]
            target_ch_0[1, index] = ch_f[0, self.tx_ch_index + (index+1)]
            target_ch_1[0, index] = ch_f[1, self.tx_ch_index - (index+1)]
            target_ch_1[1, index] = ch_f[1, self.tx_ch_index + (index+1)]
        print(target_ch_0)
        print(target_ch_1)
