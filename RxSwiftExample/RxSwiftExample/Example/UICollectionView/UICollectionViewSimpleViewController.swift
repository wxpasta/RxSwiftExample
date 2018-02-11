//
//  UICollectionViewSimpleViewController.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/2.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator


class UICollectionViewSimpleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<MySection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        setDataSource(sections: sections)
    }

    
    
}
// MARK:- UICollectionView
extension UICollectionViewSimpleViewController: UICollectionViewDelegate{

}

extension UICollectionViewSimpleViewController{

    
    static func collectionViewDataSourceUI() -> (
        CollectionViewSectionedDataSource<MySection>.ConfigureCell,
        CollectionViewSectionedDataSource<MySection>.ConfigureSupplementaryView
        ) {
            return (
                { (_, cv, ip, i) in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: ip)
                    return cell
            },
                { (ds ,cv, kind, ip) in
                    let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip)
                    return section
            }
            )
    }
    
    fileprivate func setDataSource(sections: [MySection]) {
        let (configureCollectionViewCell, configureSupplementaryView) =  UICollectionViewSimpleViewController.collectionViewDataSourceUI()
        let cvAnimatedDataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: configureCollectionViewCell,
            configureSupplementaryView: configureSupplementaryView
        )
        self.dataSource = cvAnimatedDataSource
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: cvAnimatedDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}
