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
import RxDataSources
import RxSwiftX
class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    let disposeBag = DisposeBag()
    
    //日期格式化器
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    @IBAction func push(_ sender: UIButton) {
//        self.navigationController?.pushViewController(RxCollectionViewController(), animated: true)//跳转网格
//        self.navigationController?.pushViewController(RxPickerViewController(), animated: true)//跳转pikerview
//        self.navigationController?.pushViewController(RxURLSessionViewController(), animated: true)//跳转URLSession
//        self.navigationController?.pushViewController(GitHubViewController(), animated: true)//MVVM基本应用
//        self.navigationController?.pushViewController(RegisteredViewController(), animated: true)//RxSwift注册
//        self.navigationController?.pushViewController(MJRefreshViewController(), animated: true)//RxSwift刷新
        self.navigationController?.pushViewController(LocationViewController(), animated: true)
    }
    
    
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
        //        btnisSelected()
        //        TwowayBind()
        //        addUIGestureRecognizer()
        //        addUIDatePicker()
        //        basicTableview()
        //        RxDataSourcesTableview()
        //        AreamorecustomTableview()
        //        refreshTableivew()
        //        editTableview()
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
struct UserViewModel {
    //用户名
    let userName = Variable("guest")
    //用户信息
    lazy var userinfo = {
        return self.userName.asObservable()
            .map{
                $0 == "guest" ? "您是管理员" : "您是普通访客"
            }.share(replay: 1, scope: SubjectLifetimeScope.forever)
    }()
}

extension ViewController {
    //MARK:双向绑定
    func TwowayBind() -> Void {
        //创建文本输出框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        //创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:300, height:30))
        self.view.addSubview(label)
        
        var userVM = UserViewModel()
        userVM.userName.asObservable()
            .bind(to: outputField.rx.text)
            .disposed(by: disposeBag)
        
        outputField.rx.text.orEmpty
            .bind(to: userVM.userName)
            .disposed(by: disposeBag)
        
        userVM.userinfo
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    //MARK:UIGestureRecognizer RxCocoa可扩展
    func addUIGestureRecognizer() -> Void {
        //添加一个上滑手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        //手势响应
        swipe.rx.event
            .subscribe(onNext: { (recognizer) in
                //这个点是滑动的起点
                let point = recognizer.location(in: recognizer.view)
                self.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
            }).disposed(by: disposeBag)
    }
    //显示消息提示框
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension ViewController {
    //MARK:UIDatePicker RxCocoa可扩展
    func addUIDatePicker() -> Void {
        datePicker.rx.date
            .map { [weak self] in
                "当前选择时间" + (self?.dateFormatter.string(from: $0))!
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    //MARK:表格基本使用
    func basicTableview() -> Void {
        var tableView = UITableView(frame: self.view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        //初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
            ])
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row)：\(element)"
            return cell
            }.disposed(by: disposeBag)
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        tableView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] item in
            self?.showMessage("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的索引
        tableView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的内容
        tableView.rx.modelDeselected(String.self).subscribe(onNext: {[weak self] item in
            self?.showMessage("被取消选中项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        //获取删除项的索引
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("删除项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取删除项的内容
        tableView.rx.modelDeleted(String.self).subscribe(onNext: {[weak self] item in
            self?.showMessage("删除项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取移动项的索引
        tableView.rx.itemMoved.subscribe(onNext: { [weak self]
            sourceIndexPath, destinationIndexPath in
            self?.showMessage("移动项原来的indexPath为：\(sourceIndexPath)")
            self?.showMessage("移动项现在的indexPath为：\(destinationIndexPath)")
        }).disposed(by: disposeBag)
        
        //获取插入项的索引
        tableView.rx.itemInserted.subscribe(onNext: { [weak self] indexPath in
            self?.showMessage("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
    }
}


//自定义Section
struct MySection {
    var header: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension ViewController {
    //MARK:RxDataSources-多区或者单区
    func RxDataSourcesTableview() -> Void {
        var tableView =  UITableView(frame: self.view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        //初始化数据
        let items = Observable.just([//可以替换成MySection
            SectionModel(model: "", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ])
            ])
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, String>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(indexPath.row)：\(element)"
                return cell
            })
        
        //绑定单元格数据
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    //MARK:多区自定义区头
    func AreamorecustomTableview() -> Void {
        var tableView =  UITableView(frame: self.view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        //初始化数据
        let sections = Observable.just([
            MySection(header: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            //设置单元格
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
                    ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "\(ip.row)：\(item)"
                
                return cell
        },
            //设置分区头标题
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )
        //绑定单元格数据
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
extension ViewController {
    //MARK:数据刷新
    func refreshTableivew() -> Void {
        var tableView =  UITableView(frame: self.view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        //随机的表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest(getRandomResult)
            .share(replay: 1)
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                return cell
            })
        
        //绑定单元格数据
        randomResult
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    //获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
//MARK :可编辑表格
//定义各种操作命令
enum TableEditingCommand {
    case setItems(items: [String])  //设置表格数据
    case addItem(item: String)  //新增数据
    case moveItem(from: IndexPath, to: IndexPath) //移动数据
    case deleteItem(IndexPath) //删除数据
}
//定义表格对应的ViewModel
struct TableViewModel {
    //表格数据项
    fileprivate var items:[String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    //执行相应的命令，并返回最终的结果
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据。")
            return TableViewModel(items: items)
        case .addItem(let item):
            print("新增数据项。")
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            print("移动数据项。")
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexPath):
            print("删除数据项。")
            var items = self.items
            items.remove(at: indexPath.row)
            return TableViewModel(items: items)
        }
    }
}
extension ViewController {
    func editTableview() -> Void {
        var tableView =  UITableView(frame: self.view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        //表格模型
        let initialVM = TableViewModel()
        
        //刷新数据命令
        let refreshCommand = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了页面初始化时会自动加载一次数据
            .flatMapLatest(getRandomResult2)
            .map(TableEditingCommand.setItems)
        
        //新增条目命令
        let addCommand = addButton.rx.tap.asObservable()
            .map{ "\(arc4random())" }
            .map(TableEditingCommand.addItem)
        
        //移动位置命令
        let movedCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)
        
        //删除条目命令
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
            .map(TableEditingCommand.deleteItem)
        
        //绑定单元格数据
        Observable.of(refreshCommand, addCommand, movedCommand, deleteCommand)
            .merge()
            .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand)
                -> TableViewModel in
                return vm.execute(command: command)
            }
            .startWith(initialVM)
            .map {
                [AnimatableSectionModel(model: "", items: $0.items)]
            }
            .share(replay: 1)
            .bind(to: tableView.rx.items(dataSource: ViewController.dataSource()))
            .disposed(by: disposeBag)
    }
    
    //获取随机数据
    func getRandomResult2() -> Observable<[String]> {
        print("生成随机数据。")
        let items = (0 ..< 5).map {_ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }
    
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource
        <AnimatableSectionModel<String, String>> {
            return RxTableViewSectionedAnimatedDataSource(
                //设置插入、删除、移动单元格的动画效果
                animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                               reloadAnimation: .fade,
                                                               deleteAnimation: .left),
                configureCell: {
                    (dataSource, tv, indexPath, element) in
                    let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                    cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                    return cell
            },
                canEditRowAtIndexPath: { _, _ in
                    return true //单元格可删除
            },
                canMoveRowAtIndexPath: { _, _ in
                    return true //单元格可移动
            }
            )
    }
}
