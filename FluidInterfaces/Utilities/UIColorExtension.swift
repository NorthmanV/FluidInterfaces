//
//  UIColorExtension.swift
//  FluidInterfaces
//
//  Created by Nonamelab Nonamelab on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat((hex & 0xFF)) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
