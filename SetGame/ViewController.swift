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
        initializeCardsInPlayViewGrid()
        updateView()
    }
    @IBAction func DealThreeCardsButton(_ sender: UIButton) {
        dealMoreCards()
    }
    
    @IBAction func touchCard(_ sender: UITapGestureRecognizer) {
        guard let tappedCard = sender.view as? CardView else { return }
        
        if let cardViewIndex = cardsInPlayView.subviews.index(of: tappedCard) {
            if game.selectedCards.contains(cardViewIndex) {
                deselectCard(at: cardViewIndex)
            }
            else {
                chooseCard(at: cardViewIndex)
            }
            updateView()
        }
    }
    
    @IBAction func handleSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dealMoreCards()
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
    private var gameInitialized = false
    
    // MARK: public functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !gameInitialized {
            initializeCardsInPlayViewGrid()
        }
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
    
    private func initializeCardsInPlayViewGrid() {
        grid.frame = cardsInPlayView.bounds
        grid.cellCount = game.playableCards.count
        
        for cardView in cardsInPlayView.subviews {
            cardView.removeFromSuperview()
        }
        for index in 0..<grid.cellCount {
            let card = game.playableCards[index]
            addCardViewToGrid(at: index, for: card)
        }
        
        gameInitialized = true
    }
    
    private func addCardViewToGrid(at index : Int, for card : Card) {
        
        if let cellFrame = grid[index] {
            let cardView = createCardView(at: index, for: card)
            
            cardsInPlayView.insertSubview(cardView, at: index)
            dealCardAnimation(for: index, with: cellFrame)
        }
        else {
            print("grid[\(index)] does not exist")
        }
    }
    
    private func createCardView(at index : Int, for card : Card) -> CardView {
        let deckFrame = deckButton.convert(deckButton.frame, to: cardsInPlayView)
        
        let cardView = CardView(frame: deckFrame,
                                color : card.color, number : card.number,
                                shading :  card.shading, shape : card.shape)
        
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(_:))))
        
        return cardView
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
        cardView.setNeedsDisplay()
    }
    
    private func updateFramesForCardViews() {
        
        grid.cellCount = game.playableCards.count
        
        for index in cardsInPlayView.subviews.indices {
            animateCardResize(for: index)
        }
    }
    
    //TODO: Update border after incorrect guess
    private func chooseCard(at index : Int) {
        game.selectedCards.append(index)

        //Check for a set if 3 cards are selected
        if game.selectedCards.count == game.MAXNUMBEROFSELECTEDCARDS{
            checkForSet()
            game.selectedCards.removeAll()
        }
        
        updateCardBorder(for: index)
        
    }
    
    private func deselectCard(at cardViewIndex : Int) {
        if let indexToRemove = game.selectedCards.index(of: cardViewIndex) {
            game.selectedCards.remove(at: indexToRemove)
            updateCardBorder(for: cardViewIndex)
        }
    }
    
    private func checkForSet() {
        if game.checkForSet() {
            updateGameStateAfterSetMatched()
            updateViewAfterSetMatched()
        }
        else {
            game.score -= 1
        }
    }

    private func updateGameStateAfterSetMatched() {
        game.score += 1
        
        let selectedCardsSortedDecending = game.selectedCards.sorted(by: { $0 > $1 })
        
        for selectedCardIndex in selectedCardsSortedDecending {
            
            if !game.deck.isEmpty {
                game.playableCards[selectedCardIndex] = game.deck.remove(at: game.TOPCARD)
            }
            else {
                game.playableCards.remove(at: selectedCardIndex)
            }
        }
        if game.playableCards.isEmpty && game.deck.isEmpty {
            game.gameOver = true
        }
    }
    
    private func updateViewAfterSetMatched() {
        
        for matchedCardIndex in game.selectedCards {
            matchedCardAnimation(for: matchedCardIndex)
            removeCardFromSuperView(for: matchedCardIndex)
            
            let card = game.playableCards[matchedCardIndex]
            addCardViewToGrid(at: matchedCardIndex, for: card)
            
        }
    }
    
    private func removeCardFromSuperView(for index: Int) {
        let matchedCardView = cardsInPlayView.subviews[index] as! CardView
        matchedCardView.removeFromSuperview()
    }
    
    private func dealMoreCards() {
        
        var numberOfCardsToDeal = 0
        for _ in 0..<3 {
            if !game.deck.isEmpty {
                game.playableCards.append(game.deck[game.TOPCARD])
                game.deck.remove(at: game.TOPCARD)
                numberOfCardsToDeal += 1
            }
        }
        updateFramesForCardViews()
        for index in game.playableCards.count-numberOfCardsToDeal..<game.playableCards.count {
            let card = game.playableCards[index]
            addCardViewToGrid(at: index, for: card)
        }
    }
    
    //MARK: Animations
    
    private func dealCardAnimation(for index : Int, with cellFrame : CGRect) {
        
        let cardToAnimate = cardsInPlayView.subviews[index] as! CardView
        let animationDelay = 0.1 * Double(exactly: index)!
        
        UIView.animate(withDuration: 1.2,
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
        matchedCard.isMatched = true
        
        UIView.transition(with: matchedCard,
                          duration: 0.6,
                          options: .curveEaseOut,
                          animations: {
                            matchedCard.alpha = 0.0
                            })

    }
    
    private func animateCardResize(for cardIndex : Int) {
        
        let cardView = cardsInPlayView.subviews[cardIndex] as! CardView

        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        let cellFrame = self.grid[cardIndex]!
                        cardView.frame = cellFrame.insetBy(dx: CardSize.inset, dy: CardSize.inset)
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






