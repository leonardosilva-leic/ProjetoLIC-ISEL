object TD {
    private const val FN_MASK = 0x10   // I4

    private var lastRoundTrip = false
    private var lastOrigin = 0
    private var lastDestination = 0

    fun init() {
        SerialEmitter.init()
    }

    fun activatePrintingTicket(roundTrip: Boolean, origin: Int, destination: Int) {
        lastRoundTrip = roundTrip
        lastOrigin = origin and 0x0F
        lastDestination = destination and 0x0F

        sendTicketFrame(prt = true)
    }

    fun deactivatePrintingTicket() {
        sendTicketFrame(prt = false)
    }

    fun isFinished(): Boolean {
        return HAL.isBit(FN_MASK)
    }

    private fun sendTicketFrame(prt: Boolean) {
        val rt = if (lastRoundTrip) 1 else 0
        val prtBit = if (prt) 1 else 0

        val data =
            rt or
                    (lastDestination shl 5) or
                    (lastOrigin shl 1) or
                    (prtBit shl 9)

        SerialEmitter.send(SerialEmitter.Peripheral.TICKET, data)
    }
}