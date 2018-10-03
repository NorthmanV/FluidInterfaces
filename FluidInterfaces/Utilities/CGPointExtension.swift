//
//  CGPointExtension.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 01.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

extension CGPoint {
    
    // Calculates the distance between two points in 2D space (Pythagorean theorem).
    // + returns: The distance from this point to the given point.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
    
}
