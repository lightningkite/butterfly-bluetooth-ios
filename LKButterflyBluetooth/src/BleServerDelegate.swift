// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: BleServerDelegate.kt
// Package: com.lightningkite.butterfly.bluetooth
import LKButterfly
import Foundation

public protocol BleServerDelegate: AnyObject, Disposable {
    
    var profile: BleProfileDescription { get }
    
    func onConnect(from: BleDeviceInfo) -> Void 
    func onDisconnect(from: BleDeviceInfo) -> Void 
    func onSubscribe(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Observable<Data> 
    func onRead(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Single<Data> 
    func onWrite(from: BleDeviceInfo, service: UUID, characteristic: UUID, value: Data) -> Single<Unit> 
    
    
    
}

public class BleServerDelegatePerCharacteristic : BleServerDelegate {
    public var services: Map<UUID, Service>
    public init(services: Map<UUID, Service>) {
        self.services = services
        self.profile = BleProfileDescription(services: services.mapValues(transform: { (it) -> BleServiceDescription in BleServiceDescription(debugName: it.value.debugName, primary: it.value.primary, characteristics: it.value.delegates.mapValues(transform: { (it) -> BleCharacteristicDescription in BleCharacteristicDescription(debugName: it.value.debugName, properties: it.value.properties) })) }))
        self.disposed = false
        //Necessary properties should be initialized now
    }
    
    public convenience init(pairs: Pair<UUID, Service>...) {
        self.init(services: pairs.associate(transform: { (it) -> Pair<UUID, BleServerDelegatePerCharacteristic.Service> in it }))
    }
    public let profile: BleProfileDescription
    
    public class Service {
        public var debugName: String
        public var primary: Boolean
        public var delegates: Map<UUID, Delegate>
        public init(debugName: String, primary: Boolean, delegates: Map<UUID, Delegate>) {
            self.debugName = debugName
            self.primary = primary
            self.delegates = delegates
            //Necessary properties should be initialized now
        }
        
        public convenience init(debugName: String, primary: Boolean, pairs: Pair<UUID, Delegate>...) {
            self.init(debugName: debugName, primary: primary, delegates: pairs.associate(transform: { (it) -> Pair<UUID, BleServerDelegatePerCharacteristic.Delegate> in it }))
        }
    }
    
    public protocol Delegate: AnyObject, Disposable {
        
        var debugName: String { get }
        
        var properties: BleCharacteristicProperties { get }
        
        func onConnect(from: BleDeviceInfo) -> Void 
        func onDisconnect(from: BleDeviceInfo) -> Void 
        func onSubscribe(from: BleDeviceInfo) -> Observable<Data> 
        func onRead(from: BleDeviceInfo) -> Single<Data> 
        func onWrite(from: BleDeviceInfo, value: Data) -> Single<Unit> 
    }
    
    
    public func onConnect(from: BleDeviceInfo) -> Void {
        self.services.asSequence().flatMap(transform: { (it) -> Sequence<MapEntry<UUID, BleServerDelegatePerCharacteristic.Delegate>> in it.value.delegates.asSequence() }).forEach(action: { (it) -> Unit in it.value.onConnect(from: from) })
    }
    
    public func onDisconnect(from: BleDeviceInfo) -> Void {
        self.services.asSequence().flatMap(transform: { (it) -> Sequence<MapEntry<UUID, BleServerDelegatePerCharacteristic.Delegate>> in it.value.delegates.asSequence() }).forEach(action: { (it) -> Unit in it.value.onDisconnect(from: from) })
    }
    
    public func onSubscribe(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Observable<Data> {
        return self.services.get(key: service)?.delegates.get(key: characteristic)?.onSubscribe(from: from) ?? Observable.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    public func onRead(from: BleDeviceInfo, service: UUID, characteristic: UUID) -> Single<Data> {
        return self.services.get(key: service)?.delegates.get(key: characteristic)?.onRead(from: from) ?? Single.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    public func onWrite(from: BleDeviceInfo, service: UUID, characteristic: UUID, value: Data) -> Single<Unit> {
        return self.services.get(key: service)?.delegates.get(key: characteristic)?.onWrite(from: from, value: value) ?? Single.error(BleResponseException(value: BleResponseStatus.attributeNotFound))
    }
    
    private var disposed: Boolean
    public func isDisposed() -> Boolean { return self.disposed }
    public func dispose() -> Void {
        self.services.asSequence().flatMap(transform: { (it) -> Sequence<MapEntry<UUID, BleServerDelegatePerCharacteristic.Delegate>> in it.value.delegates.asSequence() }).forEach(action: { (it) -> Unit in it.value.dispose() })
        self.disposed = true
    }
    
    
    public class FromProperty : Delegate {
        public var debugName: String
        public var property: MutableObservableProperty<Data>
        public var properties: BleCharacteristicProperties
        public init(debugName: String, property: MutableObservableProperty<Data>, properties: BleCharacteristicProperties = BleCharacteristicProperties(broadcast: true, read: true, writeWithoutResponse: true, write: true, notify: true, indicate: true)) {
            self.debugName = debugName
            self.property = property
            self.properties = properties
            self.disposed = false
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
        
        public func onWrite(from: BleDeviceInfo, value: Data) -> Single<Unit> {
            self.property.value = value
            return Single.just(Unit.INSTANCE)
        }
        
        private var disposed: Boolean
        public func isDisposed() -> Boolean { return self.disposed }
        public func dispose() -> Void {
            self.disposed = true
        }
    }
}

