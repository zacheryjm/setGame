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
    @IBOutlet weak var GameOverLabel: UILabel!
    
    
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
            
            if (cardIndex < game.playableCards.count) {
                game.chooseCard(at : cardIndex)
                updateViewFromModel()
            }
        }
    }
    
    func updateViewFromModel() {
        
        if game.gameOver {
            GameOverLabel.text = "Game Over!"
            scoreLabel.text = "Final Score: \(game.score)"
            cardSelectionLabel.text = ""

        }
    
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            button.layer.borderWidth = 0.0

            if index < game.playableCards.count {
                let card = game.playableCards[index]
                
                let cardValue = setCardFaceValue(for: card)
                button.setAttributedTitle(cardValue, for: UIControlState.normal)
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
        
        var selectionString : NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        if game.selectedCards.count > 0 {
            let card1 = game.playableCards[game.selectedCards[0]]
            selectionString = NSMutableAttributedString(string: "Selection: ")
            selectionString.append(setCardFaceValue(for: card1))

        }
        if game.selectedCards.count > 1 {
            let card2 = game.playableCards[game.selectedCards[1]]
            selectionString.append(NSAttributedString(string: " + "))
            selectionString.append(setCardFaceValue(for: card2))
        }
        if game.selectedCards.count > 2 {
            let card3 = game.playableCards[game.selectedCards[2]]
            selectionString.append(NSAttributedString(string: " + "))
            selectionString.append(setCardFaceValue(for: card3))
        }
        
        cardSelectionLabel.attributedText = selectionString

    }
    
    func setCardFaceValue(for card : Card) -> NSAttributedString {
        
        var shapeOnCard : String
        
        switch card.shape {
        case 0:
            shapeOnCard = "▲"
            break
        case 1:
            shapeOnCard = "■"
            break
        default:
            shapeOnCard =  "●"
        }
        
        var cardFaceText = ""
        
        for _ in 0...card.number {
            cardFaceText.append(shapeOnCard)
        }
        
        var cardColor : UIColor
        
        switch card.color {
        case 0:
            cardColor = UIColor.red
            break
        case 1:
            cardColor = UIColor.green
            break
        default:
            cardColor = UIColor.blue
        }
        
        var attributes : [NSAttributedStringKey : Any]
        
        switch card.shading {
        case 0:
            attributes = [.strokeWidth : -3.0, .foregroundColor : cardColor]
            break
        case 1:
            attributes = [.strokeWidth : -3.0, .foregroundColor : cardColor.withAlphaComponent(CGFloat(0.15))]
            break
        default:
            attributes = [.strokeWidth : 3.0, .foregroundColor : cardColor]

        }
        
        let cardFaceValue = NSAttributedString(string: cardFaceText, attributes: attributes)
        
        return cardFaceValue
        
    }
    
}










