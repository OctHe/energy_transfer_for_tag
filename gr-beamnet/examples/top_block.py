#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Fri Jan 15 16:03:29 2021
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

from PyQt5 import Qt
from PyQt5 import Qt, QtCore
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import fft
from gnuradio import gr
from gnuradio import qtgui
from gnuradio import uhd
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from optparse import OptionParser
import beamnet
import sip
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
        self.slave_signal_3 = slave_signal_3 = (0, 1, 0, 0, 0, 0, 0, 0, 0, 1)
        self.slave_signal_2 = slave_signal_2 = (0, 0, 1, 0, 0, 0, 0, 0, 1, 0)
        self.slave_signal_1 = slave_signal_1 = (0, 0, 0, 1, 0, 0, 0, 1, 0, 0)
        self.samp_rate = samp_rate = 1e6
        self.master_signal = master_signal = (0, 0, 0, 0, 1, 0, 1, 0, 0, 0)
        self.gain = gain = 68
        self.fft_size = fft_size = 10
        self.center_freq = center_freq = 915e6
        self.bw = bw = 2e6
        self.amp = amp = 0.2
        self.Ntx = Ntx = 4
        self.Np = Np = 200

        ##################################################
        # Blocks
        ##################################################
        self.vector_source_tx_2 = blocks.vector_source_c((1, ) * fft_size, True, fft_size, [])
        self.vector_source_tx_1 = blocks.vector_source_c(slave_signal_2, True, fft_size, [])
        self.vector_source_tx_0_0 = blocks.vector_source_c(slave_signal_3, True, fft_size, [])
        self.vector_source_tx_0 = blocks.vector_source_c(slave_signal_1, True, fft_size, [])
        self.vector_source_tx = blocks.vector_source_c(master_signal, True, fft_size, [])
        self.uhd_usrp_source_0 = uhd.usrp_source(
        	",".join(("serial=30FDE5E", "")),
        	uhd.stream_args(
        		cpu_format="fc32",
        		channels=range(2),
        	),
        )
        self.uhd_usrp_source_0.set_subdev_spec('A:A A:B', 0)
        self.uhd_usrp_source_0.set_samp_rate(samp_rate)
        self.uhd_usrp_source_0.set_time_unknown_pps(uhd.time_spec())
        self.uhd_usrp_source_0.set_center_freq(center_freq, 0)
        self.uhd_usrp_source_0.set_gain(0, 0)
        self.uhd_usrp_source_0.set_antenna('RX2', 0)
        self.uhd_usrp_source_0.set_auto_dc_offset(True, 0)
        self.uhd_usrp_source_0.set_auto_iq_balance(True, 0)
        self.uhd_usrp_source_0.set_center_freq(center_freq, 1)
        self.uhd_usrp_source_0.set_gain(0, 1)
        self.uhd_usrp_source_0.set_antenna('RX2', 1)
        self.uhd_usrp_source_0.set_auto_dc_offset(True, 1)
        self.uhd_usrp_source_0.set_auto_iq_balance(True, 1)
        self.uhd_usrp_sink_1 = uhd.usrp_sink(
        	",".join(("serial=3102765", "")),
        	uhd.stream_args(
        		cpu_format="fc32",
        		channels=range(2),
        	),
        )
        self.uhd_usrp_sink_1.set_subdev_spec('A:A A:B', 0)
        self.uhd_usrp_sink_1.set_samp_rate(samp_rate)
        self.uhd_usrp_sink_1.set_time_unknown_pps(uhd.time_spec())
        self.uhd_usrp_sink_1.set_center_freq(center_freq, 0)
        self.uhd_usrp_sink_1.set_gain(gain, 0)
        self.uhd_usrp_sink_1.set_antenna('TX/RX', 0)
        self.uhd_usrp_sink_1.set_center_freq(center_freq, 1)
        self.uhd_usrp_sink_1.set_gain(gain, 1)
        self.uhd_usrp_sink_1.set_antenna('TX/RX', 1)
        self.uhd_usrp_sink_0 = uhd.usrp_sink(
        	",".join(("serial=30FDE5E", "")),
        	uhd.stream_args(
        		cpu_format="fc32",
        		channels=range(2),
        	),
        )
        self.uhd_usrp_sink_0.set_subdev_spec('A:A A:B', 0)
        self.uhd_usrp_sink_0.set_samp_rate(samp_rate)
        self.uhd_usrp_sink_0.set_time_unknown_pps(uhd.time_spec())
        self.uhd_usrp_sink_0.set_center_freq(center_freq, 0)
        self.uhd_usrp_sink_0.set_gain(gain, 0)
        self.uhd_usrp_sink_0.set_antenna('TX/RX', 0)
        self.uhd_usrp_sink_0.set_center_freq(center_freq, 1)
        self.uhd_usrp_sink_0.set_gain(gain, 1)
        self.uhd_usrp_sink_0.set_antenna('TX/RX', 1)
        self.reverse_fft_vxx_1_1 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.reverse_fft_vxx_1_0_0_0 = fft.fft_vcc(fft_size, True, (()), True, 1)
        self.reverse_fft_vxx_1_0_0 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.reverse_fft_vxx_1_0 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.reverse_fft_vxx_1 = fft.fft_vcc(fft_size, False, (()), True, 1)
        self.qtgui_time_sink_x_0 = qtgui.time_sink_c(
        	fft_size, #size
        	samp_rate, #samp_rate
        	"", #name
        	1 #number of inputs
        )
        self.qtgui_time_sink_x_0.set_update_time(0.10)
        self.qtgui_time_sink_x_0.set_y_axis(-1, 1)

        self.qtgui_time_sink_x_0.set_y_label('Amplitude', "")

        self.qtgui_time_sink_x_0.enable_tags(-1, True)
        self.qtgui_time_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, qtgui.TRIG_SLOPE_POS, 0.0, 0, 0, "")
        self.qtgui_time_sink_x_0.enable_autoscale(True)
        self.qtgui_time_sink_x_0.enable_grid(False)
        self.qtgui_time_sink_x_0.enable_axis_labels(True)
        self.qtgui_time_sink_x_0.enable_control_panel(False)
        self.qtgui_time_sink_x_0.enable_stem_plot(False)

        if not True:
          self.qtgui_time_sink_x_0.disable_legend()

        labels = ['', '', '', '', '',
                  '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
                  "magenta", "yellow", "dark red", "dark green", "blue"]
        styles = [1, 1, 1, 1, 1,
                  1, 1, 1, 1, 1]
        markers = [-1, -1, -1, -1, -1,
                   -1, -1, -1, -1, -1]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0, 1.0]

        for i in xrange(2):
            if len(labels[i]) == 0:
                if(i % 2 == 0):
                    self.qtgui_time_sink_x_0.set_line_label(i, "Re{{Data {0}}}".format(i/2))
                else:
                    self.qtgui_time_sink_x_0.set_line_label(i, "Im{{Data {0}}}".format(i/2))
            else:
                self.qtgui_time_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_time_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_time_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_time_sink_x_0.set_line_style(i, styles[i])
            self.qtgui_time_sink_x_0.set_line_marker(i, markers[i])
            self.qtgui_time_sink_x_0.set_line_alpha(i, alphas[i])

        self._qtgui_time_sink_x_0_win = sip.wrapinstance(self.qtgui_time_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_time_sink_x_0_win)
        self.blocks_vector_to_stream_0_0_0_1 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_vector_to_stream_0_0_0_0_1 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_vector_to_stream_0_0_0_0_0_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_vector_to_stream_0_0_0_0_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_vector_to_stream_0_0_0_0 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_stream_to_vector_0 = blocks.stream_to_vector(gr.sizeof_gr_complex*1, fft_size)
        self.blocks_null_sink_0 = blocks.null_sink(gr.sizeof_gr_complex*1)
        self.blocks_multiply_const_vxx_0_1 = blocks.multiply_const_vcc((amp, ))
        self.blocks_multiply_const_vxx_0_0_0 = blocks.multiply_const_vcc((amp, ))
        self.blocks_multiply_const_vxx_0_0 = blocks.multiply_const_vcc((amp, ))
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vcc((amp, ))
        self.beamnet_time_and_freq_offset_estimation_0 = beamnet.time_and_freq_offset_estimation(samp_rate, fft_size, Ntx, 10e6)
        self.beamnet_signal_generator_0 = beamnet.signal_generator(samp_rate, fft_size, 3)



        ##################################################
        # Connections
        ##################################################
        self.msg_connect((self.beamnet_time_and_freq_offset_estimation_0, 'freq_sync'), (self.beamnet_signal_generator_0, 'freq_cal'))
        self.connect((self.beamnet_signal_generator_0, 0), (self.blocks_vector_to_stream_0_0_0_0_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.uhd_usrp_sink_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_0, 0), (self.uhd_usrp_sink_0, 1))
        self.connect((self.blocks_multiply_const_vxx_0_0_0, 0), (self.uhd_usrp_sink_1, 1))
        self.connect((self.blocks_multiply_const_vxx_0_1, 0), (self.uhd_usrp_sink_1, 0))
        self.connect((self.blocks_stream_to_vector_0, 0), (self.reverse_fft_vxx_1_0_0_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_0, 0), (self.blocks_multiply_const_vxx_0_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_0_0, 0), (self.blocks_multiply_const_vxx_0_0_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_0_0_0, 0), (self.qtgui_time_sink_x_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_0_1, 0), (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.blocks_vector_to_stream_0_0_0_1, 0), (self.blocks_multiply_const_vxx_0_1, 0))
        self.connect((self.reverse_fft_vxx_1, 0), (self.blocks_vector_to_stream_0_0_0_0_1, 0))
        self.connect((self.reverse_fft_vxx_1_0, 0), (self.blocks_vector_to_stream_0_0_0_0, 0))
        self.connect((self.reverse_fft_vxx_1_0_0, 0), (self.beamnet_signal_generator_0, 0))
        self.connect((self.reverse_fft_vxx_1_0_0_0, 0), (self.beamnet_time_and_freq_offset_estimation_0, 0))
        self.connect((self.reverse_fft_vxx_1_0_0_0, 0), (self.blocks_vector_to_stream_0_0_0_0_0_0, 0))
        self.connect((self.reverse_fft_vxx_1_1, 0), (self.blocks_vector_to_stream_0_0_0_1, 0))
        self.connect((self.uhd_usrp_source_0, 1), (self.blocks_null_sink_0, 0))
        self.connect((self.uhd_usrp_source_0, 0), (self.blocks_stream_to_vector_0, 0))
        self.connect((self.vector_source_tx, 0), (self.reverse_fft_vxx_1, 0))
        self.connect((self.vector_source_tx_0, 0), (self.reverse_fft_vxx_1_0, 0))
        self.connect((self.vector_source_tx_0_0, 0), (self.reverse_fft_vxx_1_0_0, 0))
        self.connect((self.vector_source_tx_1, 0), (self.reverse_fft_vxx_1_1, 0))
        self.connect((self.vector_source_tx_2, 0), (self.beamnet_signal_generator_0, 1))

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_slave_signal_3(self):
        return self.slave_signal_3

    def set_slave_signal_3(self, slave_signal_3):
        self.slave_signal_3 = slave_signal_3
        self.vector_source_tx_0_0.set_data(self.slave_signal_3, [])

    def get_slave_signal_2(self):
        return self.slave_signal_2

    def set_slave_signal_2(self, slave_signal_2):
        self.slave_signal_2 = slave_signal_2
        self.vector_source_tx_1.set_data(self.slave_signal_2, [])

    def get_slave_signal_1(self):
        return self.slave_signal_1

    def set_slave_signal_1(self, slave_signal_1):
        self.slave_signal_1 = slave_signal_1
        self.vector_source_tx_0.set_data(self.slave_signal_1, [])

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.uhd_usrp_source_0.set_samp_rate(self.samp_rate)
        self.uhd_usrp_sink_1.set_samp_rate(self.samp_rate)
        self.uhd_usrp_sink_0.set_samp_rate(self.samp_rate)
        self.qtgui_time_sink_x_0.set_samp_rate(self.samp_rate)

    def get_master_signal(self):
        return self.master_signal

    def set_master_signal(self, master_signal):
        self.master_signal = master_signal
        self.vector_source_tx.set_data(self.master_signal, [])

    def get_gain(self):
        return self.gain

    def set_gain(self, gain):
        self.gain = gain
        self.uhd_usrp_sink_1.set_gain(self.gain, 0)

        self.uhd_usrp_sink_1.set_gain(self.gain, 1)

        self.uhd_usrp_sink_0.set_gain(self.gain, 0)

        self.uhd_usrp_sink_0.set_gain(self.gain, 1)


    def get_fft_size(self):
        return self.fft_size

    def set_fft_size(self, fft_size):
        self.fft_size = fft_size
        self.vector_source_tx_2.set_data((1, ) * self.fft_size, [])

    def get_center_freq(self):
        return self.center_freq

    def set_center_freq(self, center_freq):
        self.center_freq = center_freq
        self.uhd_usrp_source_0.set_center_freq(self.center_freq, 0)
        self.uhd_usrp_source_0.set_center_freq(self.center_freq, 1)
        self.uhd_usrp_sink_1.set_center_freq(self.center_freq, 0)
        self.uhd_usrp_sink_1.set_center_freq(self.center_freq, 1)
        self.uhd_usrp_sink_0.set_center_freq(self.center_freq, 0)
        self.uhd_usrp_sink_0.set_center_freq(self.center_freq, 1)

    def get_bw(self):
        return self.bw

    def set_bw(self, bw):
        self.bw = bw

    def get_amp(self):
        return self.amp

    def set_amp(self, amp):
        self.amp = amp
        self.blocks_multiply_const_vxx_0_1.set_k((self.amp, ))
        self.blocks_multiply_const_vxx_0_0_0.set_k((self.amp, ))
        self.blocks_multiply_const_vxx_0_0.set_k((self.amp, ))
        self.blocks_multiply_const_vxx_0.set_k((self.amp, ))

    def get_Ntx(self):
        return self.Ntx

    def set_Ntx(self, Ntx):
        self.Ntx = Ntx

    def get_Np(self):
        return self.Np

    def set_Np(self, Np):
        self.Np = Np


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
