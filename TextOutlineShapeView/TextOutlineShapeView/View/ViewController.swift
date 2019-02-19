//
//  ViewController.swift
//  TextOutlineShapeView
//
//  Created by Kojiro Yokota on 2019/02/19.
//  Copyright © 2019年 macneko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // For example
        let str = "我が家の猫は7.4kg\nゆえに重い"
        guard let font = UIFont(name: "HiraKakuProN-W6", size: 36) else { return }

        let textOptions = TextOutlineShapeView.TextOptions(text: str,
                                                      font: font,
                                                      lineSpacing: 10,
                                                      textAlignment: .left)
        let shapeOptions = TextOutlineShapeView.ShapeOptions(lineJoin: .round,
                                                        fillColor: UIColor.white.cgColor,
                                                        strokeColor: UIColor.blue.cgColor,
                                                        lineWidth: 5,
                                                        shadowColor: UIColor.black.cgColor,
                                                        shadowOffset: CGSize(width: 3, height: 3),
                                                        shadowRadius: 5,
                                                        shadowOpacity: 0.6)
        let shapeView = TextOutlineShapeView(textOptions: textOptions, shapeOptions: shapeOptions)
        self.view.addSubview(shapeView)

        shapeView.translatesAutoresizingMaskIntoConstraints = false
        let top = shapeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
        let bottom = shapeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        let leading = shapeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        let trailing = shapeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 10)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
}

