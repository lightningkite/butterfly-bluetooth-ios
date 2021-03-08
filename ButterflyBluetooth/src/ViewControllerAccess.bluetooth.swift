import LKButterfly
import RxSwift

public extension ViewControllerAccess {
    var ble: Single<RxBleClient> {
        return Single.error(IllegalStateException("Not supported yet"))
    }
    func bleServer(
         delegate: BleServerDelegate,
         advertisingIntensity: Float = 0.5
     ): BleServer
}