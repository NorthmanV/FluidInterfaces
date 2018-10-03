//
//  FluidCell.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class FluidCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateUI(image: UIImage, name: String) {
        iconImageView.image = image
        nameLabel.text = name
    }
}
