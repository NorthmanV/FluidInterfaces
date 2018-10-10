//
//  InstantPanGestureRecognizer.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 10.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
