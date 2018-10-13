//
//  ViewController.swift
//  Flashcard
//
//  Created by Colton Lipchak on 10/13/18.
//  Copyright © 2018 clipTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var AnswerLabel: UILabel!
    
    @IBOutlet weak var cardContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        QuestionLabel.layer.cornerRadius = 20.0
        AnswerLabel.layer.cornerRadius = 20.0
        
        QuestionLabel.clipsToBounds = true
        AnswerLabel.clipsToBounds = true
       
        
        
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if(QuestionLabel.isHidden){
            QuestionLabel.isHidden = false;
        }
        else{
            QuestionLabel.isHidden = true
    }
    }
    
}

