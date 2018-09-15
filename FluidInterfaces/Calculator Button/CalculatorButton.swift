//
//  CalculatorButton.swift
//  FluidInterfaces
//
//  Created by Nonamelab Nonamelab on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class CalculatorButton: UIControl {
    
    public var value: Int = 0 {
        didSet {
            label.text = String(value)
        }
    }

    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var animator = UIViewPropertyAnimator()
    private var normalColor = UIColor(hex: 0x333333)
    private var highlightedColor = UIColor(hex: 0x737373)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    func sharedInit() {
        backgroundColor = normalColor
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        addSubview(label)
        label.center(in: self)
    }
    
    @objc func touchDown() {
        animator.stopAnimation(true)
        backgroundColor = highlightedColor
    }
    
    @objc func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.backgroundColor = self.normalColor
        })
        animator.startAnimation()
    }
    

}















