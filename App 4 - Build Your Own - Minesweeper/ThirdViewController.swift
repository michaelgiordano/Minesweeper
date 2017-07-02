//
//  ThirdViewController.swift
//  App 4 - Build Your Own - Minesweeper
//
//  Created by Michael Giordano on 7/1/17.
//  Copyright © 2017 Michael Giordano. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    
    var bombs = 0
    var found = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        bombsLabel.text = "Bombs: \(bombs)"
        foundLabel.text = "Found: \(found)"
    }
}
