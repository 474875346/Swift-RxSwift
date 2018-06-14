//
//  RxPickerViewController.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/12.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class RxPickerViewController: UIViewController {
    var pickerView:UIPickerView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "滚轮"
        //        PickerData()
        PickerTwoData()
    }
    //MARK : 单行
    func PickerData() -> Void {
        //最简单的pickerView适配器（显示普通文本）
        let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
            components: [],
            numberOfComponents: { _,_,_  in 1 },
            numberOfRowsInComponent: { (_, _, items, _) -> Int in
                return items.count},
            titleForRow: { (_, _, items, row, _) -> String? in
                return items[row]}
        )
        //创建pickerView
        pickerView = UIPickerView()
        self.view.addSubview(pickerView)
        
        //绑定pickerView数据
        Observable.just(["One", "Two", "Tree"])
            .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
            .disposed(by: disposeBag)
        
        //建立一个按钮，触摸按钮时获得选择框被选择的索引
        let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
        button.center = self.view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息",for:.normal)
        //按钮点击响应
        button.rx.tap
            .bind { [weak self] in
                self?.getPickerViewValue()
            }
            .disposed(by: disposeBag)
        self.view.addSubview(button)
    }
    //触摸按钮时，获得被选中的索引
    @objc func getPickerViewValue(){
        let message = String(pickerView.selectedRow(inComponent: 0))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK : 双行
    func PickerTwoData() -> Void {
        let stringPickerAdapter = RxPickerViewStringAdapter<[[String]]>(
            components: [],
            numberOfComponents: { dataSource,pickerView,components  in components.count },
            numberOfRowsInComponent: { (_, _, components, component) -> Int in
                return components[component].count},
            titleForRow: { (_, _, components, row, component) -> String? in
                return components[component][row]}
        )
        //创建pickerView
        pickerView = UIPickerView()
        self.view.addSubview(pickerView)
        //绑定pickerView数据
        Observable.just([["One", "Two", "Tree"],
                         ["A", "B", "C", "D"]])
            .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
            .disposed(by: disposeBag)
        
        //建立一个按钮，触摸按钮时获得选择框被选择的索引
        let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
        button.center = self.view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息",for:.normal)
        //按钮点击响应
        button.rx.tap
            .bind { [weak self] in
                self?.getPickerViewTwoValue()
            }
            .disposed(by: disposeBag)
        self.view.addSubview(button)
    }
    //触摸按钮时，获得被选中的索引
    @objc func getPickerViewTwoValue(){
        let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
            + String(pickerView!.selectedRow(inComponent: 1))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
