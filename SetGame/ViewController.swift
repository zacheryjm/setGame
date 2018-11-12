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
        updateView()
    }
    @IBAction func DealThreeCardsButton(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateView()
    }
    
    @IBAction func touchCard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: cardsInPlayView)
            
            if let tappedView = cardsInPlayView.hitTest(location, with: nil) {
                if let cardIndex = cardsInPlayView.subviews.index(of: tappedView) {
                    game.chooseCard(at: cardIndex)
                    updateView()
                }
            }
        }
    }
    
    @IBAction func handleSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.dealThreeMoreCards()
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
    
    // MARK: properties
    private lazy var game = SetGame()
    private lazy var grid = Grid(layout: .aspectRatio(CardSize.aspectRatio),frame: cardsInPlayView.bounds)

    
    // MARK: public functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCardViewsToGrid()
    }
    
    // MARK: private functions

    private func updateView() {
        updateScoreLabel()
        addCardViewsToGrid()
        addBorders()
    }
    
    private func updateScoreLabel() {
        if game.gameOver {
            scoreLabel.text = "Game Over! Final Score: \(game.score)"
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func addCardViewsToGrid() {
        grid.frame = cardsInPlayView.bounds
        grid.cellCount = game.playableCards.count
        
        for cardView in cardsInPlayView.subviews {
            cardView.removeFromSuperview()
        }
        
        for index in 0..<grid.cellCount {
            if let cellFrame = grid[index] {
                let card = game.playableCards[index]
                let cardView = CardView(frame: cellFrame.insetBy(dx: CardSize.inset, dy: CardSize.inset),
                                        color : card.color, number : card.number,
                                        shading :  card.shading, shape : card.shape)
                
                cardsInPlayView.addSubview(cardView)
            } else {
                print("grid[\(index)] does not exist")
            }
        }
    }
    
    private func addBorders() {
        let selectedCards = game.selectedCards
        let playableCards = game.playableCards
        
        for index in playableCards.indices {
            let cardView = cardsInPlayView.subviews[index] as! CardView
            
            if selectedCards.contains(index) {
                cardView.borderWidth = CardSize.borderWidth
                
                if selectedCards.count < 3 {
                    cardView.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                } else {
                    cardView.borderColor = game.checkForSet() ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            } else {
                cardView.borderWidth = 0.0
            }
        }
    }
}

extension ViewController {
    private struct CardSize {
        static let aspectRatio: CGFloat = 0.7
        static let borderWidth: CGFloat = 2.0
        static let inset: CGFloat = 4.0
    }
}






