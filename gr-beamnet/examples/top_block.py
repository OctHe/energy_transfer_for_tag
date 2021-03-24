#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Wed Mar 24 17:38:09 2021
##################################################


from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import fft
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from optparse import OptionParser
import beamnet
import pmt


class top_block(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")

        ##################################################
        # Variables
        ##################################################
        self.tx = tx = 4
        self.sync_word = sync_word = (0, 0, 0, 0, 0, 1, 0, -1, 0, -1, 0, 1, 0, 0, 0, 0)
        self.samp_rate = samp_rate = 1e6
        self.fft_size = fft_size = 16
        self.en_word = en_word = (0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0)
        self.en_len = en_len = 2

        ##################################################
        # Blocks
        ##################################################
        self.reverse_fft_vxx_1 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.blocks_vector_to_stream_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, samp_rate,True)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, '/home/shiyue_deep/Projects/BeamNet/gr-beamnet/apps/debug_sync_trigger.bin', False)
        self.blocks_file_source_0.set_begin_tag(pmt.PMT_NIL)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/shiyue_deep/Projects/BeamNet/gr-beamnet/apps/debug_slave_signal.bin', False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.beamnet_tx_slave_mux_0 = beamnet.tx_slave_mux(tx, fft_size, 1, 4)
        self.beamnet_tx_slave_0 = beamnet.tx_slave(tx, 1, fft_size, 1, 4)



        ##################################################
        # Connections
        ##################################################
        self.connect((self.beamnet_tx_slave_0, 0), (self.reverse_fft_vxx_1, 0))
        self.connect((self.beamnet_tx_slave_mux_0, 0), (self.blocks_throttle_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.beamnet_tx_slave_mux_0, 1))
        self.connect((self.blocks_throttle_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.blocks_vector_to_stream_0, 0), (self.beamnet_tx_slave_mux_0, 0))
        self.connect((self.reverse_fft_vxx_1, 0), (self.blocks_vector_to_stream_0, 0))

    def get_tx(self):
        return self.tx

    def set_tx(self, tx):
        self.tx = tx

    def get_sync_word(self):
        return self.sync_word

    def set_sync_word(self, sync_word):
        self.sync_word = sync_word

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)

    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size

    def get_en_word(self):
        return self.en_word

    def set_en_word(self, en_word):
        self.en_word = en_word

    def get_en_len(self):
        return self.en_len

    def set_en_len(self, en_len):
        self.en_len = en_len


def main(top_block_cls=top_block, options=None):

    tb = top_block_cls()
    tb.start()
    try:
        raw_input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
