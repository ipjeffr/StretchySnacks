//
//  ViewController.swift
//  StretchySnacks
//
//  Created by Jeffrey Ip on 2016-04-14.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    var foodArray: [String] = []
    var stackView: UIStackView! = nil
//    var toggleSnackPosition: NSLayoutConstraint!
    var snackLabel: UILabel? = nil
    
    let imageDictionary = [
        "Oreos": UIImage(named: "oreos"),
        "Pizza Pockets": UIImage(named: "pizza_pockets"),
        "Pop Tarts": UIImage(named: "pop_tarts"),
        "Popsicle": UIImage(named: "popsicle"),
        "Ramen": UIImage(named:"ramen"),
    ]
    
    func imageButton(withImage image: UIImage, label: String) -> FoodButton
    {
        let newButton = FoodButton(type: .Custom)
        newButton.setImage(image, forState: .Normal)
        newButton.addTarget(self, action: #selector(ViewController.didPressFoodButton), forControlEvents: .TouchUpInside)
        return newButton
    }
    
    func displayStackView(){
        var buttonArray = [FoodButton]()
        for (myKey, myValue) in imageDictionary{
            let foodButton: FoodButton = imageButton(withImage: myValue!, label: myKey)
            foodButton.foodLabel = myKey
            foodButton.foodImage = myValue
            buttonArray += [foodButton]
        }
        let stackV = UIStackView(arrangedSubviews: buttonArray)
        self.stackView = stackV
        self.stackView.axis = .Horizontal
        self.stackView.distribution = .FillEqually
        self.stackView.alignment = .Fill
        self.stackView.spacing = 5
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        self.stackView.trailingAnchor.constraintEqualToAnchor(self.navBar.trailingAnchor).active = true
        self.stackView.leadingAnchor.constraintEqualToAnchor(self.navBar.leadingAnchor).active = true
        self.stackView.bottomAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor).active = true
        self.stackView.heightAnchor.constraintEqualToAnchor(self.navBar.heightAnchor, multiplier: 0.5).active = true
        
        self.stackView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        displayStackView()
        addSnackLabel()
    }
    
    func addSnackLabel() {
        let snackLabel = UILabel()
        self.snackLabel = snackLabel
        self.snackLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.navBar.addSubview(snackLabel)
        self.snackLabel!.text = "SNACKS"

        let centerXConstraint = NSLayoutConstraint(item: self.snackLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self.navBar, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let centerYConstraint = NSLayoutConstraint(item: self.snackLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self.navBar, attribute: .CenterY, multiplier: 1, constant: 0)
        centerYConstraint.identifier = "CenterY"
        
        self.navBar.addConstraints([centerXConstraint, centerYConstraint])
    }
    
    func adjustSnackLabel() {
        for var constraint in self.navBar.constraints {
            if constraint.identifier == "CenterY" {
                constraint.active = false
                constraint = NSLayoutConstraint(item: self.snackLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self.navBar, attribute: .CenterY, multiplier: 1, constant: -40)
                constraint.active = true
                constraint.identifier = "CenterY"
                self.snackLabel!.text = "Add a SNACK"
            }
        }
    }
    
    func restoreSnackLabel() {
        for var constraint in self.navBar.constraints {
            if constraint.identifier == "CenterY" {
                constraint.active = false
                constraint = NSLayoutConstraint(item: self.snackLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self.navBar, attribute: .CenterY, multiplier: 1, constant: 0)
                constraint.active = true
                constraint.identifier = "CenterY"
                self.snackLabel!.text = "SNACK"
            }
        }
    }
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = foodArray[indexPath.row]
        return cell
    }
    
    // MARK: Actions
    func didPressFoodButton(sender: FoodButton) {
        foodArray.append(sender.foodLabel!)
        print("\(sender.foodLabel)")
        tableView.reloadData()
    }
    
    @IBAction func didPressButton(sender: UIButton) {
        sender.selected = !sender.selected
        
        if (sender.selected) {
            print("button pressed")
            rotateButton()
            dropNavBarHeight()
            adjustSnackLabel()
        } else if (!sender.selected){
            print("button UN-pressed")
            rotateButtonBack()
            raiseNavBarHeight()
            restoreSnackLabel()
        }
    }
    
    // MARK: Animations
    func rotateButton() {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .CurveEaseOut, animations: {
            self.plusButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            }, completion: nil)
    }
    
    func rotateButtonBack() {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .CurveEaseOut, animations: {
            self.plusButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            }, completion: nil)
    }
    
    func dropNavBarHeight() {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .CurveEaseOut, animations: {
            self.navBarHeight.constant = 200
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.stackView.hidden = false
    }
    
    func raiseNavBarHeight() {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .CurveEaseOut, animations: {
            self.navBarHeight.constant = 64
            self.view.layoutIfNeeded()
            }, completion: nil)
        self.stackView.hidden = true
    }

}

