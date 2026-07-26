object Maintenance {
    /*
     * Botão/chave de manutenção M.
     *
     * No ficheiro .simul:
     *
     * m.out -> UsbPort.I6
     *
     * Portanto:
     * I6 = 1 shl 6 = 0x40
     */
    private const val M_MASK = 0x40

    fun isActive(): Boolean {
        return HAL.isBit(M_MASK)
    }
}