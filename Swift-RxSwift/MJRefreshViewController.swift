//
//  MJRefreshViewController.swift
//  Swift-RxSwift
//
//  Created by PengXiang on 2018/6/15.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftX
import MJRefresh
class MJRefreshViewController: UIViewController {
    //表格
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        MJRefreshFooter()
        MJRefreshHeader()
    }
    func MJRefreshHeader() -> Void {
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //设置头部刷新控件
        self.tableView.mj_header = MJRefreshNormalHeader()
        
        //初始化ViewModel
        let viewModel = MJRefreshViewModel(headerRefresh:
            self.tableView.mj_header.rx.refreshing.asDriver())
        
        //单元格数据的绑定
        viewModel.tableData.asDriver()
            .drive(tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(row+1)、\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        //下拉刷新状态结束的绑定
        viewModel.endHeaderRefreshing
            .drive(self.tableView.mj_header.rx.endRefreshing)
            .disposed(by: disposeBag)
    }
    func MJRefreshFooter() -> Void {
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //设置尾部刷新控件
        self.tableView.mj_footer = MJRefreshBackNormalFooter()
        
        //初始化ViewModel
        let viewModel = MJRefreshFooterViewModel(
            footerRefresh: self.tableView.mj_footer.rx.refreshing.asDriver(),
            dependency: (
                disposeBag: self.disposeBag,
                networkService: MJRefreshNetworkService()))
        
        //单元格数据的绑定
        viewModel.tableData.asDriver()
            .drive(tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(row+1)、\(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        //上拉刷新状态结束的绑定
        viewModel.endFooterRefreshing
            .drive(self.tableView.mj_footer.rx.endRefreshing)
            .disposed(by: disposeBag)
        
    }
}
