//
//  RoundedViews.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-27.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit

class RoundedButton: UIButton{
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
}

class RoundedButton: UIView{
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.blue.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3
    }
}

class RoundedButton: UIButton{
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
}
