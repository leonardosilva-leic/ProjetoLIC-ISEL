object KBD {
    const val NONE = 0
    val none = NONE.toChar()

    fun init() {
        HAL.init()
        SerialReceiver.init()
    }

    fun getKey(): Char {
        val keyCode = SerialReceiver.rcv()
        if (keyCode == INVALID_KEYCODE) return none

        return when (keyCode) {
            0 -> '1'
            1 -> '4'
            2 -> '7'
            3 -> '*'
            4 -> '2'
            5 -> '5'
            6 -> '8'
            7 -> '0'
            8 -> '3'
            9 -> '6'
            10 -> '9'
            11 -> '#'
            12 -> 'A'
            13 -> 'B'
            14 -> 'C'
            15 -> 'D'
            else -> none
        }
    }

    fun waitKey(timeout: Long): Char {
        val start = System.currentTimeMillis()

        while (System.currentTimeMillis() - start < timeout) {
            val key = getKey()
            if (key != none) return key
        }

        return none
    }
}

fun main() {
    KBD.init()
    while (true) {
        val k = KBD.getKey()
        if (k != KBD.none) {
            println("tecla = $k")
        }
    }
}