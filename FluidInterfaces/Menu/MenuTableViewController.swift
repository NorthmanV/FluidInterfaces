//
//  MenuTableViewController.swift
//  FluidInterfaces
//
//  Created by Руслан Акберов on 11.09.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Interface.shared.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FluidCell", for: indexPath) as! FluidCell
        let interface = Interface.shared[indexPath.row]
        cell.updateUI(image: interface.icon, name: interface.name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let interface = Interface.shared[indexPath.row]
        let vc = interface.type.init()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = interface.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
