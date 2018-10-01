//
//  FlashlightButton.swift
//  FluidInterfaces
//
//  Created by Nonamelab Nonamelab on 01.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class FlashlightButton: UIControl {
    
    private enum ForceState {
        case reset  // The button is ready to be activiated. Default state
        case activated  // The button has been pressed with enough force
        case confirmed  // The button has recently switched on/off
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = offImage
        imageView.tintColor = .white
        return imageView
    }()
    
    private let onImage = #imageLiteral(resourceName: "flashlight_on")
    private let offImage = #imageLiteral(resourceName: "flashlight_off")

    private var isOn = false
    private var forceState: ForceState = .reset
    
    // This is used to cancel touches that move outisde of its bounds
    private var touchExited = false
    
    private let activationFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let confirmationFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let minWidth: CGFloat = 50
    private let maxWidth: CGFloat = 92
    
    private let onColor = UIColor(white: 0.95, alpha: 1)
    private let offColor = UIColor(white: 0.2, alpha: 1)
    
    private let activationForce: CGFloat = 0.5
    private let confirmationForce: CGFloat = 0.49
    private let resetForce: CGFloat = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        backgroundColor = offColor
        addSubview(imageView)
        imageView.pin(to: self)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: minWidth, height: minWidth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchExited = false
        touchMoved(touch: touches.first)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved(touch: touches.first)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    private func touchMoved(touch: UITouch?) {
        guard let touch = touch else { return }
        guard !touchExited else { return }
        
        let cancelDistance: CGFloat = minWidth / 2 + 20
        
        print(touch.location(in: self).distance(to: CGPoint(x: bounds.midX, y: bounds.midY)))
        guard touch.location(in: self).distance(to: CGPoint(x: bounds.midX, y: bounds.midY)) < cancelDistance else {
            // the touch has moved outside of the bounds of the button
            touchExited = true
            forceState = .reset
            animateToRest()
            return
        }
        
        let force = touch.force / touch.maximumPossibleForce // maximum = 6.67
        let scale = 1 + (maxWidth / minWidth - 1) * force
        
        // update the button's size and color
        transform = CGAffineTransform(scaleX: scale, y: scale)
        if !isOn { backgroundColor = UIColor(white: 0.2 - force * 0.2, alpha: 1) }
        
        switch forceState {
        case .reset:
            if force >= activationForce {
                forceState = .activated
                activationFeedbackGenerator.impactOccurred()
            }
        case .activated:
            if force <= confirmationForce {
                forceState = .confirmed
                activate()
            }
        case .confirmed:
            if force <= resetForce {
                forceState = .reset
            }
        }
    }
    
    private func touchEnded(touch: UITouch?) {
        guard !touchExited else { return }
        if forceState == .activated { activate() }
        forceState = .reset
        animateToRest()
    }
    
    private func activate() {
        isOn.toggle()
        imageView.image = isOn ? onImage : offImage
        imageView.tintColor = isOn ? .black : .white
        backgroundColor = isOn ? onColor : offColor
        confirmationFeedbackGenerator.impactOccurred()
    }
    
    private func animateToRest() {
        let timingParameters = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.backgroundColor = self.isOn ? self.onColor : self.offColor
        }
        animator.isInterruptible = true
        animator.startAnimation()
    }
    
}
