//
//  LocationViewController.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/19.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
class LocationViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取地理定位服务
        let geolocationService = GeolocationService.instance
        
        //定位权限绑定到按钮上(是否可见)
        geolocationService.authorized
            .drive(button.rx.isHidden)
            .disposed(by: disposeBag)
        
        //经纬度信息绑定到label上显示
        geolocationService.location
            .drive(label.rx.coordinates)
            .disposed(by: disposeBag)
        
        //按钮点击
        button.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
    }
    //跳转到应有偏好的设置页面
    private func openAppPreferences() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        } else {
            
        }
    }
}
//UILabel的Rx扩展
extension Reactive where Base: UILabel {
    //实现CLLocationCoordinate2D经纬度信息的绑定显示
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "经度: \(location.longitude)\n纬度: \(location.latitude)"
        }
    }
}

