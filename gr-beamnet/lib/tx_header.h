namespace gr {
  namespace beamnet {
    enum tx_states_t {
        STATE_TX_PKT,

        STATE_TX_NULL,
        STATE_TX_SYNC,
        STATE_TX_CE,
        STATE_TX_PD,

        STATE_TX_PD_CS,
        STATE_TX_PD_BF,

        STATE_RX_SYNC

    };
  }
}
