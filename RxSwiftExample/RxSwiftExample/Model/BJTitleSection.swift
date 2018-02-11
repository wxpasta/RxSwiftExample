//
//  BJTitleSection.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/2.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import Foundation
import Differentiator

struct BJTitleSection {
    var header: String
    var items: [BJTitleItem]
}

struct BJTitleItem {
    var title: String
    var title_id : String
}

extension BJTitleSection : AnimatableSectionModelType {
    
    // 可以切换成模型
    typealias Item = BJTitleItem
    
    var identity: String {
        return header
    }
    
    init(original: BJTitleSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension BJTitleItem: IdentifiableType, Equatable{
    static func ==(lhs: BJTitleItem, rhs: BJTitleItem) -> Bool {
        return lhs.title_id == rhs.title_id
    }
    
    var identity: String {
        return title_id
    }
    typealias Identity = String
}
