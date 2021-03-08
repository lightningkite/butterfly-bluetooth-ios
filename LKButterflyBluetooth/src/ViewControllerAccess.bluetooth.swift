import RxSwift
import LKButterfly

public extension ViewControllerAccess {
    var ble: Single<RxBleClient> {
        fatalError("TODO")
    }
    func bleServer(
         delegate: BleServerDelegate,
         advertisingIntensity: Float = 0.5
    ) -> BleServer {
        fatalError("TODO")
    }
}
