INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_BEAMNET beamnet)

FIND_PATH(
    BEAMNET_INCLUDE_DIRS
    NAMES beamnet/api.h
    HINTS $ENV{BEAMNET_DIR}/include
        ${PC_BEAMNET_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    BEAMNET_LIBRARIES
    NAMES gnuradio-beamnet
    HINTS $ENV{BEAMNET_DIR}/lib
        ${PC_BEAMNET_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(BEAMNET DEFAULT_MSG BEAMNET_LIBRARIES BEAMNET_INCLUDE_DIRS)
MARK_AS_ADVANCED(BEAMNET_LIBRARIES BEAMNET_INCLUDE_DIRS)

