//
//  MaterialButton.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/19/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
