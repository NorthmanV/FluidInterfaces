//
//  CalculatorButtonViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class CalculatorButtonViewController: UIViewController {
    
    private var calculatorButton: CalculatorButton = {
        let button = CalculatorButton()
        button.value = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(calculatorButton)
        calculatorButton.center(in: view)
    }
    
    
    
}







