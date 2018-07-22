//
//  UIApplicationController.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit
import SwiftyJSON

class UIApplicationController: UIViewController {
    
    var titleLabel:String!
    var leftButton:Bool!
    var rightButton:Bool!
    

    lazy var carTypes: [CarType] = [.car1, .car2, .car3, .car4, .car5, .car6]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func initNavigationWithLogo()->Bool{
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = AppColor.mainColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        let logo = UIImage(named: "navLogo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.titleView?.sizeToFit()
        
        return true;
    }

    
    public func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            let offlineVC =  self.storyboard?.instantiateViewController(withIdentifier: "OfflineVC") as! OfflineViewController
            self.present(offlineVC, animated: true, completion: nil)
        }
    }

    
}


extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( UIApplicationController.dismissKeyboard) )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertWithTwoButtons(title:String, message:String, OkayAction: UIAlertAction, cancelAction: UIAlertAction){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        // Create OK button
        
        alertController.addAction(OkayAction)
        // Create Cancel button
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    func alertWithOneButton(title:String, message:String, OkayAction:UIAlertAction){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        // Create OK button
        
        alertController.addAction(OkayAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
}


extension UIColor{
    static func ColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}


