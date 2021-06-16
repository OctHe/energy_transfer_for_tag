#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Wed Jun 16 20:50:17 2021
##################################################

from distutils.version import StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from PyQt5 import Qt, QtCore
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser
import beamnet
import numpy as np
import pmt
import sys
from gnuradio import qtgui


class top_block(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Top Block")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.restoreGeometry(self.settings.value("geometry", type=QtCore.QByteArray))


        ##################################################
        # Variables
        ##################################################
        self.tx = tx = 2
        self.pkt_interval = pkt_interval = 1
        self.pd_len = pd_len = 197
        self.fft_size = fft_size = 16
        self.thr = thr = 1e-7
        self.sync_word = sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0]
        self.samp_rate = samp_rate = 1e6
        self.pkt_size = pkt_size = fft_size * (1 + tx + pd_len)
        self.interval_size = interval_size = pkt_interval * fft_size

        ##################################################
        # Blocks
        ##################################################
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, samp_rate,True)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_gr_complex*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_tag_reflection.bin', False)
        self.blocks_file_source_0.set_begin_tag(pmt.PMT_NIL)
        self.blocks_file_sink_2 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_tag_pkt.bin', False)
        self.blocks_file_sink_2.set_unbuffered(False)
        self.blocks_file_sink_1 = blocks.file_sink(gr.sizeof_float*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_sync_symbol.bin', False)
        self.blocks_file_sink_1.set_unbuffered(False)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_float*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_sync_nrg.bin', False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.beamnet_symbol_sync_0 = beamnet.symbol_sync(fft_size, np.fft.ifft(np.fft.fftshift(sync_word)))
        self.beamnet_packet_extraction_0 = beamnet.packet_extraction(samp_rate, fft_size, pkt_size + interval_size, thr)
        self.beamnet_energy_detector_0 = beamnet.energy_detector(fft_size)



        ##################################################
        # Connections
        ##################################################
        self.connect((self.beamnet_energy_detector_0, 0), (self.beamnet_packet_extraction_0, 1))
        self.connect((self.beamnet_energy_detector_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.beamnet_packet_extraction_0, 0), (self.blocks_file_sink_2, 0))
        self.connect((self.beamnet_symbol_sync_0, 0), (self.beamnet_packet_extraction_0, 2))
        self.connect((self.beamnet_symbol_sync_0, 0), (self.blocks_file_sink_1, 0))
        self.connect((self.blocks_file_source_0, 0), (self.blocks_throttle_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.beamnet_energy_detector_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.beamnet_packet_extraction_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.beamnet_symbol_sync_0, 0))

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_tx(self):
        return self.tx

    def set_tx(self, tx):
        self.tx = tx
        self.set_pkt_size(self.fft_size * (1 + self.tx + self.pd_len))

    def get_pkt_interval(self):
        return self.pkt_interval

    def set_pkt_interval(self, pkt_interval):
        self.pkt_interval = pkt_interval
        self.set_interval_size(self.pkt_interval * self.fft_size)

    def get_pd_len(self):
        return self.pd_len

    def set_pd_len(self, pd_len):
        self.pd_len = pd_len
        self.set_pkt_size(self.fft_size * (1 + self.tx + self.pd_len))

    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size
        self.set_pkt_size(self.fft_size * (1 + self.tx + self.pd_len))
        self.set_interval_size(self.pkt_interval * self.fft_size)

    def get_thr(self):
        return self.thr

    def set_thr(self, thr):
        self.thr = thr

    def get_sync_word(self):
        return self.sync_word

    def set_sync_word(self, sync_word):
        self.sync_word = sync_word

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)

    def get_pkt_size(self):
        return self.pkt_size

    def set_pkt_size(self, pkt_size):
        self.pkt_size = pkt_size

    def get_interval_size(self):
        return self.interval_size

    def set_interval_size(self, interval_size):
        self.interval_size = interval_size


def main(top_block_cls=top_block, options=None):

    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()
    tb.start()
    tb.show()

    def quitting():
        tb.stop()
        tb.wait()
    qapp.aboutToQuit.connect(quitting)
    qapp.exec_()


if __name__ == '__main__':
    main()
