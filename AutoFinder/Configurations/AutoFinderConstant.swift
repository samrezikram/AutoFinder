//
//  AutoConstants.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import Foundation
import UIKit


struct APPURL {
    
    private struct Domains {
        static let Dev = ""
        static let UAT = "http://api-aws-eu-qa-1.auto1-test.com"
        static let Local = ""
        static let QA = ""
    }
    
    private  struct Routes {
        static let api = "/v1"
    }
    private  struct CarTypes {
        static let cars = "/car-types"
    }
    
    private  static let Domain = Domains.UAT
    private  static let Route = Routes.api
    private  static let SubRoute = CarTypes.cars
    private  static let BaseURL = Domain + Route + SubRoute
    
    static var authenticate: String {
        return "&wa_key=coding-puzzle-client-449cc9d"
    }
    
    //MARK: Business API's
    static var UserManufacturer: String {
        return BaseURL  + "/manufacturer?"
    }
    static var UserManufacturerTypes: String {
        return BaseURL  + "/main-types?"
    }
    
    
   
    
}
struct FontNames {
    
    static let LatoName = "Lato"
    struct Lato {
        static let LatoBold = "Lato-Bold"
        static let LatoMedium = "Lato-Medium"
        static let LatoRegular = "Lato-Regular"
        static let LatoExtraBold = "Lato-ExtraBold"
    }
}

struct AppColor {
    
    private struct Alphas {
        static let Opaque = CGFloat(1)
        static let SemiOpaque = CGFloat(0.8)
        static let SemiTransparent = CGFloat(0.5)
        static let Transparent = CGFloat(0.3)
    }
    
    static let nextMainColor = UIColor(red:141/255, green:197/255, blue:68/255, alpha:1.0)

    //unslected : CCE6FF
    static let mainColor = UIColor(red:204/255, green:230/255, blue:255/255, alpha:1.0)
   
}




