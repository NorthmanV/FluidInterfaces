//
//  RubberbandingViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 02.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class RubberbandingViewController: UIViewController {
    
    private lazy var rubberView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(hex: 0xFF5B50)
        view.bottomColor = UIColor(hex: 0xFFC950)
        return view
    }()
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var originalTouchPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(rubberView)
        rubberView.center(in: view)
        rubberView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        rubberView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        panRecognizer.addTarget(self, action: #selector(panned(recognizer:)))
        rubberView.addGestureRecognizer(panRecognizer)
    }
    
    @objc func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            var offset = touchPoint.y - originalTouchPoint.y
            offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7)  // Use a larger exponent for less movement and a smaller exponent for more movement
            rubberView.transform = CGAffineTransform(translationX: 0, y: offset)
        case .ended, .cancelled:
            let timingParameters = UISpringTimingParameters(damping: 0.6, response: 0.3)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.rubberView.transform = .identity
            }
            animator.isInterruptible = true
            animator.startAnimation()
        default: break
        }
    }
    
}
