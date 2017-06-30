//
//  ViewController.swift
//  App 4 - Build Your Own - Minesweeper
//
//  Created by Michael Giordano on 6/30/17.
//  Copyright © 2017 Michael Giordano. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var bombs: UILabel!
    
    func rand(lim : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(lim)))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func whenTapped(_ sender: UITapGestureRecognizer)
    {
        
    }
    
    @IBAction func onToggleTapped(_ sender: Any)
    {
        
    }
    
    @IBAction func onResetTapped(_ sender: Any)
    {
        
    }
}

