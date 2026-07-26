import java.time.LocalDateTime

object TUI {

    fun init() {
        LCD.init()
        LCD.loadEuroSymbol(0)
        LCD.loadArrowUp(1)
        LCD.loadArrowDown(2)
        KBD.init()
    }

    fun getKey(): Char = KBD.getKey()

    fun waitAnyKey(): Char {
        while (true) {
            val k = KBD.getKey()
            if (k != KBD.none) return k
            Thread.sleep(50)
        }
    }


    fun showWelcome(now: LocalDateTime) {
        LCD.clear()
        LCD.cursor(0, 0)
        LCD.write(center("Comprar Bilhete"))

        val text = "%02d/%02d/%04d %02d:%02d".format(
            now.dayOfMonth,
            now.monthValue,
            now.year,
            now.hour,
            now.minute
        )

        LCD.cursor(1, 0)
        LCD.write(cut16(text))
    }

    fun showStationChoice(stationNumber: Int, stationName: String, oneWayPrice: Int) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center(stationName))

        LCD.cursor(1, 0)
        LCD.write(stationNumber.toString().padStart(2, '0'))
        LCD.writeCharCode(1)
        LCD.writeCharCode(2)

        writeAmountRight(oneWayPrice)
    }

    fun showPaymentScreen(stationName: String, roundTrip: Boolean, remaining: Int) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center(stationName))

        LCD.cursor(1, 0)
        LCD.writeCharCode(1)

        if (roundTrip) {
            LCD.writeCharCode(2)
        }

        writeAmountRight(remaining)
    }

    fun showPrinting() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("A imprimir..."))

        LCD.cursor(1, 0)
        LCD.write(center("Aguarde"))
    }

    fun showCanceledSale() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Venda cancelada"))

        LCD.cursor(1, 0)
        LCD.write(center("Reembolsando..."))
    }

    fun showTicketFor(stationName: String) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Bilhete para"))

        LCD.cursor(1, 0)
        LCD.write(center(stationName))
    }

    fun showTicketReady(stationName: String) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center(stationName))

        LCD.cursor(1, 0)
        LCD.write(center("Retire bilhete"))
    }

    fun showThankYou() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Obrigado!"))

        LCD.cursor(1, 0)
        LCD.write(center("Boa viagem!"))
    }

    fun showMaintenanceMenu(optionText: String) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("MANUTENCAO"))

        LCD.cursor(1, 0)
        LCD.write(cut16(optionText))
    }

    fun showMaintenanceTest(
        stationNumber: Int,
        stationName: String,
        price: Int,
        roundTrip: Boolean
    ) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(cut16("TESTE $stationName"))

        LCD.cursor(1, 0)
        LCD.write(stationNumber.toString().padStart(2, '0'))

        /*
         * Também usa setas, para ficar igual ao modo venda.
         */
        LCD.writeCharCode(1)

        if (roundTrip) {
            LCD.writeCharCode(2)
        }

        writeAmountRight(price)
    }

    fun showTicketCounter(
        stationName: String,
        soldTickets: Int
    ) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(cut16(stationName))

        LCD.cursor(1, 0)
        LCD.write(cut16("Vendidos: $soldTickets"))
    }

    fun showCoinCounter(
        coinValue: Int,
        numberCoins: Int
    ) {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write("Moeda: ")
        LCD.write(amountText(coinValue))
        LCD.writeCharCode(0)

        LCD.cursor(1, 0)
        LCD.write(cut16("Qtd: $numberCoins"))
    }

    fun showResetConfirmation() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Zerar cont.?"))

        LCD.cursor(1, 0)
        LCD.write(center("* confirma"))
    }

    fun showCountersReset() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Contadores"))

        LCD.cursor(1, 0)
        LCD.write(center("zerados"))
    }

    fun showShutdownConfirmation() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Desligar?"))

        LCD.cursor(1, 0)
        LCD.write(center("* confirma"))
    }

    fun showShutdown() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Desligando..."))
        LCD.clear()

    }

    fun showMaintenanceAborted() {
        LCD.clear()

        LCD.cursor(0, 0)
        LCD.write(center("Comando"))

        LCD.cursor(1, 0)
        LCD.write(center("abortado"))
    }

    private fun writeAmountRight(cents: Int) {
        val txt = amountText(cents)
        val start = (LCD.COLS - txt.length - 1).coerceAtLeast(0)

        LCD.cursor(1, start)
        LCD.write(txt)
        LCD.writeCharCode(0)
    }

    private fun amountText(cents: Int): String {
        val euros = cents / 100
        val rest = cents % 100

        return "$euros.${rest.toString().padStart(2, '0')}"
    }

    private fun center(text: String): String {
        val cut = cut16(text)
        val left = ((LCD.COLS - cut.length) / 2).coerceAtLeast(0)

        return " ".repeat(left) + cut
    }

    private fun cut16(text: String): String {
        return if (text.length <= 16) {
            text
        } else {
            text.substring(0, 16)
        }
    }
}