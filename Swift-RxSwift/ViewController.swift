//
//  ViewController.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/5.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        ListeningTextfield()
        //        ListeningTextfieldBind()
        //        MoreListeningTextfield()
        //        ListeningcontrolEvent()
        //        ListeningTwoControlEvent()
        //        ListeningControlEventTextView()
//        topBtn()
//        BtnBindTitle()
//        BtnBindattributedTitle()
//        BtnBindImg()
        btnisSelected()
    }
}
extension ViewController {
    // MARK:监听单个 textField 内容的变化
    func ListeningTextfield() -> Void {
        let textfield = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 30))
        textfield.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(textfield)
        textfield
            .rx
            .text
            .orEmpty//可选值转换成String
            .subscribe(onNext: {
                print("您输入的\($0)")
            }).disposed(by: disposeBag)
    }
    //MARK:textfield内容绑定另一个textfield上label显示字数
    func ListeningTextfieldBind() -> Void {
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        //创建文本输出框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        //创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:300, height:30))
        self.view.addSubview(label)
        
        //创建按钮
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        //当文本框内容改变
        let input = inputField.rx.text.orEmpty.asDriver()//将普通序列转换为 Driver
            .throttle(0.3)//在主线程中操作，0.3秒内值若多次改变，取最后一次
        //内容绑定到另一个输入框中
        input.drive(outputField.rx.text)
            .disposed(by: disposeBag)
        //内容绑定到文本标签中
        input.map {
            return "当前字数\($0.count)"
            }.drive(label.rx.text)
            .disposed(by: disposeBag)
        //根据内容字数决定按钮是否可用
        input.map {
            return $0.count > 5
            }.drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    //MARK:同时监听多个 textField 内容的变化
    func MoreListeningTextfield() -> Void {
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        //创建文本输入框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        //创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:300, height:30))
        self.view.addSubview(label)
        Observable.combineLatest(inputField.rx.text.orEmpty, outputField.rx.text.orEmpty) { (textValue1, textValue2) -> String in
            return "你输入的号码是：\(textValue1)-\(textValue2)"
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    //MARK:事件监听
    func ListeningcontrolEvent() -> Void {
        /*
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         */
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        inputField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                print("开始编辑内容!")
            }).disposed(by: disposeBag)
    }
    //MARK:双文本框第一响应
    func ListeningTwoControlEvent() -> Void {
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        //创建文本输入框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        inputField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { () in
                outputField.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        outputField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { () in
                outputField.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    //MARK:textview监听状态
    func ListeningControlEventTextView() -> Void {
        /*
         didBeginEditing：开始编辑
         didEndEditing：结束编辑
         didChange：编辑内容发生改变
         didChangeSelection：选中部分发生变化
         */
        let textView = UITextView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        textView.text = "人生若只如初见，只是当时已惘然。"
        self.view.addSubview(textView)
        //开始编辑响应
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        //结束编辑响应
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
            .disposed(by: disposeBag)
        
        //内容发生变化响应
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            })
            .disposed(by: disposeBag)
        
        //选中部分变化响应
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            })
            .disposed(by: disposeBag)
    }
}
extension ViewController {
    //MARK:按钮点击响应
    func topBtn() -> Void {
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        
        button.rx.tap.subscribe(onNext: { (_) in
            self.showMessage("按钮被点击")
        }).disposed(by: disposeBag)
    }
    //显示消息提示框
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:按钮标题（title）的绑定
    func BtnBindTitle() -> Void {
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        timer.map {
            return "计数\($0)"
        }
        .bind(to: button.rx.title(for: .normal))
        .disposed(by: disposeBag)
    }
    //MARK:按钮富文本标题（attributedTitle）的绑定
    func BtnBindattributedTitle() -> Void {
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:100, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map(formatTimeInterval)
        .bind(to: button.rx.attributedTitle())
        .disposed(by: disposeBag)
    }
    //将数字转成对应的富文本
    func formatTimeInterval(ms:NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: 16)!, range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedStringKey.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    //MARK: 按钮图标（image）的绑定
    func BtnBindImg() -> Void {
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:100, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //根据索引数选择对应的按钮图标，并绑定到button上
        timer.map({
            let name = $0%2 == 0 ? "voice_replay_highlight" : "voice_pause"
            return UIImage(named: name)!
        })
            .bind(to: button.rx.image())
            .disposed(by: disposeBag)
    }
    //MARK: 按钮背景图片（backgroundImage）的绑定
    func BtnBindbackgroundImage() -> Void {
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:100, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //根据索引数选择对应的按钮图标，并绑定到button上
        timer.map({
            let name = $0%2 == 0 ? "voice_replay_highlight" : "voice_pause"
            return UIImage(named: name)!
        })
            .bind(to: button.rx.backgroundImage())
            .disposed(by: disposeBag)
    }
    //MARK:按钮是否选中（isSelected）的绑定
    func btnisSelected() -> Void {
        //默认选中第一个按钮
        button1.isSelected = true
        //强制解包，避免后面还需要处理可选类型
        let buttons = [button1,button2,button3].map {return $0!}
         //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectedBtn = Observable.from(buttons).map { (button)  in
            button.rx.tap.map({ button })
        }.merge()
        //对于每一个按钮都对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
        for button in buttons {
            selectedBtn.map { $0 == button }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
        }
        
    }
}

