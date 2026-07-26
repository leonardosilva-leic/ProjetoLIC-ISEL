import isel.leic.UsbPort
import isel.leic.utils.Time

object HAL {
    private var outPort = 0

    fun init() {
        outPort = 0
        UsbPort.write(outPort)
    }

    fun readBits(mask: Int): Int {
        return UsbPort.read() and mask
    }

    fun isBit(mask: Int): Boolean {
        return (UsbPort.read() and mask) != 0
    }

    fun setBits(mask: Int) {
        outPort = outPort or mask
        UsbPort.write(outPort)
    }

    fun clrBits(mask: Int) {
        outPort = outPort and mask.inv()
        UsbPort.write(outPort)
    }

    fun writeBits(mask: Int, value: Int) {
        outPort = (outPort and mask.inv()) or (value and mask)
        UsbPort.write(outPort)
    }
}



//fun main(Args: Array<String>){
//    while(true){
//        //    val value = UsbPort.read()
//        //      UsbPort.write(value)
//        println(HAL.readBits(0xFF))
//    }
//}