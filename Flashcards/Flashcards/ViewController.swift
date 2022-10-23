//
//  ViewController.swift
//  Flashcards
//
//  Created by Jodie Jackson on 10/2/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

   
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What is (5 x 5)/5?" , answer: "5" )
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        
        updateLabels()
        
        updateNextPrevButtons()
        
        animateCardOut()
    }
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        
        updateNextPrevButtons()
        
        updateLabels()
        
        animateCardIn()

    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            if self.frontLabel.isHidden == false {
                self.frontLabel.isHidden = true
            }
            else if (self.frontLabel.isHidden == true){
                self.frontLabel.isHidden = false
            }
            
        }
    }
   
      
    func saveALLFlashcardToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        
        UserDefaults.standard.set(dictionaryArray, forKey:"flashcards")
        print("Flashcards saved to UserDefaults")
    }
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
        
            let savedCards = dictionaryArray.map { (dictionary) -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
        flashcards.append(contentsOf: savedCards)
    }
}
    func updateLabels() {
        
        let currentflashcard = flashcards[currentIndex]
        
        frontLabel.text = currentflashcard.question
        backLabel.text = currentflashcard.answer
    }
    func updateNextPrevButtons() {
        
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: {
            (finished) in
            
            self.updateLabels()
            self.animateCardIn()
        })
    }
    func animateCardIn() {
        self.frontLabel.isHidden = false
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
            
        }
    }
    func animateCardOutBackWard(){
            self.frontLabel.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)}, completion: {finished in
                    self.updateLabels()
                    self.animateCardInBackWard()
            })
        }
        
        func animateCardInBackWard(){
            self.frontLabel.isHidden = false
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            
            UIView.animate(withDuration: 0.3) {
                self.card.transform = CGAffineTransform.identity
            }
        }
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
       
        flashcards.append(flashcard)
       
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
       
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        
        updateLabels()
        
        saveALLFlashcardToDisk()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
}

