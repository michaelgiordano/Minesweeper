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
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var bombInput: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var only: UILabel!
    @IBOutlet weak var bombs: UILabel!
    @IBOutlet weak var toggleButton: UIImageView!
    
    var imageViews = [[UIImageView]]()
    var willClick = [UIImageView]()
    var numToLabel = [Int : UIImageView]()
    var bombArray = Array(repeating: Array(repeating: false, count: 8), count: 8)
    var numberArray = Array(repeating: Array(repeating: -1, count: 8), count: 8)
    var bombRow = [UIImageView : Int]()
    var bombCol = [UIImageView : Int]()
    var customNumBombs = 0
    var numBombs = 0
    var numFound = 0
    var toggleState = "press"
    var lose = false
    var shouldCheckWin = true
    
    override func viewDidLoad() //runs at the beginning when the app loads
    {
        super.viewDidLoad()
        only.text = "(5-20 only)" //sets 'only' text right below custom bomb input
        goButton.layer.cornerRadius = 5 //rounding go button:
        goButton.clipsToBounds = true
        resetButton.layer.cornerRadius = 5 //rounding reset button:
        resetButton.clipsToBounds = true
        layImageViews() //laying out imageViews as blanks
        reset() //loading a new game with 10 bombs
    }
    
    func clicked (theLabel : UIImageView) //called when a given UIImageView is clicked (called from UITapGestureRecognizer)
    {
        if theLabel.image! == #imageLiteral(resourceName: "toggleFlag") //if the toggle was clicked, switch it
        {
            toggleButton.image = #imageLiteral(resourceName: "togglePress")
            toggleState = "press"
        }
        else if theLabel.image! == #imageLiteral(resourceName: "togglePress") //if the toggle was clicked, switch it (same as above, just opposite images)
        {
            toggleButton.image = #imageLiteral(resourceName: "toggleFlag")
            toggleState = "flag"
        }
        else if toggleState=="flag" //if the toggle is on flag...
        {
            if theLabel.image! == #imageLiteral(resourceName: "newBlank") //...flag the square if it is blank (uncovered)
            {
                theLabel.image = #imageLiteral(resourceName: "flag")
            }
            else if theLabel.image! == #imageLiteral(resourceName: "flag") //...unflag the square if it is flagged
            {
                theLabel.image = #imageLiteral(resourceName: "newBlank")
            }
        }
        else if toggleState=="press" //if the toggle is on press...
        {
            let pair = theLabel.accessibilityIdentifier! //using the UIImageView's identifier to get its row and column
            let index1 = pair.index(pair.startIndex, offsetBy: 1)
            let theRow = Int(pair.substring(to: index1))!
            let theCol = Int(pair.substring(from: index1))!
            if theLabel.image! == #imageLiteral(resourceName: "num1") || theLabel.image! == #imageLiteral(resourceName: "num2") || theLabel.image! == #imageLiteral(resourceName: "num3") || theLabel.image! == #imageLiteral(resourceName: "num4") || theLabel.image! == #imageLiteral(resourceName: "num5") || theLabel.image! == #imageLiteral(resourceName: "num6") || theLabel.image! == #imageLiteral(resourceName: "flag") || theLabel.image! == #imageLiteral(resourceName: "bomb") //if it's a number, then do nothing
            {
                return
            }
            else if theLabel.image == #imageLiteral(resourceName: "newBlank") && bombArray[theRow][theCol] == true //if the imageView is blank and there's a bomb underneath
            {
                revealBombs() //reveal the bombs
                lose = true //the player has lost
                numFound = 0 //reset the numFound becuase we are about to count this and increment it
                for row in 0..<8 //cycling through the bomb array
                {
                    for col in 0..<8
                    {
                        if bombArray[row][col] == true && imageViews[row][col].image == #imageLiteral(resourceName: "flag") //if there is a bomb there and the player flagged it before they lost
                        {
                            numFound += 1
                        }
                    }
                }
                let delayInSeconds = 1.0 //delay for 1.0 seconds so that the user can see all the bombs
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds)
                {
                    //setting destination of segue
                    let dvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                    dvc.bombs = self.numBombs //transfer over the number of bombs overall
                    dvc.found = self.numFound //transfer over the number of bombs found
                    self.reset() //reset the screen before leaving
                    self.present(dvc, animated: true, completion: nil) //segue-ing to the lose screen
                }
            }
            else if theLabel.image! == #imageLiteral(resourceName: "newBlank") //if its blank and there's no bomb underneath (we check that above)
            {
                let pair = theLabel.accessibilityIdentifier! //using the UIImageView's identifier to get it's row and column
                let index1 = pair.index(pair.startIndex, offsetBy: 1)
                let theRow = Int(pair.substring(to: index1))!
                let theCol = Int(pair.substring(from: index1))!
                switch numberArray[theRow][theCol] //setting the image to display it vicinity number (gotten from the row and col above)
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
                    shouldCheckWin = false
                    theLabel.image = #imageLiteral(resourceName: "mediumLightBlank")
                    for rowChange in -1...1
                    {
                        for colChange in -1...1
                        {
                            if (rowChange != 0 || colChange != 0) && checkOutOfBounds(row: theRow+rowChange, col: theCol+colChange)
                            {
                                clicked(theLabel: imageViews[theRow+rowChange][theCol+colChange])
                            }
                        }
                    }
                }
            }
        }
        if shouldCheckWin
        {
            checkWin()
        }
    }
    
    func checkWin() //checks to see if the player has won
    {
        var counter = 0 //number of imageViews adressed (either opened or flagged)
        var flagCounter = 0 //number of imageViews flagged
        for row in imageViews
        {
            for col in row
            {
                if col.image != #imageLiteral(resourceName: "newBlank") && col.image != #imageLiteral(resourceName: "bomb") //if the imageView is not a blank or a bomb
                {
                    counter += 1 //increment the counter
                }
                if col.image == #imageLiteral(resourceName: "flag") //if the imageView is flagged
                {
                    flagCounter += 1 //increment flagged label counter
                }
            }
        }
        if counter == 64 && flagCounter == numBombs //if they have adressed every imageView and flagged all the bombs
        {
            lose = true //not that they lost, but this essentialy says the game is over
            numFound = 0 //reset the numFound becuase we are about to count this and increment it
            for row in 0..<8
            {
                for col in 0..<8
                {
                    if bombArray[row][col] == true && imageViews[row][col].image == #imageLiteral(resourceName: "flag") //if it's a bomb and you flagged it
                    {
                        numFound += 1 //increment the number of bombs you found
                    }
                }
            }
            let delayInSeconds = 0.2 //give the use a second to see that they actually tapped that 'winning imageView'
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds)
            {
                //setting destination of segue
                let dvc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
                dvc.bombs = self.numBombs //pass over number of bombs total
                dvc.found = self.numFound //pass over number of bombs found
                self.reset()
                self.present(dvc, animated: true, completion: nil)
            }
        }
    }
    
    func checkOutOfBounds(row : Int, col : Int) -> Bool //checks if a given row-col pair is a valid 2d array index
    {
        if row<0 || row>7 || col<0 || col>7
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func revealBombs() //reveals all bombs (for when player loses)
    {
        for row in 0..<8
        {
            for col in 0..<8
            {
                let label = imageViews[row][col]
                if bombArray[row][col] && label.image != #imageLiteral(resourceName: "flag")
                {
                    label.image = #imageLiteral(resourceName: "bomb")
                }
            }
        }
    }

    @IBAction func whenTapped(_ sender: UITapGestureRecognizer) //recieves finger taps and tells other funcs what was tapped
    {
        if lose
        {
            return
        }
        shouldCheckWin = true
        let selectedPoint = sender.location(in: self.view)
        for row in imageViews
        {
            for col in row
            {
                if col.frame.contains(selectedPoint) //if user tapped given square
                {
                    clicked(theLabel : col)
                }
            }
        }
        if toggleButton.frame.contains(selectedPoint) //if user tapped press/flag toggle button
        {
            clicked(theLabel : toggleButton)
        }
    }
    
    func calcNumberArray() //does calculations and fills the numberArray with the vicinity numbers
    {
        for row in 0...7
        {
            for col in 0...7
            {
                if bombArray[row][col]
                {
                    numberArray[row][col] = -1 //invalid value because its a bomb
                }
                else
                {
                    var counter = 0
                    counter += checkSpecific(row: row-1, col: col)   //top
                    counter += checkSpecific(row: row, col: col+1)   //right
                    counter += checkSpecific(row: row+1, col: col)   //bottom
                    counter += checkSpecific(row: row, col: col-1)   //left
                    counter += checkSpecific(row: row-1, col: col-1) //upper left
                    counter += checkSpecific(row: row-1, col: col+1) //upper right
                    counter += checkSpecific(row: row+1, col: col+1) //bottom right
                    counter += checkSpecific(row: row+1, col: col-1) //bottom left
                    numberArray[row][col] = counter
                }
            }
        }
    }
    
    func checkSpecific(row : Int, col : Int) -> Int //checks a specific row and col to see if there is a bomb there. return 1 = bomb, 0 = no bomb
    {
        if row<0 || row>7 || col<0 || col>7
        {
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
    
    func layImageViews() //lays blank image views in 8x8 pattern and adds image view objects to imageViews[] in order
    {
        imageViews = []
        let numAcross = CGFloat(8)
        let indWidth = self.view.frame.width/numAcross - 5/numAcross - 5
        for row in 1...8
        {
            var tempRow = [UIImageView]()
            for col in 1...Int(numAcross)
            {
                let imageView = UIImageView(image: #imageLiteral(resourceName: "newBlank"))
                imageView.frame = CGRect(x: self.view.frame.minX+(indWidth)*CGFloat(col)-indWidth/2,
                                         y: (self.view.frame.maxY-450)+(indWidth)*CGFloat(row),
                                         width: indWidth,
                                         height: indWidth)
                imageView.accessibilityIdentifier = "\(row-1)\(col-1)"
                view.addSubview(imageView)
                tempRow.append(imageView) //adding UIImageView to temporary array tempRow[]
            }
            imageViews.append(tempRow) //adding temporary array of UIImageViews to global 2D array [[imageViews]]
        }
    }
    
    func goTapped() //resets the screen with inputted number of bombs or 10 if the input is invalid
    {
        var valueGood = false
        bombInput.resignFirstResponder() //hides number pad
        layImageViews() //re-lays blank squares
        toggleButton.image = #imageLiteral(resourceName: "togglePress") //changing toggle back to 'press':
        toggleState = "press"
        numBombs = 10 //default number of bombs
        if let num = Int(bombInput.text!) //changes numBombs to be the bomb user input as long as it is a valid input
        {
            if num>4 && num<21
            {
                numBombs = num
                valueGood = true
            }
        }
        if !valueGood
        {
            bombInput.text = ""
        }
        for row in 0...7 //sets all bomb values to false (no bombs)
        {
            for col in 0...7
            {
                bombArray[row][col] = false
            }
        }
        for _ in 0..<numBombs //adds 'numBombs' number of bombs to bomb array
        {
            bombArray[rand(lim: 8)][rand(lim: 8)] = true
        }
        calcNumberArray()
        bombs.text = "Bombs: \(numBombs)"
        lose = false //the player has not lost
    }
    
    func reset() //resets the screen with 10 bombs
    {
        layImageViews() //re-lays blank squares
        toggleButton.image = #imageLiteral(resourceName: "togglePress") //changing toggle back to 'press':
        toggleState = "press"
        bombInput.text = "" //sets the bomb input field to blank
        bombInput.placeholder = "Custom" //adds 'custom' gray placeholder to bomb input field
        numBombs = 10 //default number of bombs
        for row in 0...7 //sets all bomb values to false (no bombs)
        {
            for col in 0...7
            {
                bombArray[row][col] = false
            }
        }
        var countdown = numBombs
        while countdown>0 //adds 'numBombs' number of bombs to bomb array
        {
            let row = rand(lim: 8) //random row and col for in the bomb array:
            let col = rand(lim: 8)
            if bombArray[row][col] == false //if its not already a bomb
            {
                bombArray[row][col] = true //make it a bomb
                countdown -= 1 //and now we have one less bomb to add
            }
        }
        calcNumberArray()
        bombs.text = "Bombs: \(numBombs)" //displays number of bombs in label
        lose = false //the player has not lost
    }
    
    func rand(lim : Int) -> Int //returns a random integer from including zero up to but not including parameter lim
    {
        return Int(arc4random_uniform(UInt32(lim)))
    }
    
    @IBAction func onResetTapped(_ sender: Any) //as long as the player hasnt lost, reset the screen
    {
        if lose==false
        {
            reset()
        }
    }
    
    @IBAction func onGoTapped(_ sender: Any) //as long as the player hasnt lost, reset the screen with their inputted number of bombs
    {
        if lose==false
        {
            goTapped()
        }
    }
    
    @IBAction func unwindToInitialViewController(segue:UIStoryboardSegue) //allows player to unwind from win/lose screens back to main playing screen
    {
    }
}

