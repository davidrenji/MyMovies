//
//  Animation.swift
//  MyMovies
//
//  Created by David on 1/29/21.
//

import Foundation
import Lottie

struct Animation {
    var animationView: AnimationView
    var parentView: UIView
    
    init(parent: UIView, name: String, width: Int, height: Int, loop: Bool, color: UIColor?) {
        parentView = parent
        animationView = .init(name: name)
        animationView.contentMode = .scaleAspectFit
        if loop {
            animationView.loopMode = .loop
        }
        animationView.frame = CGRect(x: Int(parentView.frame.width)/2 - width/2, y: Int(parentView.frame.height)/2 - height/2, width: width, height: height)
        
        if let _color = color {
            let keypath = AnimationKeypath(keys: ["**", "Fill 1", "**", "Color"])
            let colorProvider = ColorValueProvider(_color.lottieColorValue)
            animationView.setValueProvider(colorProvider, keypath: keypath)
        }
        
        parentView.addSubview(animationView)
        hide()
    }
    
    func play() {
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
    
    func show() {
        play()
        animationView.isHidden = false
    }
    
    func hide() {
        stop()
        animationView.isHidden = true
    }
    
}
