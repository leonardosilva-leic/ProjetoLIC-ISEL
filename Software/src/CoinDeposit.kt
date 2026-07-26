object CoinDeposit {
    private var coinCounters = mutableMapOf<Int, Int>()
    private val insertedCoins = mutableListOf<Int>()

    fun init() {
        coinCounters = FileAccess.loadCoins()
    }

    fun addInsertedCoin(coin: Int) {
        insertedCoins.add(coin)
    }

    fun collectInsertedCoins() {
        for (coin in insertedCoins) {
            coinCounters[coin] = (coinCounters[coin] ?: 0) + 1
        }

        insertedCoins.clear()
    }

    fun clearInsertedCoins() {
        insertedCoins.clear()
    }

    fun getCoinCount(coin: Int): Int {
        return coinCounters[coin] ?: 0
    }

    fun resetCounters() {
        for (coin in Common.COIN_VALUES) {
            coinCounters[coin] = 0
        }
    }

    fun save() {
        FileAccess.saveCoins(coinCounters)
    }
}