//
//  RxURLSessionViewController.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/13.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class RxURLSessionViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        URLSessionSuccess()
//        URLSessionFailure()
    }
    //MARK : 请求成功
    func URLSessionSuccess() -> Void {
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.response(request: request).subscribe(onNext: {
            (response, data) in
            //数据处理
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("返回的数据是：", str ?? "")
        }).disposed(by: disposeBag)
    }
    //MARK : 请求失败
    func URLSessionFailure() -> Void {
        //创建URL对象
        let urlString = "https://www.douban.com/xxxxxxxxxx/app/radio/channels"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        //创建并发起请求
        URLSession.shared.rx.response(request: request).subscribe(onNext: {
            (response, data) in
            //判断响应结果状态码
            if 200 ..< 300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：", str ?? "")
            }else{
                print("请求失败！")
            }
        }).disposed(by: disposeBag)
    }
    //MARK : 请求成功转换json
    func URLSessionModel() -> Void {
        
    }
}
