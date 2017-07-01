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
    var willClick = [UIImageView]()
    var numToLabel = [Int : UIImageView]()
    var bombArray = Array(repeating: Array(repeating: false, count: 6), count: 6)
    var bombRow = [UIImageView : Int]()
    var bombCol = [UIImageView : Int]()
    var toggleState = "press"
    
    func rand(lim : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(lim)))
    }
    
    func rowColToNum(row : Int, col: Int) -> Int
    {
        return row*6 + col
        
    }
    
    func doWillClick()
    {
        for label in willClick
        {
            clicked(theLabel : label)
        }
        willClick = []
    }
    
    func willClickAppend(row : Int, col : Int)
    {
        if checkOutOfBounds(row: row, col: col)
        {
            willClick.append(numToLabel[rowColToNum(row: row, col: col)]!)
        }
    }
    
    func checkSpecific(row : Int, col : Int) -> Int
    {
        if row<0 || row>5 || col<0 || col>5{
            return 0
        }
        if bombArray[row][col]
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    func checkOutOfBounds(row : Int, col : Int) -> Bool
    {
        if row<0 || row>5 || col<0 || col>5
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func revealBombs()
    {
        for row in 0..<6
        {
            for col in 0..<6
            {
                var label : UIImageView
                label = numToLabel[rowColToNum(row: row, col: col)]!
                if label.image != #imageLiteral(resourceName: "flag") && bombArray[row][col]
                {
                    label.image = #imageLiteral(resourceName: "bomb")
                }
            }
        }
    }
    
    func countBombs()
    {
        var counter = 0
        for bomb in bombArray
        {
            for subBomb in bomb
            {
                if subBomb==true
                {
                    counter += 1
                }
            }
        }
        bombs.text = "Bombs: \(counter)"
    }
    
    func checkWin()
    {
        var counter = 0
        for label in labels
        {
            if label.image != #imageLiteral(resourceName: "blank") && label.image != #imageLiteral(resourceName: "bomb")
            {
                counter += 1
            }
        }
        if counter==36
        {
            print("win")
        }
    }
    
    func vicinity(theLabel : UIImageView) -> Int
    {
        var counter = 0
        let theRow = bombRow[theLabel]
        let theCol = bombCol[theLabel]
        counter += checkSpecific(row: theRow!-1, col: theCol!)   //top
        counter += checkSpecific(row: theRow!, col: theCol!+1)   //right
        counter += checkSpecific(row: theRow!+1, col: theCol!)   //bottom
        counter += checkSpecific(row: theRow!, col: theCol!-1)   //left
        counter += checkSpecific(row: theRow!-1, col: theCol!-1) //upper left
        counter += checkSpecific(row: theRow!-1, col: theCol!+1) //upper right
        counter += checkSpecific(row: theRow!+1, col: theCol!+1) //bottom right
        counter += checkSpecific(row: theRow!+1, col: theCol!-1) //bottom left
        return counter
    }
    
    func clicked (theLabel : UIImageView)
    {
        if theLabel.image!==#imageLiteral(resourceName: "toggleFlag")
        {
            toggleButton.image = #imageLiteral(resourceName: "togglePress")
            toggleState = "press"
        }
        else if theLabel.image!==#imageLiteral(resourceName: "togglePress")
        {
            toggleButton.image = #imageLiteral(resourceName: "toggleFlag")
            toggleState = "flag"
        }
        else if toggleState=="press"
        {
            if theLabel.image!==#imageLiteral(resourceName: "num1") || theLabel.image!==#imageLiteral(resourceName: "num2") || theLabel.image!==#imageLiteral(resourceName: "num3") || theLabel.image!==#imageLiteral(resourceName: "num4") || theLabel.image!==#imageLiteral(resourceName: "num5") || theLabel.image!==#imageLiteral(resourceName: "num6") || theLabel.image!==#imageLiteral(resourceName: "flag") || theLabel.image!==#imageLiteral(resourceName: "bomb")
            {
                return
            }
            else if theLabel.image==#imageLiteral(resourceName: "blank") && bombArray[bombRow[theLabel]!][bombCol[theLabel]!]
            {
                theLabel.image = #imageLiteral(resourceName: "bomb")
                revealBombs()
            }
            else if theLabel.image!==#imageLiteral(resourceName: "blank")
            {
                let vicNum = vicinity(theLabel: theLabel)
                switch vicNum
                {
                case 1:
                    theLabel.image = #imageLiteral(resourceName: "num1")
                case 2:
                    theLabel.image = #imageLiteral(resourceName: "num2")
                case 3:
                    theLabel.image = #imageLiteral(resourceName: "num3")
                case 4:
                    theLabel.image = #imageLiteral(resourceName: "num4")
                case 5:
                    theLabel.image = #imageLiteral(resourceName: "num5")
                case 6:
                    theLabel.image = #imageLiteral(resourceName: "num6")
                default:
                    theLabel.image = #imageLiteral(resourceName: "mediumLightBlank")
                    let row = bombRow[theLabel]
                    let col = bombCol[theLabel]
                    willClickAppend(row: row!-1, col: col!)
                    willClickAppend(row: row!, col: col!+1)
                    willClickAppend(row: row!+1, col: col!)
                    willClickAppend(row: row!, col: col!-1)
                    willClickAppend(row: row!-1, col: col!-1)
                    willClickAppend(row: row!-1, col: col!+1)
                    willClickAppend(row: row!+1, col: col!+1)
                    willClickAppend(row: row!+1, col: col!-1)
                    doWillClick()
                }
            }
            checkWin()
        }
        else if toggleState=="flag"
        {
            if theLabel.image!==#imageLiteral(resourceName: "blank")
            {
                theLabel.image = #imageLiteral(resourceName: "flag")
            }
            else if theLabel.image!==#imageLiteral(resourceName: "flag")
            {
                theLabel.image = #imageLiteral(resourceName: "blank")
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        labels = [box0, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, box22, box23, box24, box25, box26, box27, box28, box29, box30, box31, box32, box33, box34, box35]
        numToLabel = [0:box0, 1:box1, 2:box2, 3:box3, 4:box4, 5:box5, 6:box6, 7:box7, 8:box8, 9:box9, 10:box10, 11:box11, 12:box12, 13:box13, 14:box14, 15:box15, 16:box16, 17:box17, 18:box18, 19:box19, 20:box20, 21:box21, 22:box22, 23:box23, 24:box24, 25:box25, 26:box26, 27:box27, 28:box28, 29:box29, 30:box30, 31:box31, 32:box32, 33:box33, 34:box34, 35:box35]
        reset()
        bombRow = [box0:0, box1:0, box2:0, box3:0, box4:0, box5:0, box6:1, box7:1, box8:1, box9:1, box10:1, box11:1, box12:2, box13:2, box14:2, box15:2, box16:2, box17:2, box18:3, box19:3, box20:3, box21:3, box22:3, box23:3, box24:4, box25:4, box26:4, box27:4, box28:4, box29:4, box30:5, box31:5, box32:5, box33:5, box34:5, box35:5]
        bombCol = [box0:0, box1:1, box2:2, box3:3, box4:4, box5:5, box6:0, box7:1, box8:2, box9:3, box10:4, box11:5, box12:0, box13:1, box14:2, box15:3, box16:4, box17:5, box18:0, box19:1, box20:2, box21:3, box22:4, box23:5, box24:0, box25:1, box26:2, box27:3, box28:4, box29:5, box30:0, box31:1, box32:2, box33:3, box34:4, box35:5]
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
    
    func reset()
    {
        for label in labels
        {
            label.image = #imageLiteral(resourceName: "blank")
        }
        toggleButton.image = #imageLiteral(resourceName: "togglePress")
        for row in 0..<6
        {
            for col in 0..<6
            {
                let randomNum = rand(lim: 5)
                if randomNum == 4
                {
                    bombArray[row][col] = (true)
                }
                else
                {
                    bombArray[row][col] = (false)
                }
            }
            
        }
        toggleState = "press"
        countBombs()
    }
    
    @IBAction func onResetTapped(_ sender: Any)
    {
        reset()
    }
}

