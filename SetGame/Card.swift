//
//  Card.swift
//  SetGame
//
//  Created by Zachery Miller on 10/2/18.
//  Copyright © 2018 Zachery Miller. All rights reserved.
//

import Foundation

class Card {
    
    var number : Int
    var shape : Int
    var color : Int
    var shading : Int
    
    
    init(number : Int,  shape : Int, color : Int, shading : Int) {
        self.number = number
        self.shape = shape
        self.color = color
        self.shading = shading
    }
    
}
