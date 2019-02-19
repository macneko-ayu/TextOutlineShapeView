//
//  UIBezierPathExtension.swift
//  TextOutlineShapeView
//
//  Created by Kojiro Yokota on 2019/02/19.
//  Copyright © 2019年 macneko. All rights reserved.
//

import UIKit

extension UIBezierPath {
    enum InvertDirection {
        case none
        case x
        case y
        case both
    }

    func flip(direction: InvertDirection) {
        let rect = self.bounds
        switch direction {
        case .none:
            break
        case .x:
            self.apply(CGAffineTransform(translationX: -rect.origin.x, y: 0))
            self.apply(CGAffineTransform(scaleX: -1, y: 1))
            self.apply(CGAffineTransform(translationX: rect.origin.x + rect.width, y: 0))
        case .y:
            self.apply(CGAffineTransform(translationX: 0, y: -rect.origin.y))
            self.apply(CGAffineTransform(scaleX: 1, y: -1))
            self.apply(CGAffineTransform(translationX: 0, y: rect.origin.y + rect.height))
        case .both:
            self.apply(CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y))
            self.apply(CGAffineTransform(scaleX: -1, y: -1))
            self.apply(CGAffineTransform(translationX: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
        }
    }
}
