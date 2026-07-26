data class Station(
    val number: Int,
    val name: String,
    val oneWayPrice: Int,
    var soldTickets: Int
)

object Stations {
    private var stations = mutableListOf<Station>()
    private var selectedIndex = 0

    private var stationDigitBuffer = ""
    private var lastStationDigitTime = 0L

    fun init() {
        stations = FileAccess.loadStations()

        if (stations.isEmpty()) {
            stations = mutableListOf(
                Station(1, "Lisboa", 225, 0)
            )
        }

        selectedIndex = 0
        clearDigitBuffer()
    }

    fun all(): List<Station> {
        return stations
    }

    fun current(): Station {
        return stations[selectedIndex]
    }


    fun resetSelection() {
        selectedIndex = 0
        clearDigitBuffer()
    }

    fun next() {
        selectedIndex = (selectedIndex + 1) % stations.size
        clearDigitBuffer()
    }

    fun previous() {
        selectedIndex =
            if (selectedIndex == 0) {
                stations.lastIndex
            } else {
                selectedIndex - 1
            }

        clearDigitBuffer()
    }

    fun currentOneWayPrice(): Int {
        return current().oneWayPrice
    }

    fun currentTargetPrice(roundTrip: Boolean): Int {
        val base = currentOneWayPrice()
        return if (roundTrip) base * 2 else base
    }

    fun incrementSoldCurrent() {
        current().soldTickets++
    }

    fun resetSoldCounters() {
        for (station in stations) {
            station.soldTickets = 0
        }
    }

    fun save() {
        FileAccess.saveStations(stations)
    }

    fun printerDestinationId(station: Station): Int {
        return (station.number)
    }

    fun selectByDigit(digit: Char): Boolean {
        val now = System.currentTimeMillis()

        if (now - lastStationDigitTime > Common.STATION_DIGIT_TIMEOUT) {
            stationDigitBuffer = ""
        }

        stationDigitBuffer += digit

        if (stationDigitBuffer.length > 2) {
            stationDigitBuffer = stationDigitBuffer.takeLast(2)
        }

        lastStationDigitTime = now

        val stationNumber = stationDigitBuffer.toIntOrNull() ?: return false

        if (stationNumber in 1..stations.size) {
            selectedIndex = stationNumber - 1
            return true
        }

        val lastDigit = digit.toString().toInt()

        if (lastDigit in 1..stations.size) {
            stationDigitBuffer = digit.toString()
            selectedIndex = lastDigit - 1
            return true
        }

        clearDigitBuffer()
        return false
    }

    fun clearDigitBuffer() {
        stationDigitBuffer = ""
        lastStationDigitTime = 0L
    }
}