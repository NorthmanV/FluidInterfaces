//
//  MomentumViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 10.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class MomentumViewController: UIViewController {
    
    private lazy var momentumView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topColor = UIColor(hex: 0x61A8FF)
        view.bottomColor = UIColor(hex: 0x243BD1)
        view.cornerRadius = 30
        view.addGestureRecognizer(panRecognizer)
        return view
    }()
    
    private lazy var handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(panned))
        return recognizer
    }()
    
    private var animator = UIViewPropertyAnimator()
    private var isOpen = false
    private var animationProgress: CGFloat = 0
    private var closedTransform = CGAffineTransform.identity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(momentumView)
        momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        momentumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        momentumView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        
        momentumView.addSubview(handleView)
        handleView.topAnchor.constraint(equalTo: momentumView.topAnchor, constant: 10).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handleView.centerXAnchor.constraint(equalTo: momentumView.centerXAnchor).isActive = true
        
        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.6)
        momentumView.transform = closedTransform
    }
    
    @objc func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            var fraction = -recognizer.translation(in: momentumView).y / closedTransform.ty
            if isOpen { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: momentumView).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            if isOpen {
                // if swipe up - view should not close
                if !shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if shouldClose && animator.isReversed { animator.isReversed.toggle() }
            } else {
                // if swipe down - view should not open
                if shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if !shouldClose && animator.isReversed { animator.isReversed.toggle() }
            }
            let fractionRemaining = 1 - animator.fractionComplete
            let distanceRemaining = fractionRemaining * closedTransform.ty
            if distanceRemaining == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 30)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
            let preferredDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
            let durationFactor = CGFloat(preferredDuration / animator.duration)
            // durationFactor - can be a constant, value on which will multiply duration to end animation
            animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
        default: break
        }
    }
    
    func startAnimationIfNeeded() {
        if animator.isRunning { return }
        let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.momentumView.transform = self.isOpen == true ? self.closedTransform : .identity
        }
        animator.addCompletion { (position) in
            if position == .end { self.isOpen.toggle() }
        }
        animator.startAnimation()
    }
}
