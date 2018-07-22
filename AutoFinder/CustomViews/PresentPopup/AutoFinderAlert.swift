//
//  ResetPasswordView.swift
//  Wajbati
//
//  Created by Samrez Ikram on 4/22/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit

@IBDesignable class AutoFinderAlert: UIView {
    @IBOutlet weak var cancelBtn: UIButton!
    var emailAddres:String! = ""
    
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var manfacturerLbl: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var _borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var _cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var _borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
 
    

}
