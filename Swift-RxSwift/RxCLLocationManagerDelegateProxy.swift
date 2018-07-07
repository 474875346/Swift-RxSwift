//
//  RxCLLocationManagerDelegateProxy.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/19.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
extension CLLocationManager : HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}
public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager,CLLocationManagerDelegate> ,DelegateProxyType,CLLocationManagerDelegate{
    public static func registerKnownImplementations() {
        self.register {RxCLLocationManagerDelegateProxy(locationManager: $0)}
    }
    
    public init(locationManager : CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    
    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}
