//
//  123.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/2.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import Differentiator

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = Int
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
