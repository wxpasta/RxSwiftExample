//
//  BJTableViewComplexViewController.swift
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

class BJTableViewComplexViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        bindTableView()
    }
}

extension BJTableViewComplexViewController: UITableViewDelegate{
    
}

extension BJTableViewComplexViewController{
    
    func bindTableView()  {
        tableView.tableFooterView = UIView()
        
        let dataSource = BJTableViewComplexViewController.dataSource()
        
        let sections: [MultipleSectionModel] = [
            MultipleSectionModel.titleSection(title: "文字说明", items: [SectionItem.title(title: "Dilraba"),SectionItem.title(title: "迪丽热巴")]),
            MultipleSectionModel.imageSection(title: "图片", items: [SectionItem.image(image: #imageLiteral(resourceName: "Dilraba"))])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { ds, tv, ip, item in
                switch ds[ip]{
                case let SectionItem.image(image):
                    let cell = tv.dequeueReusableCell(withIdentifier: "BJImageTableViewCell", for: ip) as! BJImageTableViewCell
                    cell.iv.image = image
                    return cell
                case let SectionItem.title(title):
                    let cell = tv.dequeueReusableCell(withIdentifier: "BJTitleTableViewCell", for: ip) as! BJTitleTableViewCell
                    cell.lblTitle.text = title
                    return cell
                }
            },
            titleForHeaderInSection: { ds, section in
                let section = ds[section]
                return section.title
                
            }
        )
    }
}
