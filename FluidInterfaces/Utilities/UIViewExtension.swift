//
//  UIViewExtension.swift
//  FluidInterfaces
//
//  Created by Nonamelab Nonamelab on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

extension UIView {
    
    static func activate(constraints: [NSLayoutConstraint]) {
        constraints.forEach {($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false}
        NSLayoutConstraint.activate(constraints)
    }
    
    func center(in view: UIView, offset: UIOffset = .zero) {
        UIView.activate(constraints: [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.horizontal),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.vertical)
        ])
    }
    
}
