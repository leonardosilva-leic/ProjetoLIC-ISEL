import isel.leic.utils.Time

object LCD {
    const val LINES = 2
    const val COLS = 16

    private const val FUNCTION_SET = 0x38
    private const val DISPLAY_ON = 0x0C
    private const val ENTRY_MODE = 0x06
    private const val CLEAR_DISPLAY = 0x01
    private const val SET_DDRAM = 0x80

    private fun writeByteSerial(rs: Boolean, data: Int) {
        val rsBit = if (rs) 1 else 0

        val frameEnable = (1 shl 9) or ((data and 0xFF) shl 1) or rsBit
        val frameDisable = ((data and 0xFF) shl 1) or rsBit

        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frameEnable)
        SerialEmitter.send(SerialEmitter.Peripheral.LCD, frameDisable)
    }

    private fun writeByte(rs: Boolean, data: Int) {
        writeByteSerial(rs, data)
    }

    private fun writeCMD(data: Int) {
        writeByte(false, data)
    }

    private fun writeDATA(data: Int) {
        writeByte(true, data)
    }

    fun init() {
        SerialEmitter.init()

        Time.sleep(50)
        writeCMD(0x30)
        Time.sleep(5)
        writeCMD(0x30)
        Time.sleep(1)
        writeCMD(0x30)
        Time.sleep(1)

        writeCMD(FUNCTION_SET)
        writeCMD(DISPLAY_ON)
        writeCMD(ENTRY_MODE)
        clear()
    }

    fun write(c: Char) {
        writeDATA(c.code)
    }

    fun write(text: String) {
        for (c in text) write(c)
    }

    fun cursor(line: Int, column: Int) {
        if (line !in 0 until LINES) return
        if (column !in 0 until COLS) return

        val address = if (line == 0) column else 0x40 + column
        writeCMD(SET_DDRAM or address)
    }

    fun clear() {
        writeCMD(CLEAR_DISPLAY)
        Time.sleep(2)
    }

    private const val SET_CGRAM = 0x40

    fun createChar(location: Int, pattern: IntArray) {
        val loc = location and 0x7   // só 0..7

        writeCMD(SET_CGRAM or (loc shl 3))

        for (i in 0 until 8) {
            writeDATA(pattern[i] and 0x1F)
        }
    }

    fun writeCharCode(code: Int) {
        writeDATA(code and 0xFF)
    }

    fun loadEuroSymbol(location: Int = 0) {
        val euro = intArrayOf(
            0b01110,
            0b10001,
            0b11100,
            0b10000,
            0b11100,
            0b10001,
            0b01110,
            0b00000
        )
        createChar(location, euro)
    }

    fun loadArrowUp(location: Int = 1) {
        LCD.createChar(
            location,
            intArrayOf(
                0b00100,
                0b01110,
                0b10101,
                0b00100,
                0b00100,
                0b00100,
                0b00100,
                0b00000
            )
        )
    }

    fun loadArrowDown(location: Int = 2) {
        LCD.createChar(
            location,
            intArrayOf(
                0b00100,
                0b00100,
                0b00100,
                0b00100,
                0b10101,
                0b01110,
                0b00100,
                0b00000
            )
        )
    }
}

fun main() {
    LCD.init()
    LCD.loadEuroSymbol(0)
    LCD.cursor(0, 0)
    LCD.write("Retire o bilhete")
    LCD.cursor(1, 0)
    LCD.write("4,00")
    LCD.writeCharCode(0)
}