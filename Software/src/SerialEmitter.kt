import isel.leic.utils.Time

object SerialEmitter {
    enum class Peripheral { LCD, TICKET }

    private const val SDX_MASK = 0x01       // O0
    private const val SCLK_MASK = 0x02      // O1
    private const val LCDSEL_MASK = 0x04    // O2
    private const val TICKETSEL_MASK = 0x08 // O3

    fun init() {
        HAL.clrBits(SDX_MASK)
        HAL.clrBits(SCLK_MASK)
        HAL.setBits(LCDSEL_MASK)
        HAL.setBits(TICKETSEL_MASK)
    }

    fun send(addr: Peripheral, data: Int) {
        when (addr) {
            Peripheral.LCD -> sendLCD(data)
            Peripheral.TICKET -> sendTicket(data)
        }
    }

    private fun sendLCD(data: Int) {
        HAL.setBits(LCDSEL_MASK)
        HAL.clrBits(SCLK_MASK)

        HAL.clrBits(LCDSEL_MASK)

        for (i in 0..9) {
            HAL.clrBits(SCLK_MASK)

            val bit = (data shr i) and 1

            if (bit == 1) {
                HAL.setBits(SDX_MASK)
            } else {
                HAL.clrBits(SDX_MASK)
            }

            HAL.setBits(SCLK_MASK)
        }

        HAL.clrBits(SCLK_MASK)
        HAL.setBits(LCDSEL_MASK)
    }

    private fun sendTicket(data: Int) {
        HAL.setBits(TICKETSEL_MASK)
        HAL.clrBits(SCLK_MASK)

        HAL.clrBits(TICKETSEL_MASK)

        for (i in 0..9) {
            HAL.clrBits(SCLK_MASK)

            val bit = (data shr i) and 1

            if (bit == 1) {
                HAL.setBits(SDX_MASK)
            } else {
                HAL.clrBits(SDX_MASK)
            }

            HAL.setBits(SCLK_MASK)
        }

        HAL.clrBits(SCLK_MASK)
        HAL.setBits(TICKETSEL_MASK)
    }

    fun isBusy(): Boolean = false
}