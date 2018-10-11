//
//  RotationViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class RotationViewController: UIViewController {
    
    private lazy var rotationView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0xFF28A5)
        view.bottomColor = UIColor(hex: 0x7934CF)
        view.addGestureRecognizer(rotationRecognizer)
        return view
    }()
    
    private lazy var rotationRecognizer: UIRotationGestureRecognizer = {
        let recognizer = UIRotationGestureRecognizer()
        recognizer.addTarget(self, action: #selector(rotated))
        return recognizer
    }()
    
    private var originalRotation: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(rotationView)
        rotationView.center(in: view)
        rotationView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        rotationView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    // 180 = pi * radian
    // radian = 57,3 degree
    
    @objc private func rotated(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .began:
            originalRotation = atan2(rotationView.transform.b, rotationView.transform.a)
            rotationView.transform = CGAffineTransform(rotationAngle: originalRotation + rotationRecognizer.rotation)
        case .changed:
            rotationView.transform = CGAffineTransform(rotationAngle: originalRotation + rotationRecognizer.rotation)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.fast.rawValue
            let velocity = recognizer.velocity
            // projectedPosition - Calculate the  final point where the view will stop after rotate
            let projectedRotation = rotationRecognizer.rotation + project(initialVelocity: velocity, decelerationRate: decelerationRate)
            let nearestAngle = closestAngle(to: projectedRotation)
            // decrease current velocity
            let relativeInitialVelocity = relativeVelocity(velocity: velocity, from: rotationRecognizer.rotation, to: nearestAngle)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.4, initialVelocity: CGVector(dx: relativeInitialVelocity, dy: 0))
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.rotationView.transform = CGAffineTransform(rotationAngle: self.originalRotation + nearestAngle)
            }
            animator.startAnimation()
        default: break
        }
    }
    
    // Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return initialVelocity / 1000 * decelerationRate / (1 - decelerationRate)
    }
    
    private func closestAngle(to angle: CGFloat) -> CGFloat {
        let divisor: CGFloat = .pi / 2
        let remainder = angle.truncatingRemainder(dividingBy: divisor)
        var newAngle: CGFloat = 0
        if remainder >= 0 {
            if remainder >= divisor / 2 {
                newAngle = angle + divisor - remainder
            } else {
                newAngle = remainder == 0 ? angle : angle - remainder
            }
        } else {
            if remainder <= -divisor / 2 {
                newAngle = angle - divisor - remainder
            } else {
                newAngle = angle - remainder
            }
        }
        if newAngle > .pi { newAngle = .pi }
        if newAngle < -.pi { newAngle = -.pi }
        return newAngle
    }
    
    // Calculates the relative velocity needed for the initial velocity of the animation (decrease rotation velocity).
    
    private func relativeVelocity(velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }
}
