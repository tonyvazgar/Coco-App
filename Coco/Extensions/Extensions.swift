//
//  Extensions.swift
//  Coco
//
//  Created by Brandon Gonzalez on 20/03/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension UIView {
    
    func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
       
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as! CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        
    }
    
    func slideInFromBottom(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        
        // Create a CATransition animation
        let slideInFromBotttomTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromBotttomTransition.delegate = delegate as! CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromBotttomTransition.type = CATransitionType.push
        slideInFromBotttomTransition.subtype = CATransitionSubtype.fromTop
        slideInFromBotttomTransition.duration = duration
        slideInFromBotttomTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromBotttomTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromBotttomTransition, forKey: "slideInFromBottomTransition")
        
    }
    
    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
         
         // Create a CATransition animation
         let slideInFromRightTransition = CATransition()
         
         // Set its callback delegate to the completionDelegate that was provided (if any)
         if let delegate: AnyObject = completionDelegate {
             slideInFromRightTransition.delegate = delegate as! CAAnimationDelegate
         }
         
         // Customize the animation's properties
         slideInFromRightTransition.type = CATransitionType.push
         slideInFromRightTransition.subtype = CATransitionSubtype.fromRight
         slideInFromRightTransition.duration = duration
         slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
         slideInFromRightTransition.fillMode = CAMediaTimingFillMode.removed
         
         // Add the animation to the View's layer
         self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
         
     }
    
    func slideInFromTop(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        
        // Create a CATransition animation
        let slideInFromTopTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromTopTransition.delegate = delegate as! CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromTopTransition.type = CATransitionType.push
        slideInFromTopTransition.subtype = CATransitionSubtype.fromBottom
        slideInFromTopTransition.duration = duration
        slideInFromTopTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromTopTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromTopTransition, forKey: "slideInFromTopTransition")
        
    }
    
}
