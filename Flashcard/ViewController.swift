//
//  ViewController.swift
//  Flashcard
//
//  Created by Colton Lipchak on 10/13/18.
//  Copyright © 2018 clipTech. All rights reserved.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {


    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var AnswerLabel: UILabel!
    
    @IBOutlet weak var cardContainer: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        readSavedFlashcards()
        if(flashcards.count == 0){
            updateFlashcard(question: "What is the capital of Brazil?", answer: "Brasilia")
        } else{
            updateLabels()
            updateNextPrevButtons()
        }
        
        cardContainer.layer.shadowRadius = 15.0
        cardContainer.layer.shadowOpacity = 0.2
        
        QuestionLabel.layer.cornerRadius = 20.0
        AnswerLabel.layer.cornerRadius = 20.0

        QuestionLabel.clipsToBounds = true
        AnswerLabel.clipsToBounds = true
        
        
        
    }

    //reaction to user tapping on a flashcard
    @IBAction func didTapOnFlashcard(_ sender: Any) {
       flipFlashcard()
    }
    
    //animation to flip the flashcard
    func flipFlashcard(){
        UIView.transition(with: cardContainer, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if(self.QuestionLabel.isHidden){
                self.QuestionLabel.isHidden = false;
            }
            else{
                self.QuestionLabel.isHidden = true
            }
        })
    }
    
    func animateNextCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.cardContainer.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            //update labels
            self.updateLabels()
            
            //run other animation
            self.animateNextCardIn()
            
        })
    }
    
    func animateNextCardIn(){
        //start on the right side (dont animate this)
        cardContainer.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        //animate card going back to its original position
        UIView.animate(withDuration: 0.3){
            self.cardContainer.transform = CGAffineTransform.identity
        }
    }
    
    func animatePrevCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.cardContainer.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            
            //update labels
            self.updateLabels()
            
            //run other animation
            self.animatePrevCardIn()
            
        })
    }
    
    func animatePrevCardIn(){
        //start on the right side (dont animate this)
        cardContainer.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        //animate card going back to its original position
        UIView.animate(withDuration: 0.3){
            self.cardContainer.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //animates the card transition
        animateNextCardOut()
        
        //update index
        currentIndex = currentIndex + 1
        
        
        //update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //animates the card transition
        animatePrevCardOut()
        
        //update index
        currentIndex = currentIndex - 1
        
        //update buttons
        updateNextPrevButtons()
    }
    
    func updateLabels(){
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        QuestionLabel.text = currentFlashcard.question
        AnswerLabel.text = currentFlashcard.answer
    }
    
    func updateNextPrevButtons(){
        
        //Disable next button if at end
        if(currentIndex == flashcards.count-1){
            nextButton.isEnabled = false
        } else{
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at beginning
        if(currentIndex == 0){
            prevButton.isEnabled = false
        } else{
            prevButton.isEnabled = true
        }
        
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        QuestionLabel.text = flashcard.question
        AnswerLabel.text = flashcard.answer
        flashcards.append(flashcard)
        
        currentIndex = flashcards.count - 1
        
        print("added new flash card")
        print("We now have \(flashcards.count) flashcards")
        print("Our current index is \(currentIndex)")
        
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        
        //store flashcards
        saveAllFlashcardsToDisk()
        
    }
    
    func saveAllFlashcardsToDisk(){
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcards saved to User Defaults!")
        
    }
    
    func readSavedFlashcards(){
        //read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                //in here we know for sure that we have a dictionary
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            
            
        }
        
    }
    
}

