//
//  AccelerationViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 02.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class AccelerationViewController: UIViewController {
    
    private lazy var pauseLabel: UILabel = {
        let label = UILabel()
        label.text = "PAUSED"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private lazy var accelerationView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0x64FF8F)
        view.bottomColor = UIColor(hex: 0x51FFEA)
        return view
    }()
    
    private let panRecognizer = UIPanGestureRecognizer()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let verticalOffset: CGFloat = 180
    private var originalTouchPoint: CGPoint = .zero
    private var hasPaused = false
    private var numberOfVelocities = 7
    private var velocities = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(pauseLabel)
        pauseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        
        view.addSubview(accelerationView)
        accelerationView.center(in: view, offset: UIOffset(horizontal: 0, vertical: verticalOffset))
        accelerationView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        accelerationView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(panned(recognizer:)))
        accelerationView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        let velocity = recognizer.velocity(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            let offset: CGFloat = {
                let offset = touchPoint.y - originalTouchPoint.y
                if offset > 0 {
                    return pow(offset, 0.7)
                } else if offset < -verticalOffset * 2 {
                    return -verticalOffset * 2 - pow(-(offset + verticalOffset * 2), 0.7)
                } else {
                    return offset
                }
            }()
            accelerationView.transform = CGAffineTransform(translationX: 0, y: offset)
            trackPause(velocity: velocity.y, offset: offset)
        case .ended, .cancelled:
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.accelerationView.transform = .identity
                self.pauseLabel.alpha = 0
            }
            animator.isInterruptible = true
            animator.startAnimation()
            hasPaused = false
        default: break
        }
    }
    
    // Tracks the most recent velocity values, and determines whether the change is great enough to be pasued.
    // After calling this function, the result can be checked in the `hasPaused` property.
    private func trackPause(velocity: CGFloat, offset: CGFloat) {
        // if the motion is paused, we are done
        if hasPaused { return }
        
        // update the array of most recent velocities
        if velocities.count < numberOfVelocities {
            velocities.append(velocity)
            return
        } else {
            velocities = Array(velocities.dropFirst())
            velocities.append(velocity)
        }
        
        // enforce minimum velocity and offset
        if abs(velocity) > 100 || abs(offset) < 50 { return }
        
        // if the majority of the velocity has been lost recetly, we consider the motion to be paused
        guard let firstRecordedVelocity = velocities.first else { return }
        if abs(firstRecordedVelocity - velocity) / abs(firstRecordedVelocity) > 0.9 {
            pauseLabel.alpha = 1
            feedbackGenerator.impactOccurred()
            hasPaused = true
            velocities.removeAll()
        }
    }
    
}
