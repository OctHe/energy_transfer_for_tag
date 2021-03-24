/* -*- c++ -*- */

#define BEAMNET_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "beamnet_swig_doc.i"

%{
#include "beamnet/correlation_detector.h"
#include "beamnet/time_offset_estimation.h"
#include "beamnet/tx_master.h"
#include "beamnet/energy_detector.h"
#include "beamnet/symbol_sync.h"
#include "beamnet/packet_extraction.h"
#include "beamnet/packet_trigger.h"
#include "beamnet/tx_slave.h"
#include "beamnet/tx_slave_mux.h"
%}


%include "beamnet/correlation_detector.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, correlation_detector);
%include "beamnet/time_offset_estimation.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, time_offset_estimation);

%include "beamnet/tx_master.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, tx_master);

%include "beamnet/energy_detector.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, energy_detector);
%include "beamnet/symbol_sync.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, symbol_sync);
%include "beamnet/packet_extraction.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, packet_extraction);
%include "beamnet/packet_trigger.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, packet_trigger);

%include "beamnet/tx_slave.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, tx_slave);
%include "beamnet/tx_slave_mux.h"
GR_SWIG_BLOCK_MAGIC2(beamnet, tx_slave_mux);
