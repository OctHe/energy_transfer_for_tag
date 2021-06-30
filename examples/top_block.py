#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Tue Jun 29 16:25:57 2021
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
from gnuradio import fft
from gnuradio import gr
from gnuradio import uhd
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from optparse import OptionParser
import beamnet
import numpy as np
import sys
import time
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
        self.sym_sync = sym_sync = 4
        self.sym_pd = sym_pd = 194
        self.work_mode = work_mode = 3
        self.win_size = win_size = 320
        self.thr = thr = 1e-7
        self.tag = tag = 1
        self.sync_word = sync_word = (0, 0, -0.7485-0.6631j, 0.8855+0.4647j, 0.5681-0.8230j, 0.8855-0.4647j, -0.3546+0.9350j, 1, 0, -0.3546+0.9350j, 0.8855-0.4647j, 0.5681-0.8230j, 0.8855+0.4647j, -0.7485-0.6631j, -0.9709+0.2393j, 0)
        self.sym_pkt = sym_pkt = sym_sync + tx + sym_pd
        self.sig_coeff = sig_coeff = 0.5
        self.samp_rate = samp_rate = 1e6
        self.power_gain_tx = power_gain_tx = 60
        self.power_gain_rx = power_gain_rx = 0
        self.fft_size = fft_size = 16
        self.center_freq_tx = center_freq_tx = 915e6
        self.center_freq_rx = center_freq_rx = 919e6

        ##################################################
        # Blocks
        ##################################################
        self.uhd_usrp_source_0 = uhd.usrp_source(
        	",".join(("serial=320F337", "")),
        	uhd.stream_args(
        		cpu_format="fc32",
        		channels=range(2),
        	),
        )
        self.uhd_usrp_source_0.set_clock_source('external', 0)
        self.uhd_usrp_source_0.set_time_source('external', 0)
        self.uhd_usrp_source_0.set_subdev_spec('A:A A:B', 0)
        self.uhd_usrp_source_0.set_samp_rate(samp_rate)
        self.uhd_usrp_source_0.set_time_unknown_pps(uhd.time_spec())
        self.uhd_usrp_source_0.set_center_freq(center_freq_rx, 0)
        self.uhd_usrp_source_0.set_gain(0, 0)
        self.uhd_usrp_source_0.set_antenna('RX2', 0)
        self.uhd_usrp_source_0.set_bandwidth(samp_rate, 0)
        self.uhd_usrp_source_0.set_auto_dc_offset(True, 0)
        self.uhd_usrp_source_0.set_auto_iq_balance(True, 0)
        self.uhd_usrp_source_0.set_center_freq(center_freq_rx, 1)
        self.uhd_usrp_source_0.set_gain(0, 1)
        self.uhd_usrp_source_0.set_antenna('RX2', 1)
        self.uhd_usrp_source_0.set_bandwidth(samp_rate, 1)
        self.uhd_usrp_source_0.set_auto_dc_offset(True, 1)
        self.uhd_usrp_source_0.set_auto_iq_balance(True, 1)
        self.uhd_usrp_sink_0 = uhd.usrp_sink(
        	",".join(("serial=320F337", "")),
        	uhd.stream_args(
        		cpu_format="fc32",
        		channels=range(2),
        	),
        )
        self.uhd_usrp_sink_0.set_clock_source('external', 0)
        self.uhd_usrp_sink_0.set_time_source('external', 0)
        self.uhd_usrp_sink_0.set_subdev_spec('A:A A:B', 0)
        self.uhd_usrp_sink_0.set_samp_rate(samp_rate)
        self.uhd_usrp_sink_0.set_center_freq(center_freq_tx, 0)
        self.uhd_usrp_sink_0.set_gain(power_gain_tx, 0)
        self.uhd_usrp_sink_0.set_antenna('TX/RX', 0)
        self.uhd_usrp_sink_0.set_bandwidth(samp_rate, 0)
        self.uhd_usrp_sink_0.set_center_freq(center_freq_tx, 1)
        self.uhd_usrp_sink_0.set_gain(power_gain_tx, 1)
        self.uhd_usrp_sink_0.set_antenna('TX/RX', 1)
        self.uhd_usrp_sink_0.set_bandwidth(samp_rate, 1)
        self.reverse_fft_vxx_1_0 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.reverse_fft_vxx_1 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.blocks_vector_to_stream_0_0_0_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_vector_to_stream_0_0_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_null_sink_0 = blocks.null_sink(gr.sizeof_gr_complex*1)
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_vcc((sig_coeff, ))
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vcc((sig_coeff, ))
        self.blocks_file_sink_3 = blocks.file_sink(gr.sizeof_gr_complex*fft_size, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_tag_pkt.bin', False)
        self.blocks_file_sink_3.set_unbuffered(False)
        self.blocks_file_sink_2 = blocks.file_sink(gr.sizeof_float*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_sync_symbol.bin', False)
        self.blocks_file_sink_2.set_unbuffered(False)
        self.blocks_file_sink_1 = blocks.file_sink(gr.sizeof_float*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_sync_nrg.bin', False)
        self.blocks_file_sink_1.set_unbuffered(False)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_gr_complex*1, '/home/shiyue_deep/Projects/gr-beamnet/apps/debug_tag_reflection.bin', False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.beamnet_symbol_sync_0 = beamnet.symbol_sync(sym_sync, np.fft.ifft(np.fft.fftshift(sync_word)))
        self.beamnet_source_signal_1 = beamnet.source_signal(tx, 1, fft_size, sym_sync, sym_pd, sync_word, work_mode)
        self.beamnet_source_signal_0 = beamnet.source_signal(tx, 0, fft_size, sym_sync, sym_pd, sync_word, work_mode)
        self.beamnet_phase_alignment_0 = beamnet.phase_alignment(fft_size, tx, tag, 1000)
        self.beamnet_packet_extraction_0 = beamnet.packet_extraction(samp_rate, fft_size, sym_pkt, win_size + sym_pkt * fft_size, thr, 0.1)
        self.beamnet_packet_demux_0 = beamnet.packet_demux(tx, fft_size, sym_sync, sym_pd)
        self.beamnet_energy_detector_0 = beamnet.energy_detector(win_size)



        ##################################################
        # Connections
        ##################################################
        self.msg_connect((self.beamnet_packet_demux_0, 'ce'), (self.beamnet_phase_alignment_0, 'ce'))
        self.msg_connect((self.beamnet_phase_alignment_0, 'phase'), (self.beamnet_source_signal_0, 'phase'))
        self.msg_connect((self.beamnet_phase_alignment_0, 'phase'), (self.beamnet_source_signal_1, 'phase'))
        self.connect((self.beamnet_energy_detector_0, 0), (self.beamnet_packet_extraction_0, 1))
        self.connect((self.beamnet_energy_detector_0, 0), (self.blocks_file_sink_1, 0))
        self.connect((self.beamnet_packet_extraction_0, 0), (self.beamnet_packet_demux_0, 0))
        self.connect((self.beamnet_packet_extraction_0, 0), (self.blocks_file_sink_3, 0))
        self.connect((self.beamnet_source_signal_0, 0), (self.reverse_fft_vxx_1, 0))
        self.connect((self.beamnet_source_signal_1, 0), (self.reverse_fft_vxx_1_0, 0))
        self.connect((self.beamnet_symbol_sync_0, 0), (self.beamnet_packet_extraction_0, 2))
        self.connect((self.beamnet_symbol_sync_0, 0), (self.blocks_file_sink_2, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.uhd_usrp_sink_0, 0))
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.uhd_usrp_sink_0, 1))
        self.connect((self.blocks_vector_to_stream_0_0_0, 0), (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_0, 0), (self.blocks_multiply_const_vxx_1, 0))
        self.connect((self.reverse_fft_vxx_1, 0), (self.blocks_vector_to_stream_0_0_0, 0))
        self.connect((self.reverse_fft_vxx_1_0, 0), (self.blocks_vector_to_stream_0_0_0_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.beamnet_energy_detector_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.beamnet_packet_extraction_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.beamnet_symbol_sync_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.uhd_usrp_source_0, 1), (self.blocks_null_sink_0, 0))

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_tx(self):
        return self.tx

    def set_tx(self, tx):
        self.tx = tx
        self.set_sym_pkt(self.sym_sync + self.tx + self.sym_pd)

    def get_sym_sync(self):
        return self.sym_sync

    def set_sym_sync(self, sym_sync):
        self.sym_sync = sym_sync
        self.set_sym_pkt(self.sym_sync + self.tx + self.sym_pd)

    def get_sym_pd(self):
        return self.sym_pd

    def set_sym_pd(self, sym_pd):
        self.sym_pd = sym_pd
        self.set_sym_pkt(self.sym_sync + self.tx + self.sym_pd)

    def get_work_mode(self):
        return self.work_mode

    def set_work_mode(self, work_mode):
        self.work_mode = work_mode

    def get_win_size(self):
        return self.win_size

    def set_win_size(self, win_size):
        self.win_size = win_size

    def get_thr(self):
        return self.thr

    def set_thr(self, thr):
        self.thr = thr

    def get_tag(self):
        return self.tag

    def set_tag(self, tag):
        self.tag = tag

    def get_sync_word(self):
        return self.sync_word

    def set_sync_word(self, sync_word):
        self.sync_word = sync_word

    def get_sym_pkt(self):
        return self.sym_pkt

    def set_sym_pkt(self, sym_pkt):
        self.sym_pkt = sym_pkt

    def get_sig_coeff(self):
        return self.sig_coeff

    def set_sig_coeff(self, sig_coeff):
        self.sig_coeff = sig_coeff
        self.blocks_multiply_const_vxx_1.set_k((self.sig_coeff, ))
        self.blocks_multiply_const_vxx_0.set_k((self.sig_coeff, ))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.uhd_usrp_source_0.set_samp_rate(self.samp_rate)
        self.uhd_usrp_source_0.set_bandwidth(self.samp_rate, 0)
        self.uhd_usrp_source_0.set_bandwidth(self.samp_rate, 1)
        self.uhd_usrp_sink_0.set_samp_rate(self.samp_rate)
        self.uhd_usrp_sink_0.set_bandwidth(self.samp_rate, 0)
        self.uhd_usrp_sink_0.set_bandwidth(self.samp_rate, 1)

    def get_power_gain_tx(self):
        return self.power_gain_tx

    def set_power_gain_tx(self, power_gain_tx):
        self.power_gain_tx = power_gain_tx
        self.uhd_usrp_sink_0.set_gain(self.power_gain_tx, 0)

        self.uhd_usrp_sink_0.set_gain(self.power_gain_tx, 1)


    def get_power_gain_rx(self):
        return self.power_gain_rx

    def set_power_gain_rx(self, power_gain_rx):
        self.power_gain_rx = power_gain_rx

    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size

    def get_center_freq_tx(self):
        return self.center_freq_tx

    def set_center_freq_tx(self, center_freq_tx):
        self.center_freq_tx = center_freq_tx
        self.uhd_usrp_sink_0.set_center_freq(self.center_freq_tx, 0)
        self.uhd_usrp_sink_0.set_center_freq(self.center_freq_tx, 1)

    def get_center_freq_rx(self):
        return self.center_freq_rx

    def set_center_freq_rx(self, center_freq_rx):
        self.center_freq_rx = center_freq_rx
        self.uhd_usrp_source_0.set_center_freq(self.center_freq_rx, 0)
        self.uhd_usrp_source_0.set_center_freq(self.center_freq_rx, 1)


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
