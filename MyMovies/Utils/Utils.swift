//
//  Utils.swift
//  MyMovies
//
//  Created by David on 1/29/21.
//

import UIKit

extension UIView {
    func addRoundCorners(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func addBoxShadow(opacity: Float, radius: Int, color: UIColor?){
        
        var _color: UIColor = UIColor.white
        if color != nil {
            _color = color!
        }
        
        self.layer.shadowColor = _color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
