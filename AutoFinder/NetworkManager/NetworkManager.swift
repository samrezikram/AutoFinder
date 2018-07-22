//
//  NetworkManager.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
class NetworkManager: NSObject {
    
    class var authenticationKey: String { return "coding-puzzle-client-449cc9d".base64Encoded()! }
    class func userManufacturerList( l_requestParams: [String:Any]?, withCompletionHandler: @escaping (_ response:JSON?)->(Void) ) {
      
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" :"application/json; charset=utf-8"
        ]
        
        let finalURL = self.queryString(urlString: APPURL.UserManufacturer, params: l_requestParams!)
        
        Alamofire.request( finalURL,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { responseData in
            
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                withCompletionHandler(swiftyJsonVar as JSON )
                }else{
                    withCompletionHandler(nil)
                }
     
            }
    }
    
    class func userCarModels( l_requestParams: [String:Any]?, withCompletionHandler: @escaping (_ response:JSON?)->(Void) ) {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" :"application/json; charset=utf-8"
        ]
        
        let finalURL = self.queryString(urlString: APPURL.UserManufacturerTypes, params: l_requestParams!)

        
        Alamofire.request(finalURL,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON { responseData in
                
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    withCompletionHandler(swiftyJsonVar as JSON)
                }else{
                    withCompletionHandler(JSON.null)
                }
                
        }
    }
    
    class func queryString(urlString:String, params:[String: Any]) -> String {
        
        let queryItems = params.map({ URLQueryItem(name: $0.key, value: $0.value as? String) })
        
        var urlComps = URLComponents(string: urlString)
        urlComps?.queryItems = queryItems
        
        return urlComps?.url?.absoluteString ?? ""
    }
    
    
   
    
}
