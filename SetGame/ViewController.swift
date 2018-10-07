//
//  ViewController.swift
//  SetGame
//
//  Created by Zachery Miller on 9/22/18.
//  Copyright © 2018 Zachery Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        updateViewFromModel()
    }
   
    lazy var game = SetGame()
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardSelectionLabel: UILabel!
    
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func NewGame(_ sender: UIButton) {
        
        game = SetGame()
        cardSelectionLabel.text = ""
        updateViewFromModel()
    }
    
    @IBAction func DealThreeMoreCardsButton(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateViewFromModel()
        
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardIndex = cardButtons.index(of : sender) {
            
            if (cardIndex < game.playableCards.count) && !(game.selectedCards.contains(cardIndex)) {
                game.chooseCard(at : cardIndex)
                updateViewFromModel()
            }
        }
    }
    
    func updateViewFromModel() {
    
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            button.layer.borderWidth = 0.0

            if index < game.playableCards.count {
                let card = game.playableCards[index]
                
                //TODO: Added test function here. Need to change it back and change button.setTitle to button.setAttributedTitle
                let cardValue = cardFaceTestFunction(for : card)
                button.setTitle(cardValue, for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

                if game.selectedCards.contains(index) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.yellow.cgColor
                }
                
                scoreLabel.text = "Score: \(game.score)"
                updateCardSelectionLabel()

            }
            else {
                
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                button.setAttributedTitle(nil, for: UIControlState.normal)
                button.setTitle(nil, for: UIControlState.normal)

            }
            
        }
        
    }
    
    func updateCardSelectionLabel() {
        if game.selectedCards.count == 1 {
            let card1 = game.playableCards[game.selectedCards[0]]
            cardSelectionLabel.text = "Selection: \(cardFaceTestFunction(for: card1))"
        }
        if game.selectedCards.count == 2 {
            let card1 = game.playableCards[game.selectedCards[0]]
            let card2 = game.playableCards[game.selectedCards[1]]
            cardSelectionLabel.text = "Selection: \(cardFaceTestFunction(for: card1)) + \(cardFaceTestFunction(for: card2))"
        }
        if game.selectedCards.count == 3 {
            let card1 = game.playableCards[game.selectedCards[0]]
            let card2 = game.playableCards[game.selectedCards[1]]
            let card3 = game.playableCards[game.selectedCards[2]]
            cardSelectionLabel.text = "Selection: \(cardFaceTestFunction(for: card1)) + \(cardFaceTestFunction(for: card2)) + \(cardFaceTestFunction(for: card3))"
        }
    }
    
    func cardFaceTestFunction(for card : Card) -> String{
        
        var val = ""
        
        val.append(String(card.number))
        val.append(String(card.shape))
        val.append(String(card.color))
        val.append(String(card.shading))

        return val
    }
    
}






























