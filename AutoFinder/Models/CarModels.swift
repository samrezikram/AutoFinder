//
//  CarModels.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/18/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSONModel
import SwiftyJSON
struct CarModels {
    let page: Int
    let pageSize: Int
    let totalPageCount: Int
    let wkda: JSON
}

extension CarModels: JSONModelType {
    enum PropertyKey: String {
        case page, pageSize, totalPageCount, wkda
    }
    
    init(object json: JSONObject<PropertyKey>) throws {
        page = try json.value(for: .page)
        pageSize = try json.value(for: .pageSize)
        totalPageCount = try json.value(for: .totalPageCount)
        wkda = try json.value(for: .wkda)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .page: page,
            .pageSize: pageSize,
            .totalPageCount: totalPageCount,
            .wkda: wkda,
        ]
    }
}
