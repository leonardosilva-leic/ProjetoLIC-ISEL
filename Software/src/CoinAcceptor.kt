object CoinAcceptor {
    private const val COIN_MASK = 0x08      // I3
    private const val CID_MASK = 0x07       // I0..I2

    private const val ACCEPT_MASK = 0x10    // O4
    private const val EJECT_MASK = 0x20     // O5
    private const val COLLECT_MASK = 0x40   // O6

    fun init() {
        HAL.clrBits(ACCEPT_MASK or EJECT_MASK or COLLECT_MASK)
    }

    fun hasCoin(): Boolean {
        return HAL.isBit(COIN_MASK)
    }

    fun getCoinValue(): Int? {
        if (!hasCoin()) return null

        return when (HAL.readBits(CID_MASK)) {
            0 -> 5
            1 -> 10
            2 -> 20
            3 -> 50
            4 -> 100
            5 -> 200
            6 -> 500
            else -> null
        }
    }

    fun acceptCoin() {
        HAL.setBits(ACCEPT_MASK)
        Thread.sleep(200)
        HAL.clrBits(ACCEPT_MASK)
    }

    fun ejectCoins() {
        HAL.setBits(EJECT_MASK)
        Thread.sleep(2000)
        HAL.clrBits(EJECT_MASK)
    }

    fun collectCoins() {
        HAL.setBits(COLLECT_MASK)
        Thread.sleep(2000)
        HAL.clrBits(COLLECT_MASK)
    }
}

//fun main() {
//    CoinAcceptor.init()
//
//    while (true) {
//        val value = CoinAcceptor.getCoinValue()
//        if (value != null) {
//            println("Moeda detectada : $value cent")
//            CoinAcceptor.acceptCoin()
//        }
//        Thread.sleep(100)
//    }
//}