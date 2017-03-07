//
//  Foods.swift
//  SpriteKitGame
//
//  Created by Marina Kashgarian on 3/1/17.
//  Copyright © 2017 Marina Kashgarian. All rights reserved.
//

import Foundation
import SpriteKit


class Foods {
    
//    var collection = [Foods]()
    
    var carb_count: Int
    // save number of carbs
    
    var carb: Bool
    // save whether or not this is a carb
    
    var foodType: SKSpriteNode
    // save what kind of food it is (matches with sprite?)
    
    var sprite: SKSpriteNode?
    
    init(carb_count: Int, carb: Bool, foodType: SKSpriteNode) {
        self.carb_count = carb_count
        self.carb = carb
        self.foodType = foodType
    
            
    
        
    }
    
    
    // to print something useful
    var description: String {
        return "type:\(foodType) carb count:\(carb_count) carb or no?:\(carb)"
    }
}

