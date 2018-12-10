//
//  SetGame.swift
//  SetGame
//
//  Created by Zachery Miller on 10/2/18.
//  Copyright © 2018 Zachery Miller. All rights reserved.
//

import Foundation

class SetGame {
    
    // MARK: constants
    let TOPCARD = 0
    let MAXNUMBEROFSELECTEDCARDS = 3

    // MARK: properties
    var deck = [Card]()
    var playableCards = [Card]()
    var score = 0
    var selectedCards = [Int]()
    var gameOver = false
    
    // MARK: init
    init() {
        for number in 0..<3 {
            for shape in 0..<3 {
                for color in 0..<3 {
                    for shading in 0..<3 {
                        let card = Card(number: number, shape: shape, color: color, shading: shading)
                        deck.append(card)
                    }
                }
            }
        }
        
        shuffle()
        
        let numPlayableCards = 12
        
        for _ in 0..<numPlayableCards {
            playableCards.append(deck.removeFirst())
        }
    }
    
    // MARK: public functions    
    func checkForSet() -> Bool {

        var isASet = true

        if ((playableCards[selectedCards[0]].number == playableCards[selectedCards[1]].number && playableCards[selectedCards[1]].number == playableCards[selectedCards[2]].number) ||
            (playableCards[selectedCards[0]].number != playableCards[selectedCards[1]].number && playableCards[selectedCards[1]].number != playableCards[selectedCards[2]].number && playableCards[selectedCards[0]].number != playableCards[selectedCards[2]].number))
            {
                if ((playableCards[selectedCards[0]].shape == playableCards[selectedCards[1]].shape && playableCards[selectedCards[1]].shape == playableCards[selectedCards[2]].shape) ||
                    (playableCards[selectedCards[0]].shape != playableCards[selectedCards[1]].shape && playableCards[selectedCards[1]].shape != playableCards[selectedCards[2]].shape && playableCards[selectedCards[0]].shape != playableCards[selectedCards[2]].shape))
                {
                    if ((playableCards[selectedCards[0]].color == playableCards[selectedCards[1]].color && playableCards[selectedCards[1]].color == playableCards[selectedCards[2]].color) ||
                        (playableCards[selectedCards[0]].color != playableCards[selectedCards[1]].color && playableCards[selectedCards[1]].color != playableCards[selectedCards[2]].color && playableCards[selectedCards[0]].color != playableCards[selectedCards[2]].color))
                    {
                        if ((playableCards[selectedCards[0]].shading == playableCards[selectedCards[1]].shading && playableCards[selectedCards[1]].shading == playableCards[selectedCards[2]].shading) ||
                            (playableCards[selectedCards[0]].shading != playableCards[selectedCards[1]].shading && playableCards[selectedCards[1]].shading != playableCards[selectedCards[2]].shading && playableCards[selectedCards[0]].shading != playableCards[selectedCards[2]].shading))
                        {
                            isASet = true
                        }
                    }
                }
        }

        return isASet
    }
    
    func shufflePlayableCards() {
        for index in 0..<playableCards.count {
            let rand = Int(arc4random_uniform(UInt32(playableCards.count)))
            let card = playableCards[index]
            playableCards[index] = playableCards[rand]
            playableCards[rand] = card
        }
    }

    // MARK: private functions

    private func shuffle() {
        for index in 0..<deck.count {
            let rand = Int(arc4random_uniform(UInt32(deck.count)))
            let card = deck[index]
            deck[index] = deck[rand]
            deck[rand] = card
        }
    }
    

    
}
