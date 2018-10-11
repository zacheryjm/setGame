//
//  SetGame.swift
//  SetGame
//
//  Created by Zachery Miller on 10/2/18.
//  Copyright © 2018 Zachery Miller. All rights reserved.
//

import Foundation

class SetGame {
    
    var deck = [Card]()
    let maxNumberOfPlayableCards = 24
    var playableCards = [Card]()
    let maxNumberOfSelectedCards = 3
    var score = 0
    var selectedCards = [Int]()
    
    func dealThreeMoreCards() {
        
        for index in 0..<3 {
            if !deck.isEmpty && playableCards.count < maxNumberOfPlayableCards{
                playableCards.append(deck[index])
                deck.remove(at: index)
            }
        }
    }
    
    func chooseCard(at index : Int) {
        
        if selectedCards.count == maxNumberOfSelectedCards {
            selectedCards.removeAll()
            selectedCards.append(index)
        }
        else if selectedCards.contains(index) {
            if let indexToRemove = selectedCards.index(of: index) {
                selectedCards.remove(at: indexToRemove)
            }
        }
        else if selectedCards.count == maxNumberOfSelectedCards-1 {
            selectedCards.append(index)
            
            if checkForSet() {
                score += 1
                selectedCards.removeAll()

                
                for i in selectedCards.indices {
                    playableCards.remove(at: i)
                    
                    if !deck.isEmpty {
                        playableCards.append(deck[i])
                        deck.remove(at: i)
                    }
                    
                }
            }
            else {
                score -= 1
            }
        }
        else {
            selectedCards.append(index)
        }
    }
    
    func checkForSet() -> Bool {
        
        var isASet = false
        
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

    func shuffle() {
        for index in 0..<deck.count {
            let rand = Int(arc4random_uniform(UInt32(deck.count)))
            let card = deck[index]
            deck[index] = deck[rand]
            deck[rand] = card
            
        }
    }
    

    
}
