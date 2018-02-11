//
//  BJTableViewSimpleViewController.swift
//  RxSwift
//
//  Created by 巴糖 on 2018/1/1.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Differentiator



class BJTableViewSimpleViewController : UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<MySection>?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK:- ios 11 导航栏开始
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.red,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50)
            
        
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes

        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        // MARK:- ios 11 导航栏结束
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "Item \(item)"
                
                return cell
        },
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )
        
        self.dataSource = dataSource
        
        let sections = [
            MySection(header: "First section", items: [
                1,
                2
                ]),
            MySection(header: "Second section", items: [
                3,
                4
                ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension BJTableViewSimpleViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // you can also fetch item
        guard let item = dataSource?[indexPath],
            // .. or section and customize what you like
            let _ = dataSource?[indexPath.section]
            else {
                return 0.0
        }
        
        return CGFloat(40 + item * 10)
    }
}

// MARK:- ios 11 导航栏搜索开发
extension BJTableViewSimpleViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {

    }
    
    
}
// MARK:- ios 11 导航栏搜索结束
