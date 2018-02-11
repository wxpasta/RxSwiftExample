//
//  MultipleSectionModel.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/2.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import Foundation
import Differentiator

enum MultipleSectionModel {
    case imageSection(title: String, items: [SectionItem])
    case titleSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case image(image: UIImage)
    case title(title: String)
}

extension MultipleSectionModel: SectionModelType{
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .imageSection(title:  _, items: let items):
            return items.map {$0}
        case .titleSection(title:  _, items: let items):
            return items.map {$0}
        }
    }
    
    init(original: MultipleSectionModel, items: [SectionItem]) {
        switch original {
        case let .imageSection(title: title, items: _):
            self =  .imageSection(title: title, items: items)
        case let .titleSection(title: title, items: _):
            self =  .titleSection(title: title, items: items)
            
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .imageSection(title: let title, items: _):
            return title
        case .titleSection(title: let title, items: _):
            return title
        }
    }
}
