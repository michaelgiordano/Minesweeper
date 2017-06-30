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
    @IBOutlet weak var toggleButton: UIImageView!
    @IBOutlet weak var box0: UIImageView!
    @IBOutlet weak var box1: UIImageView!
    @IBOutlet weak var box2: UIImageView!
    @IBOutlet weak var box3: UIImageView!
    @IBOutlet weak var box4: UIImageView!
    @IBOutlet weak var box5: UIImageView!
    @IBOutlet weak var box6: UIImageView!
    @IBOutlet weak var box7: UIImageView!
    @IBOutlet weak var box8: UIImageView!
    @IBOutlet weak var box9: UIImageView!
    @IBOutlet weak var box10: UIImageView!
    @IBOutlet weak var box11: UIImageView!
    @IBOutlet weak var box12: UIImageView!
    @IBOutlet weak var box13: UIImageView!
    @IBOutlet weak var box14: UIImageView!
    @IBOutlet weak var box15: UIImageView!
    @IBOutlet weak var box16: UIImageView!
    @IBOutlet weak var box17: UIImageView!
    @IBOutlet weak var box18: UIImageView!
    @IBOutlet weak var box19: UIImageView!
    @IBOutlet weak var box20: UIImageView!
    @IBOutlet weak var box21: UIImageView!
    @IBOutlet weak var box22: UIImageView!
    @IBOutlet weak var box23: UIImageView!
    @IBOutlet weak var box24: UIImageView!
    @IBOutlet weak var box25: UIImageView!
    @IBOutlet weak var box26: UIImageView!
    @IBOutlet weak var box27: UIImageView!
    @IBOutlet weak var box28: UIImageView!
    @IBOutlet weak var box29: UIImageView!
    @IBOutlet weak var box30: UIImageView!
    @IBOutlet weak var box31: UIImageView!
    @IBOutlet weak var box32: UIImageView!
    @IBOutlet weak var box33: UIImageView!
    @IBOutlet weak var box34: UIImageView!
    @IBOutlet weak var box35: UIImageView!
    
    var labels = [UIImageView]()
    
    func rand(lim : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(lim)))
    }
    
    func clicked (theLabel : UIImageView)
    {
        if theLabel == toggleButton
        {
            switch toggleButton.image!
            {
            case #imageLiteral(resourceName: "togglePress"):
                toggleButton.image = #imageLiteral(resourceName: "toggleFlag")
            default:
                toggleButton.image = #imageLiteral(resourceName: "togglePress")
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        labels = [box0, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, box22, box23, box24, box25, box26, box27, box28, box29, box30, box31, box32, box33, box34, box35]
        for label in labels
        {
            label.image = #imageLiteral(resourceName: "blank")
        }
        toggleButton.image = #imageLiteral(resourceName: "togglePress")
    }

    @IBAction func whenTapped(_ sender: UITapGestureRecognizer)
    {
        let selectedPoint = sender.location(in: self.view)
        for label in labels
        {
            if label.frame.contains(selectedPoint)
            {
                clicked(theLabel : label)
            }
        }
        if toggleButton.frame.contains(selectedPoint)
        {
            clicked(theLabel : toggleButton)
        }
    }
    
    @IBAction func onResetTapped(_ sender: Any)
    {
        
    }
}

