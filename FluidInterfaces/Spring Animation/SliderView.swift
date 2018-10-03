//
//  SliderView.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 12.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

/// A view that displays a title, value, and slider.
class SliderView: UIView {
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    public var value: CGFloat {
        get {
            return CGFloat(slider.value)
        }
        set {
            slider.value = Float(newValue)
            valueLabel.text = String(format: "%.2f", newValue)
        }
    }
    
    public var minValue: CGFloat = 0 {
        didSet {
            slider.minimumValue = Float(minValue)
        }
    }
    
    public var maxValue: CGFloat = 1 {
        didSet {
            slider.maximumValue = Float(maxValue)
        }
    }
    
    /// Code that's executed when the slider moves.
    public var sliderMovedAction: (CGFloat) -> () = {_ in }
    
    /// Code that's executed when the slider has finished moving.
    public var sliderFinishedMovingAction: () -> () = {}
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.text = "0"
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderMoved(slider:event:)), for: .valueChanged)
        return slider
    }()
    
    @objc private func sliderMoved(slider: UISlider, event: UIEvent) {
        valueLabel.text = String(format: "%.2f", slider.value)
        sliderMovedAction(CGFloat(slider.value))
        if event.allTouches?.first?.phase == .ended {
            sliderFinishedMovingAction()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(valueLabel)
        valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        valueLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        
        addSubview(slider)
        slider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    }
    
}
