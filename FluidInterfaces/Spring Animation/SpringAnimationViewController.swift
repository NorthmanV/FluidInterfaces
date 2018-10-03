//
//  SpringAnimationViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class SpringAnimationViewController: UIViewController {
    
    private var dampingRatio: CGFloat = 0.5
    private var frequencyResponse: CGFloat = 1
    private var margin: CGFloat = 30
    private var animator = UIViewPropertyAnimator()
    
    private lazy var springView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topColor = UIColor(hex: 0x64CCF7)
        view.bottomColor = UIColor(hex: 0x359EEC)
        return view
    }()
    
    private lazy var dampingSliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.title = "Damping (bounciness)"
        sliderView.minValue = 0.1
        sliderView.maxValue = 1
        sliderView.value = dampingRatio
        sliderView.sliderMovedAction = { self.dampingRatio = $0 }
        sliderView.sliderFinishedMovingAction = { self.resetAnimation() }
        return sliderView
    }()
    
    private lazy var frequencySliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.title = "Response (speed)"
        sliderView.minValue = 0.1
        sliderView.maxValue = 2
        sliderView.value = frequencyResponse
        sliderView.sliderMovedAction = { self.frequencyResponse = $0 }
        sliderView.sliderFinishedMovingAction = { self.resetAnimation() }
        return sliderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(dampingSliderView)
        dampingSliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        dampingSliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        dampingSliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(frequencySliderView)
        frequencySliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        frequencySliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        frequencySliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140).isActive = true
        
        view.addSubview(springView)
        springView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        springView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        springView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        springView.bottomAnchor.constraint(equalTo: dampingSliderView.topAnchor, constant: -80).isActive = true
        
        animateView()
    }
    
    // Repeatedly animates the view using the current `dampingRatio` and `frequencyResponse`
    private func animateView() {
        let timingParameters = UISpringTimingParameters(damping: dampingRatio, response: frequencyResponse)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            let translation = self.view.bounds.width - 2 * self.margin - 80
            self.springView.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        animator.addCompletion { _ in
            self.springView.transform = .identity
            self.animateView()
        }
        animator.startAnimation()
    }
    
    private func resetAnimation() {
        animator.stopAnimation(true)
        springView.transform = .identity
        animateView()
    }
    
}
