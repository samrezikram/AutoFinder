//
//  Manufactrur.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/17/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSONModel
import SwiftyJSON

struct Manufactrur {
    let pageSize: Int
    let page: Int
    let totalPageCount: Int
    let wkda: JSON
}

extension Manufactrur: JSONModelType {
    enum PropertyKey: String {
        case pageSize, page, totalPageCount, wkda
    }
    
    init(object json: JSONObject<PropertyKey>) throws {
        pageSize = try json.value(for: .pageSize)
        page = try json.value(for: .page)
        totalPageCount = try json.value(for: .totalPageCount)
        wkda = try json.value(for: .wkda)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .pageSize: pageSize,
            .page: page,
            .totalPageCount: totalPageCount,
            .wkda: wkda,
        ]
    }
}

