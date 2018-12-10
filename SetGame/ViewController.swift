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
        updateView()
    }
    
    // MARK: actions
    @IBAction func NewGameButton(_ sender: UIButton) {
        game = SetGame()
        initializeGrid()
        updateView()
    }
    @IBAction func DealThreeCardsButton(_ sender: UIButton) {
        dealThreeMoreCards()
    }
    
    @IBAction func touchCard(_ sender: UITapGestureRecognizer) {
        guard let tappedCard = sender.view as? CardView else { return }

        if let cardIndex = cardsInPlayView.subviews.index(of: tappedCard) {
            
            if game.selectedCards.contains(cardIndex) {
                deselectCard(at: cardIndex)
            }
            else {
                chooseCard(at: cardIndex)
            }
            updateView()
        }
    }
    
    @IBAction func handleSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dealThreeMoreCards()
            updateView()
        }
    }
    @IBAction func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.shufflePlayableCards()
            updateView()
        }
    }
    
    // MARK: outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardsInPlayView: UIView!
    @IBOutlet weak var deckButton: UIButton!
    
    // MARK: properties
    private lazy var game = SetGame()
    private lazy var grid = Grid(layout: .aspectRatio(CardSize.aspectRatio),frame: cardsInPlayView.bounds)

    
    // MARK: public functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initializeGrid()
    }
    
    // MARK: private functions

    private func updateView() {
        updateScoreLabel()
    }
    
    private func updateScoreLabel() {
        if game.gameOver {
            scoreLabel.text = "Game Over! Final Score: \(game.score)"
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func initializeGrid() {
        grid.frame = cardsInPlayView.bounds
        grid.cellCount = game.playableCards.count
        
        for cardView in cardsInPlayView.subviews {
            cardView.removeFromSuperview()
        }
        for index in 0..<grid.cellCount {
            let card = game.playableCards[index]
            addCardViewToGrid(at: index, for: card)
        }
    }
    
    private func addCardViewToGrid(at gridIndex : Int, for card : Card) {
        
        let deckFrame = deckButton.convert(deckButton.frame, to: cardsInPlayView)
        
        if let cellFrame = grid[gridIndex] {
            let cardView = CardView(frame: deckFrame,
                                    color : card.color, number : card.number,
                                    shading :  card.shading, shape : card.shape)
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(_:))))
            cardsInPlayView.addSubview(cardView)
            dealCardAnimation(for: gridIndex, with: cellFrame)
        }
        else {
            print("grid[\(index)] does not exist")
        }
    }
    
    private func updateCardBorder(for cardIndex : Int) {
        let cardView = cardsInPlayView.subviews[cardIndex] as! CardView
        
        if game.selectedCards.contains(cardIndex) {
            cardView.borderWidth = CardSize.borderWidth
            
            if game.selectedCards.count < 3 {
                cardView.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
        else {
            cardView.borderWidth = 0.0
        }
    }
    
    private func chooseCard(at index : Int) {
        game.selectedCards.append(index)

        //Check for a set if 3 cards are selected
        if game.selectedCards.count == game.MAXNUMBEROFSELECTEDCARDS{
            checkForSet()
            game.selectedCards.removeAll()
        }
        //Not enough to check for set. Add to selected cards
        else {
            game.selectedCards.append(index)
            updateCardBorder(for: index)
        }
    }
    
    private func deselectCard(at index : Int) {
        if let indexToRemove = game.selectedCards.index(of: index) {
            game.selectedCards.remove(at: indexToRemove)
            updateCardBorder(for: index)
        }
    }
    
    private func checkForSet() {
        if game.checkForSet() {
            updateGameStateAfterSetMatched()
        }
        else {
            game.score -= 1
        }
    }
    
    private func updateGameStateAfterSetMatched() {
        game.score += 1
        
        let selectedCardsSortedDecending = game.selectedCards.sorted(by: { $0 > $1 })
        
        for i in selectedCardsSortedDecending.indices {
            
            if !game.deck.isEmpty {
                matchedCardAnimation(for: selectedCardsSortedDecending[i])
                addCardViewToGrid(at: selectedCardsSortedDecending[i], for: game.deck[game.TOPCARD])
                game.playableCards[selectedCardsSortedDecending[i]] = game.deck[game.TOPCARD]
                game.deck.remove(at: game.TOPCARD)
            }
            else {
                game.playableCards.remove(at: selectedCardsSortedDecending[i])
                
            }
        }
        if game.playableCards.isEmpty && game.deck.isEmpty {
            game.gameOver = true
        }
    }
    
    private func dealThreeMoreCards() {
        
        for _ in 0..<3 {
            if !game.deck.isEmpty {
                game.playableCards.append(game.deck[game.TOPCARD])
                game.deck.remove(at: game.TOPCARD)
            }
        }
        
        initializeGrid()
    }
    
    //MARK: Animations
    
    private func dealCardAnimation(for index : Int, with cellFrame : CGRect) {
        
        let cardToAnimate = cardsInPlayView.subviews[index] as! CardView
        let animationDelay = 0.1 * Double(exactly: index)!
        
        UIView.animate(withDuration: 2.0,
                       delay: animationDelay,
                       options: .curveEaseInOut,
                       animations: {
                        self.deckButton.isUserInteractionEnabled = false
                        self.cardsInPlayView.subviews[index].frame = cellFrame.insetBy(dx: CardSize.inset, dy: CardSize.inset)
        },
                       completion: { _ in
                        UIView.transition(with: cardToAnimate,
                                          duration: 0.6,
                                          options: .transitionFlipFromLeft,
                                          animations: {
                                            cardToAnimate.isFaceUp = true
                                            cardToAnimate.setNeedsDisplay()
                        },
                                          completion: { (_) in
                                            self.updateCardBorder(for: index)
                                            self.deckButton.isUserInteractionEnabled = true
                        })
                        
        })
    }
    
    private func matchedCardAnimation(for index : Int) {
        let matchedCard = cardsInPlayView.subviews[index] as! CardView
        
        UIView.transition(with: matchedCard,
                          duration: 0.6,
                          options: .curveEaseOut,
                          animations: {
                            matchedCard.alpha = 0.0
                            
                            },
                          completion: { _ in
                            matchedCard.removeFromSuperview()
        })

    }
    
    
}

extension ViewController {
    private struct CardSize {
        static let aspectRatio: CGFloat = 0.7
        static let borderWidth: CGFloat = 2.0
        static let inset: CGFloat = 4.0
    }
}






