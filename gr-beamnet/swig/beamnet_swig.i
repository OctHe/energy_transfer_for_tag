/* -*- c++ -*- */

#define BEAMNET_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "beamnet_swig_doc.i"

%{
#include "beamnet/correlation_detector.h"
#include "beamnet/time_and_freq_offset_estimation.h"
#include "beamnet/signal_generator.h"
%}


%include "beamnet/correlation_detector.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, correlation_detector);
%include "beamnet/time_and_freq_offset_estimation.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, time_and_freq_offset_estimation);
%include "beamnet/signal_generator.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, signal_generator);
