//
//  FlashlightButtonViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class FlashlightButtonViewController: UIViewController {
    
    private let flashlightButton = FlashlightButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(flashlightButton)
        flashlightButton.center(in: view)
    }
    
}
