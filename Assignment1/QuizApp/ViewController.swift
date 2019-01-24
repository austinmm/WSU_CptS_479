//
//  ViewController.swift
//  QuizApp
//
//  Created by Austin Marino on 1/9/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var LastButtonSelected: Any!;
    @IBOutlet weak var QuizResult: UILabel!;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        QuizResult.isHidden = true;

    }
    func ButtonSelected(_ sender: UIButton){
        QuizResult.isHidden = false;
        if LastButtonSelected is UIButton{
            (LastButtonSelected as! UIButton).setTitleColor(UIColor.blue, for: UIControl.State.normal);
        }
        LastButtonSelected = sender;
    }
    
    @IBAction func BillGates(_ sender: UIButton) {
        ButtonSelected(sender);
        QuizResult.text = "Incorrect...";
        sender.setTitleColor(UIColor.red, for: UIControl.State.normal);
    }
    @IBAction func SteveJobs(_ sender: UIButton) {
        ButtonSelected(sender);
        QuizResult.text = "Incorrect...";
        sender.setTitleColor(UIColor.red, for: UIControl.State.normal);
    }
    @IBAction func TimCook(_ sender: UIButton) {
        ButtonSelected(sender);
        QuizResult.text = "Correct!";
        sender.setTitleColor(UIColor.green, for: UIControl.State.normal);
    }
    @IBAction func LarryHolder(_ sender: UIButton) {
        ButtonSelected(sender);
        QuizResult.text = "Incorrect...";
        sender.setTitleColor(UIColor.red, for: UIControl.State.normal);
    }
    
}

