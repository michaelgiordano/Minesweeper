//
//  SecondViewController.swift
//  App 4 - Build Your Own - Minesweeper
//
//  Created by Michael Giordano on 6/30/17.
//  Copyright © 2017 Michael Giordano. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController
{
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    
    var bombs = 0
    var found = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bombsLabel.text = "Bombs: \(bombs)"
        foundLabel.text = "Found: \(found)"
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
    }
}
