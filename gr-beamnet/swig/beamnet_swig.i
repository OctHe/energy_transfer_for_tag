/* -*- c++ -*- */

#define BEAMNET_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "beamnet_swig_doc.i"

%{
#include "beamnet/correlation_detector.h"
%}


%include "beamnet/correlation_detector.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, correlation_detector);
