#!/usr/bin/sh
export VOLK_GENERIC=1
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/python
export PATH=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/build/python:$PATH
export LD_LIBRARY_PATH=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/build/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/home/shiyue_deep/Projects/BeamNet/gr-beamnet/build/swig:$PYTHONPATH
/usr/bin/python2 /home/shiyue_deep/Projects/BeamNet/gr-beamnet/python/qa_correlation_detector.py 
