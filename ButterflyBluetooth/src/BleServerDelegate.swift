// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: BleServerDelegate.kt
// Package: com.lightningkite.butterfly.bluetooth
import RxSwift
import Foundation
import LKButterfly

public protocol BleServerDelegate: AnyObject, Disposable {
    
    var profile: BleProfileDescription { get }
    
    func onConnect(from: BleDeviceInfo) -> Void 
    func onDisconnect(from: BleDeviceInfo) -> Void 
    func onSubscribe(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Observable<Data> 
    func onRead(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Single<Data> 
    func onWrite(from: BleDeviceInfo, service: UUID, characteristic: UUID, value: Data) -> Single<Void> 
    
    
    
}

public class BleServerDelegatePerCharacteristic : AbstractDisposable, BleServerDelegate {
    public var services: Dictionary<UUID, Service>
    public init(services: Dictionary<UUID, Service>) {
        self.services = services
        self.profile = BleProfileDescription(services: services.mapValuesFromPairs({ (it) -> BleServiceDescription in BleServiceDescription(debugName: it.value.debugName, primary: it.value.primary, characteristics: it.value.delegates.mapValuesFromPairs({ (it) -> BleCharacteristicDescription in BleCharacteristicDescription(debugName: it.value.debugName, properties: it.value.properties) })) }))
        super.init()
        //Necessary properties should be initialized now
    }
    
    public convenience init(pairs: Pair<UUID, Service>...) {
        self.init(services: Dictionary(pairs.map({ (it) -> Pair<UUID, BleServerDelegatePerCharacteristic.Service> in it }), uniquingKeysWith: { (a, _) in a }))
    }
    public let profile: BleProfileDescription
    
    public class Service {
        public var debugName: String
        public var primary: Bool
        public var delegates: Dictionary<UUID, BleServerDelegatePerCharacteristicDelegate>
        public init(debugName: String, primary: Bool, delegates: Dictionary<UUID, BleServerDelegatePerCharacteristicDelegate>) {
            self.debugName = debugName
            self.primary = primary
            self.delegates = delegates
            //Necessary properties should be initialized now
        }
        
        public convenience init(debugName: String, primary: Bool, pairs: Pair<UUID, BleServerDelegatePerCharacteristicDelegate>...) {
            self.init(debugName: debugName, primary: primary, delegates: Dictionary(pairs.map({ (it) -> Pair<UUID, BleServerDelegatePerCharacteristicDelegate> in it }), uniquingKeysWith: { (a, _) in a }))
        }
    }
    
    
    
    public func onConnect(from: BleDeviceInfo) -> Void {
        self.services.lazy.flatMap({ (it) in it.value.delegates.lazy }).forEach({ (it) -> Void in it.value.onConnect(from: from) })
    }
    
    public func onDisconnect(from: BleDeviceInfo) -> Void {
        self.services.lazy.flatMap({ (it) in it.value.delegates.lazy }).forEach({ (it) -> Void in it.value.onDisconnect(from: from) })
    }
    
    public func onSubscribe(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Observable<Data> {
        return (self.services[service]?.delegates).flatMap { temp16 in temp16[characteristic] }?.onSubscribe(from: from) ?? Observable.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    public func onRead(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Single<Data> {
        return (self.services[service]?.delegates).flatMap { temp18 in temp18[characteristic] }?.onRead(from: from) ?? Single.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    public func onWrite(from: BleDeviceInfo, service: UUID, characteristic: UUID, value: Data) -> Single<Void> {
        return (self.services[service]?.delegates).flatMap { temp20 in temp20[characteristic] }?.onWrite(from: from, value: value) ?? Single.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    override public func onDispose() -> Void {
        self.services.lazy.flatMap({ (it) in it.value.delegates.lazy }).forEach({ (it) -> Void in it.value.dispose() })
    }
    
    public class FromProperty : AbstractDisposable, BleServerDelegatePerCharacteristicDelegate {
        public var debugName: String
        public var property: MutableObservableProperty<Data>
        public var properties: BleCharacteristicProperties
        public init(debugName: String, property: MutableObservableProperty<Data>, properties: BleCharacteristicProperties = BleCharacteristicProperties(broadcast: true, read: true, writeWithoutResponse: true, write: true, notify: true, indicate: true)) {
            self.debugName = debugName
            self.property = property
            self.properties = properties
            super.init()
            //Necessary properties should be initialized now
        }
        
        public func onConnect(from: BleDeviceInfo) -> Void {}
        public func onDisconnect(from: BleDeviceInfo) -> Void {}
        public func onSubscribe(from: BleDeviceInfo) -> Observable<Data> {
            return self.property.observableNN
        }
        
        public func onRead(from: BleDeviceInfo) -> Single<Data> {
            return Single.just(self.property.value)
        }
        
        public func onWrite(from: BleDeviceInfo, value: Data) -> Single<Void> {
            self.property.value = value
            return Single.just(())
        }
        
        override public func onDispose() -> Void {}
    }
}
public protocol BleServerDelegatePerCharacteristicDelegate: AnyObject, Disposable {
    
    var debugName: String { get }
    
    var properties: BleCharacteristicProperties { get }
    
    func onConnect(from: BleDeviceInfo) -> Void 
    func onDisconnect(from: BleDeviceInfo) -> Void 
    func onSubscribe(from: BleDeviceInfo) -> Observable<Data> 
    func onRead(from: BleDeviceInfo) -> Single<Data> 
    func onWrite(from: BleDeviceInfo, value: Data) -> Single<Void> 
}


