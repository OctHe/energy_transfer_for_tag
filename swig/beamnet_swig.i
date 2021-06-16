/* -*- c++ -*- */

#define BEAMNET_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "beamnet_swig_doc.i"

%{
#include "beamnet/energy_detector.h"
#include "beamnet/symbol_sync.h"
#include "beamnet/packet_extraction.h"
#include "beamnet/source_signal.h"
#include "beamnet/packet_demux.h"
%}



%include "beamnet/energy_detector.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, energy_detector);
%include "beamnet/symbol_sync.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, symbol_sync);
%include "beamnet/packet_extraction.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, packet_extraction);


%include "beamnet/source_signal.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, source_signal);

%include "beamnet/packet_demux.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, packet_demux);
