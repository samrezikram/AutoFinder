//
//  SamIBDesinables.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//
import UIKit

@IBDesignable public class CircularImageView: UIImageView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //hard-coded this since it's always round
        layer.cornerRadius = 0.5 * bounds.size.width
        self.clipsToBounds = true
    }
}

@IBDesignable public class CircularUIView: UIView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //hard-coded this since it's always round
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true
    }
}
@IBDesignable public class BorderedView: UIView {
    @IBInspectable override public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable override public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable override public var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable public class BorderedLabel: UILabel {
    @IBInspectable override public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable override public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable override public var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

 

@IBDesignable public class BorderedImageView: UIImageView {
    @IBInspectable override public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable override public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable override public var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
 
}
