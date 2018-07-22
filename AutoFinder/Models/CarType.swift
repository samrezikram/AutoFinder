//
//  CarType.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/18/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit

enum CarType: String {
    
    case car1 = "car1"
    case car2 = "car2"
    case car3 = "car3"
    case car4 = "car4"
    case car5 = "car5"
    case car6 = "car6"
    
    
    var image: UIImage {
        switch self {
        case .car1: return #imageLiteral(resourceName: "car1")
        case .car2: return #imageLiteral(resourceName: "car2")
        case .car3: return #imageLiteral(resourceName: "car3")
        case .car4: return #imageLiteral(resourceName: "car4")
        case .car5: return #imageLiteral(resourceName: "car5")
        case .car6: return #imageLiteral(resourceName: "car6")
        }
    }
    
    var color: UIColor? {
        switch self {
        case .car1:
            return UIColor(hex: 0x007AFF)
        case .car2:
            return UIColor(hex: 0x5AC8FA)
        case .car3:
            return UIColor(hex: 0x4CD964)
        case .car4:
            return UIColor(hex: 0xFF5722)
        case .car5, .car6:
            return UIColor(hex: 0xFF2DC6)
        }
    }
}

struct ModelName {
    var carName : String!
    var carIndex : String!
    var pageIndex: String!
}


