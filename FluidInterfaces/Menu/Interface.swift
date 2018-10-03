//
//  Interface.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

struct Interface {
    let name: String
    let icon: UIImage
    let type: UIViewController.Type
    
    static var shared: [Interface] {
        return [
            Interface(name: "Calculator button", icon: #imageLiteral(resourceName: "icon_calc"), type: CalculatorButtonViewController.self),
            Interface(name: "Spring animation", icon: #imageLiteral(resourceName: "icon_spring"), type: SpringAnimationViewController.self),
            Interface(name: "Flashlight button", icon: #imageLiteral(resourceName: "icon_flash"), type: FlashlightButtonViewController.self),
            Interface(name: "Rubberbanding", icon: #imageLiteral(resourceName: "icon_rubber"), type: RubberbandingViewController.self),
            Interface(name: "Acceleration pausing", icon: #imageLiteral(resourceName: "icon_acceleration"), type: AccelerationViewController.self)
        ]
    }
}

