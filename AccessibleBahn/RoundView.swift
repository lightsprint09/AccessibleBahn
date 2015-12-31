//
//  RoundView.swift
//  CardScore
//
//  Created by Lukas Schmidt on 24.06.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
}
