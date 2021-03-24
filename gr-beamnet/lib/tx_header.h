namespace gr {
  namespace beamnet {
    enum tx_states_t {
        STATE_TX_SYNC,  // TX sync is used for master
        STATE_RX_SYNC,  // RX sync is used for slave

        STATE_TX_PKT,

        STATE_TX_CE,
        STATE_TX_PD,

        STATE_TX_PD_CS,
        STATE_TX_PD_BF

    };
  }
}
