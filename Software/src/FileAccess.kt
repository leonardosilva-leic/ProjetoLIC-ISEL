import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.io.PrintWriter

object FileAccess {

    fun loadStations(filename: String = "stations.txt"): MutableList<Station> {
        val stations = mutableListOf<Station>()

        val file = File(filename)
        if (!file.exists()) return stations

        BufferedReader(FileReader(file)).use { br ->
            var number = 1

            while (true) {
                val line = br.readLine() ?: break
                val parts = line.split(";")

                if (parts.size >= 3) {
                    val price = parts[0].trim().toInt()
                    val sold = parts[1].trim().toInt()
                    val name = parts[2].trim()
                    if(price == 0 && Common.ORIGIN_ID == -1){
                        Common.ORIGIN_ID = number
                    }

                    stations.add(
                        Station(
                            number = number,
                            name = name,
                            oneWayPrice = price,
                            soldTickets = sold
                        )
                    )

                    number++
                }
            }
        }

        return stations
    }

    fun saveStations(
        stations: List<Station>,
        filename: String = "stations.txt"
    ) {
        PrintWriter(filename).use { out ->
            for (station in stations) {
                out.println("${station.oneWayPrice};${station.soldTickets};${station.name}")
            }
        }
    }

    fun loadCoins(filename: String = "CoinDeposit.txt"): MutableMap<Int, Int> {
        val coins = mutableMapOf(
            5 to 0,
            10 to 0,
            20 to 0,
            50 to 0,
            100 to 0,
            200 to 0,
            500 to 0,
        )

        val file = File(filename)
        if (!file.exists()) return coins

        BufferedReader(FileReader(file)).use { br ->
            while (true) {
                val line = br.readLine() ?: break
                val parts = line.split(";")

                if (parts.size >= 2) {
                    val coinValue = parts[0].trim().toInt()
                    val numberCoins = parts[1].trim().toInt()

                    coins[coinValue] = numberCoins
                }
            }
        }

        return coins
    }

    fun saveCoins(
        coins: Map<Int, Int>,
        filename: String = "CoinDeposit.txt"
    ) {
        PrintWriter(filename).use { out ->
            for (coin in Common.COIN_VALUES) {
                out.println("$coin;${coins[coin] ?: 0}")
            }
        }
    }
}