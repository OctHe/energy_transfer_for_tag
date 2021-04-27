namespace gr {
  namespace beamnet {
    enum rx_sync_states_t {
        STATE_RX_NULL,
        STATE_RX_ED,    // Energy detection
        STATE_RX_DETECTED,
        STATE_RX_PKT,
        STATE_RX_SKIP
    };

    enum rx_states_t {
        STATE_RX_SYNC,
        STATE_RX_CE,
        STATE_RX_PD
    };
  }
}
