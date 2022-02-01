//
//  EdgeShadowLayer.swift
//  Coco
//
//  Created by Tony Vazgar on 28/01/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import Foundation


public class EdgeShadowLayer: CAGradientLayer {

    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }

    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 5.0,
                toColor: UIColor = UIColor.clear,
                fromColor: UIColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        self.shadowOffset = CGSize(width: 1.5, height: 7.0)
        self.shadowOpacity = 0.5

        let viewFrame = view.frame

        switch edge {
            case .Top:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
                self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
            case .Bottom:
                startPoint = CGPoint(x: 0.5, y: 1.0)
                endPoint = CGPoint(x: 0.5, y: 0.0)
                self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
            case .Left:
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
                self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
            case .Right:
                startPoint = CGPoint(x: 1.0, y: 0.5)
                endPoint = CGPoint(x: 0.0, y: 0.5)
                self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
