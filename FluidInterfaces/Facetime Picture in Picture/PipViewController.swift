//
//  PipViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 10.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class PipViewController: UIViewController {
    
    private lazy var pipView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topColor = UIColor(hex: 0xF2F23A)
        view.bottomColor = UIColor(hex: 0xF7A51C)
        view.cornerRadius = 16
        view.addGestureRecognizer(panRecognizer)
        return view
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(panned))
        return recognizer
    }()
    
    private var pipPositionViews = [PipPositionView]()
    private var pipPositions: [CGPoint] {
        return pipPositionViews.map { $0.center }
    }
    private let pipHeight: CGFloat = 130
    private let pipWidth: CGFloat = 86
    private let verticalSpacing: CGFloat = 25
    private let horizontalSpacing: CGFloat = 23
    private var initialOffset: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let topLeftView = addPipPositionView()
        topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        topLeftView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let topRightView = addPipPositionView()
        topRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        topRightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing).isActive = true
        
        let bottomLeftView = addPipPositionView()
        bottomLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
        bottomLeftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        let bottomRightView = addPipPositionView()
        bottomRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalSpacing).isActive = true
        
        view.addSubview(pipView)
        pipView.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        pipView.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pipView.center = pipPositions.first ?? .zero
    }
    
    private func addPipPositionView() -> PipPositionView {
        let pipPositionView = PipPositionView()
        view.addSubview(pipPositionView)
        pipPositionViews.append(pipPositionView)
        pipPositionView.translatesAutoresizingMaskIntoConstraints = false
        pipPositionView.heightAnchor.constraint(equalToConstant: pipHeight).isActive = true
        pipPositionView.widthAnchor.constraint(equalToConstant: pipWidth).isActive = true
        return pipPositionView
    }
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - pipView.center.x, y: touchPoint.y - pipView.center.y)
        case .changed:
            pipView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            let velocity = recognizer.velocity(in: view)
            // projectedPosition - Calculate the  final point where the view will stop after slide
            let projectedPosition = CGPoint(
                x: pipView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: pipView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let nearestCornerPosition = nearestCorner(to: projectedPosition)
            // decrease current velocity
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(velocity: velocity.x, from: pipView.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(velocity: velocity.y, from: pipView.center.y, to: nearestCornerPosition.y)
            )
            let timingParameters = UISpringTimingParameters(damping: 0.9, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.pipView.center = nearestCornerPosition
            }
            animator.startAnimation()
        default: break
        }
    }
    
    // Distance traveled after decelerating to zero velocity at a constant rate.
    
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return initialVelocity / 1000 * decelerationRate / (1 - decelerationRate)
    }
    
    private func nearestCorner(to point: CGPoint) -> CGPoint {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closesPosition = CGPoint.zero
        for position in pipPositions {
            let distance = point.distance(to: position)
            if distance < minDistance {
                closesPosition = position
                minDistance = distance
            }
        }
        return closesPosition
    }
    
    // Calculates the relative velocity needed for the initial velocity of the animation (decrease swipe velocity).

    private func relativeVelocity(velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0  else { return 0 }
        return velocity / (targetValue - currentValue)
    }
}
