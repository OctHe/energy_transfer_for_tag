#!/usr/bin/sh
export VOLK_GENERIC=1
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/lib
export PATH=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/build/lib:$PATH
export LD_LIBRARY_PATH=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/build/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$PYTHONPATH
test-beamnet 
