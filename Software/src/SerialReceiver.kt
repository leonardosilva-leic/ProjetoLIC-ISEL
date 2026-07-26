import isel.leic.utils.Time

const val INVALID_KEYCODE = -1

object SerialReceiver {

    private const val RXD_MASK = 0x80    // I7
    private const val RXCLK_MASK = 0x80  // O7

    private const val HALF_CLOCK_MS = 2L
    private const val SAMPLE_DELAY_MS = 2L
    private const val FRAME_END_DELAY_MS = 2L

    fun init() {
        HAL.clrBits(RXCLK_MASK)
    }

    fun rcv(): Int {
        // sem trama
        if (HAL.isBit(RXD_MASK)) return INVALID_KEYCODE

        // pequena espera para garantir start estável
        Time.sleep(SAMPLE_DELAY_MS)

        // clock 1: deve dar 1
        pulseClock()
        Time.sleep(SAMPLE_DELAY_MS)
        if (!HAL.isBit(RXD_MASK)) return INVALID_KEYCODE

        // clocks 2..5: K0..K3
        var keyCode = 0
        for (i in 0..3) {
            pulseClock()
            Time.sleep(SAMPLE_DELAY_MS)

            if (HAL.isBit(RXD_MASK)) {
                keyCode = keyCode or (1 shl i)
            }
        }

        // clock 6: deve dar 0
        pulseClock()
        Time.sleep(SAMPLE_DELAY_MS)
        if (HAL.isBit(RXD_MASK)) return INVALID_KEYCODE

        // clock 7: deve dar 1
        pulseClock()
        Time.sleep(SAMPLE_DELAY_MS)

        return keyCode
    }

    private fun pulseClock() {
        HAL.setBits(RXCLK_MASK)
        Time.sleep(HALF_CLOCK_MS)
        HAL.clrBits(RXCLK_MASK)
        Time.sleep(HALF_CLOCK_MS)
    }
}