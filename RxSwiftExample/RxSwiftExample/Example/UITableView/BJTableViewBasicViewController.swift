//
//  BJTableViewBasicViewController.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/1.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import UIKit


import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

enum Api {
    /// Network response
    static func call() -> Observable<[BJTitleItem]> {
        
        let arr = ["女人三字经：","死远些","别碰我","放开手","我喊了","你讨厌","不可以","不要嘛","你轻点","好舒服","不要停","用力点","不行了","抱紧我","要来了","快咬我","我还要","…………"]
        var x = 0
        
        var arr3 = [BJTitleItem]()
        for i in arr {
            let item = BJTitleItem(title: i, title_id: "\(x)")
            x = x + 1
            
            arr3.append(item)
        }
        return .just(arr3)
    }
}

class BJTableViewBasicViewController : UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<BJTitleSection>?
    
    
    private var sections = Variable<[BJTitleSection]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.tableFooterView = UIView()
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<BJTitleSection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "BJTitleTableViewCell", for: ip) as! BJTitleTableViewCell
                cell.lblTitle.text = ds.sectionModels[ip.section].items[ip.row].title
                
                return cell
        })
        
        self.dataSource = dataSource
        
//        let sections = [
//            BJTitleSection(header: "UITableView1", items: [BJTitleItem(title: "测试1", title_id: "UITableView1")]),
//            BJTitleSection(header: "UITableView2", items: [BJTitleItem(title: "测试2", title_id: "UITableView2")])
//        ]
//
//        Observable.just(sections)
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
        Api.call()
            .map { (customDatas) -> [BJTitleSection] in
                [BJTitleSection(header: "UITableView1", items: customDatas)]
            }
            .bind(to: sections)
            .disposed(by:disposeBag)
        
        sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
        

        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        

        sections.asObservable().subscribe(onNext: { n in
            print("First \(n)")
        }, onCompleted: {
            print("Completed 1")
        }).disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDelegate 必须写
extension BJTableViewBasicViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


    }
}



import Foundation
import RxCocoa
import RxSwift

extension UITableView {
    
    /// Reactive wrapper for `UITableView.insertRows(at:with:)`
    var insertRowsEvent: ControlEvent<[IndexPath]> {
        let source = rx.methodInvoked(#selector(UITableView.insertRows(at:with:)))
            .map { a in
                return a[0] as! [IndexPath]
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `UITableView.endUpdates()`
    var endUpdatesEvent: ControlEvent<Bool> {
        let source = rx.methodInvoked(#selector(UITableView.endUpdates))
            .map { _ in
                return true
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for when the `UITableView` inserted rows and ended its updates.
    var insertedItems: ControlEvent<[IndexPath]> {
        let insertEnded = Observable.combineLatest(
            insertRowsEvent.asObservable(),
            endUpdatesEvent.asObservable(),
            resultSelector: { (insertedRows: $0, endUpdates: $1) }
        )
        let source = insertEnded.map { $0.insertedRows }
        return ControlEvent(events: source)
    }
}
