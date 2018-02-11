//
//  BJTableViewUpdatesViewController.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/7.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

typealias NumberSection = AnimatableSectionModel<String, Int>


class BJTableViewUpdatesViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<NumberSection>?
    
    static let firstChange: [NumberSection]? = nil
    
    var sections = Variable([NumberSection]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nSections = 5
        let nItems =  10
        
        var sectionsN = [NumberSection]()
        
        for i in 0 ..< nSections {
            sectionsN.append(NumberSection(model: "Section \(i + 1)", items: Array(i * nItems ..< (i + 1) * nItems)))
        }
        
        tableView.tableFooterView = UIView()
        
        self.sections.value = sectionsN
        
        let cvAnimatedDataSource = RxTableViewSectionedAnimatedDataSource<NumberSection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "BJTitleTableViewCell", for: ip) as! BJTitleTableViewCell
                cell.textLabel!.text = "\(item)"
                return cell
        },titleForHeaderInSection:{ (ds, section) -> String? in
                return ds[section].model
            }
            
            )
        
        self.dataSource = cvAnimatedDataSource
        
        self.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: cvAnimatedDataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        

    }
    @IBAction func update(_ sender: Any) {
        
        var sectionsN = [NumberSection]()
        
        let nSections = 5
        let nItems =  10
        
        
        
        for i in 0 ..< nSections {
            sectionsN.append(NumberSection(model: "New \(i + 1)", items: Array(i * nItems ..< (i + 1) * nItems)))
        }
        sections.value = sections.value + sectionsN
    }
}

// MARK: - UITableViewDelegate 必须写
extension BJTableViewUpdatesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
