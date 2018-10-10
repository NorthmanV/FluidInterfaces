//
//  PipPositionView.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 10.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class PipPositionView: UIView {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(white: 0.3, alpha: 1).cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private let lineWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: 16).cgPath
    }
    
}
