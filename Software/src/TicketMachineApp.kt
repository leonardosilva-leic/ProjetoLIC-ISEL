import java.time.LocalDateTime

object TicketMachineApp {

    private enum class State {
        WELCOME,
        CHOOSE_STATION,
        PAYMENT,
        PRINTING,
        WAIT_TICKET_COLLECTION,
        THANK_YOU
    }

    private var state = State.WELCOME
    private var roundTrip = false
    private var remainingPrice = 0
    private var paidAmount = 0

    private var maintenanceTicketIndex = 0
    private var maintenanceCoinIndex = 0

    private var maintenanceMenuIndex = 0
    private var lastMaintenanceMenuChange = 0L

    fun start() {
        HAL.init()
        CoinAcceptor.init()
        TD.init()
        TUI.init()

        Stations.init()
        CoinDeposit.init()

        state = State.WELCOME
        run()
    }

    private fun run() {
        while (true) {
            if (Maintenance.isActive()) {
                runMaintenanceMode()
            }

            when (state) {
                State.WELCOME -> runWelcome()
                State.CHOOSE_STATION -> runChooseStation()
                State.PAYMENT -> runPayment()
                State.PRINTING -> runPrinting()
                State.WAIT_TICKET_COLLECTION -> runWaitTicketCollection()
                State.THANK_YOU -> runThankYou()
            }

            Thread.sleep(10)
        }
    }

    private fun runWelcome() {
        var lastShownMinute = -1

        while (state == State.WELCOME) {
            if (Maintenance.isActive()) {
                return
            }

            val now = LocalDateTime.now()

            if (now.minute != lastShownMinute) {
                TUI.showWelcome(now)
                lastShownMinute = now.minute
            }

            val key = TUI.getKey()

            if (key != KBD.none) {
                state = State.CHOOSE_STATION
                drawStationChoice()
                return
            }

            Thread.sleep(20)
        }
    }

    private fun runChooseStation() {
        val key = TUI.getKey()
        if (key == KBD.none) return

        when (key) {
            'A' -> {
                Stations.previous()
                drawStationChoice()
            }

            'B' -> {
                Stations.next()
                drawStationChoice()
            }

            in '0'..'9' -> {
                if (Stations.selectByDigit(key)) {
                    drawStationChoice()
                }
            }

            '#' -> {
                Stations.clearDigitBuffer()
                roundTrip = false
                paidAmount = 0
                CoinDeposit.clearInsertedCoins()
                remainingPrice = Stations.currentOneWayPrice()
                state = State.PAYMENT
                drawPayment()
            }
        }
    }

    private fun runPayment() {
        val key = TUI.getKey()

        if (key != KBD.none) {
            when (key) {
                '*' -> {
                    roundTrip = !roundTrip
                    remainingPrice = Stations.currentTargetPrice(roundTrip) - paidAmount

                    if (remainingPrice < 0) {
                        remainingPrice = 0
                    }

                    drawPayment()
                    return
                }

                '#' -> {
                    if (paidAmount > 0) {
                        CoinAcceptor.ejectCoins()
                        paidAmount = 0
                        CoinDeposit.clearInsertedCoins()
                        remainingPrice = Stations.currentTargetPrice(roundTrip)
                        TUI.showCanceledSale()
                        Thread.sleep(2000)
                    }

                    state = State.WELCOME
                    return
                }
            }
        }

        val coin = CoinAcceptor.getCoinValue()

        if (coin != null) {
            CoinAcceptor.acceptCoin()
            waitCoinRemoval()

            CoinDeposit.addInsertedCoin(coin)

            paidAmount += coin
            remainingPrice = Stations.currentTargetPrice(roundTrip) - paidAmount

            if (remainingPrice < 0) {
                remainingPrice = 0
            }

            drawPayment()

            if (remainingPrice == 0) {
                state = State.PRINTING
            }
        }
    }

    private fun runPrinting() {
        val station = Stations.current()

        TUI.showTicketFor(station.name)
        Thread.sleep(2000)

        TUI.showPrinting()

        TD.activatePrintingTicket(
            roundTrip = roundTrip,
            origin = Common.ORIGIN_ID,
            destination = Stations.printerDestinationId(station)
        )

        CoinAcceptor.collectCoins()

        CoinDeposit.collectInsertedCoins()
        Stations.incrementSoldCurrent()

        Stations.save()
        CoinDeposit.save()

        state = State.WAIT_TICKET_COLLECTION
    }

    private fun runWaitTicketCollection() {
        val station = Stations.current()

        TUI.showTicketReady(station.name)

        while (!TD.isFinished()) {
            Thread.sleep(20)
        }

        TD.deactivatePrintingTicket()

        state = State.THANK_YOU
    }

    private fun runThankYou() {
        TUI.showThankYou()
        Thread.sleep(5000)

        paidAmount = 0
        remainingPrice = 0
        roundTrip = false
        CoinDeposit.clearInsertedCoins()

        state = State.WELCOME
    }

    private fun runMaintenanceMode() {
        maintenanceMenuIndex = 0
        lastMaintenanceMenuChange = 0L

        updateMaintenanceMenu()

        while (Maintenance.isActive()) {
            updateMaintenanceMenu()

            val key = waitMaintenanceKey(100)

            if (!Maintenance.isActive()) {
                break
            }

            when (key) {
                KBD.none -> {
                    // menu continua alternando
                }

                '#' -> {
                    runMaintenanceTest()
                    resetMaintenanceMenu()
                }

                'A' -> {
                    maintenanceTicketIndex = 0
                    showTicketCounters()
                    resetMaintenanceMenu()
                }

                'B' -> {
                    maintenanceCoinIndex = 0
                    showCoinCounters()
                    resetMaintenanceMenu()
                }

                'C' -> {
                    confirmResetCounters()
                    resetMaintenanceMenu()
                }

                'D' -> {
                    confirmShutdown()
                    resetMaintenanceMenu()
                }
            }

            Thread.sleep(20)
        }

        state = State.WELCOME
        paidAmount = 0
        remainingPrice = 0
        roundTrip = false
        CoinDeposit.clearInsertedCoins()

        TUI.showWelcome(LocalDateTime.now())
    }

    private fun resetMaintenanceMenu() {
        maintenanceMenuIndex = 0
        lastMaintenanceMenuChange = 0L
        updateMaintenanceMenu()
    }

    private fun runMaintenanceTest() {
        Stations.resetSelection()
        roundTrip = false

        drawMaintenanceTestChoice()

        while (Maintenance.isActive()) {
            val key = waitMaintenanceKey(5000)

            if (!Maintenance.isActive()) {
                return
            }

            when (key) {
                KBD.none -> {
                    TUI.showMaintenanceAborted()
                    Thread.sleep(1500)
                    return
                }

                'A' -> {
                    Stations.previous()
                    drawMaintenanceTestChoice()
                }

                'B' -> {
                    Stations.next()
                    drawMaintenanceTestChoice()
                }

                '*' -> {
                    roundTrip = !roundTrip
                    drawMaintenanceTestChoice()
                }

                '#' -> {
                    val station = Stations.current()

                    TUI.showPrinting()

                    TD.activatePrintingTicket(
                        roundTrip = roundTrip,
                        origin = Common.ORIGIN_ID,
                        destination = Stations.printerDestinationId(station)
                    )

                    TUI.showTicketReady(station.name)

                    while (Maintenance.isActive() && !TD.isFinished()) {
                        Thread.sleep(20)
                    }

                    TD.deactivatePrintingTicket()

                    return
                }
            }
        }
    }

    private fun updateMaintenanceMenu() {
        val now = System.currentTimeMillis()

        if (now - lastMaintenanceMenuChange >= Common.MAINTENANCE_MENU_DELAY) {
            TUI.showMaintenanceMenu(
                Common.MAINTENANCE_MENU_OPTIONS[maintenanceMenuIndex]
            )

            maintenanceMenuIndex =
                (maintenanceMenuIndex + 1) % Common.MAINTENANCE_MENU_OPTIONS.size

            lastMaintenanceMenuChange = now
        }
    }

    private fun drawMaintenanceTestChoice() {
        val station = Stations.current()

        TUI.showMaintenanceTest(
            stationNumber = station.number,
            stationName = station.name,
            price = Stations.currentTargetPrice(roundTrip),
            roundTrip = roundTrip
        )
    }

    private fun showTicketCounters() {
        val stations = Stations.all()

        if (stations.isEmpty()) return

        while (Maintenance.isActive()) {
            val station = stations[maintenanceTicketIndex]

            TUI.showTicketCounter(
                stationName = station.name,
                soldTickets = station.soldTickets
            )

            val key = waitMaintenanceKey(5000)

            if (!Maintenance.isActive()) {
                return
            }

            when (key) {
                KBD.none -> return

                'A' -> {
                    maintenanceTicketIndex =
                        if (maintenanceTicketIndex == 0) {
                            stations.lastIndex
                        } else {
                            maintenanceTicketIndex - 1
                        }
                }

                'B' -> {
                    maintenanceTicketIndex =
                        (maintenanceTicketIndex + 1) % stations.size
                }

                '#' -> return
            }
        }
    }

    private fun showCoinCounters() {
        val coinValues = Common.COIN_VALUES

        while (Maintenance.isActive()) {
            val coin = coinValues[maintenanceCoinIndex]
            val count = CoinDeposit.getCoinCount(coin)

            TUI.showCoinCounter(
                coinValue = coin,
                numberCoins = count
            )

            val key = waitMaintenanceKey(5000)

            if (!Maintenance.isActive()) {
                return
            }

            when (key) {
                KBD.none -> return

                'A' -> {
                    maintenanceCoinIndex =
                        if (maintenanceCoinIndex == 0) {
                            coinValues.lastIndex
                        } else {
                            maintenanceCoinIndex - 1
                        }
                }

                'B' -> {
                    maintenanceCoinIndex =
                        (maintenanceCoinIndex + 1) % coinValues.size
                }

                '#' -> return
            }
        }
    }

    private fun confirmResetCounters() {
        TUI.showResetConfirmation()

        val key = waitMaintenanceKey(5000)

        if (!Maintenance.isActive()) {
            return
        }

        if (key == '*') {
            Stations.resetSoldCounters()
            CoinDeposit.resetCounters()

            Stations.save()
            CoinDeposit.save()

            TUI.showCountersReset()
            Thread.sleep(2000)
        } else {
            TUI.showMaintenanceAborted()
            Thread.sleep(1500)
        }
    }

    private fun confirmShutdown() {
        TUI.showShutdownConfirmation()

        val key = waitMaintenanceKey(5000)

        if (!Maintenance.isActive()) {
            return
        }

        if (key == '*') {
            Stations.save()
            CoinDeposit.save()

            TUI.showShutdown()
            Thread.sleep(2000)

            kotlin.system.exitProcess(0)
        } else {
            TUI.showMaintenanceAborted()
            Thread.sleep(1500)
        }
    }

    private fun waitMaintenanceKey(timeout: Long): Char {
        val endTime = System.currentTimeMillis() + timeout

        while (Maintenance.isActive() && System.currentTimeMillis() < endTime) {
            val key = KBD.getKey()

            if (key != KBD.none) {
                return key
            }

            Thread.sleep(20)
        }

        return KBD.none
    }

    private fun drawStationChoice() {
        val s = Stations.current()

        TUI.showStationChoice(
            stationNumber = s.number,
            stationName = s.name,
            oneWayPrice = s.oneWayPrice
        )
    }

    private fun drawPayment() {
        TUI.showPaymentScreen(
            stationName = Stations.current().name,
            roundTrip = roundTrip,
            remaining = remainingPrice
        )
    }

    private fun waitCoinRemoval() {
        while (CoinAcceptor.hasCoin()) {
            Thread.sleep(20)
        }
    }
}

fun main() {
    TicketMachineApp.start()
}