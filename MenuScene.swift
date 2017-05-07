//
//  MenuScene.swift
//  SpriteKitGame
//
//  Created by Marina Kashgarian on 3/23/17.
//  Copyright © 2017 Marina Kashgarian. All rights reserved.
//
import SpriteKit
import UIKit

import Foundation
class MenuScene: SKScene {
    
    
    let info = SKLabelNode(fontNamed: "Chalkduster")
    let music = SKLabelNode(fontNamed: "Chalkduster")
    var l1 = SKSpriteNode(imageNamed: "level_1_button")
    var l2 = SKSpriteNode(imageNamed: "level_2_button")
    var l3 = SKSpriteNode(imageNamed: "level_3_button")
    let bg = SKSpriteNode(imageNamed: "blue_screen")
    let logo = SKSpriteNode(imageNamed: "large_logo")
    let l1_howto = SKSpriteNode(imageNamed: "l1_instr")
    let l2_howto = SKSpriteNode(imageNamed: "l2_instr")
    let l3_howto = SKSpriteNode(imageNamed: "l3_instr")
    var chosen = false
    var instr1_up = false
    var instr2_up = false
    var instr3_up = false
    
    static var level = 0
    
    var l1instr = SKSpriteNode(imageNamed: "instructions_level_1")
    var l2instr = SKSpriteNode(imageNamed: "instructions_level_2")
    var l3instr = SKSpriteNode(imageNamed: "instructions_level_3")
    
    override func didMove(to view: SKView) {
        bg.size = self.frame.size
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -1
        addChild(bg)
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        logo.setScale(0.7)
        logo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        logo.zPosition = 1
        addChild(logo)
        
        l1.setScale(1.7)
        l1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        addChild(l1)
        l1instr.setScale(0.25)
        l1instr.position = CGPoint(x: size.width * 0.85, y: size.height * 0.6)
        addChild(l1instr)
        
        l2.setScale(1.7)
        l2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.4)
        addChild(l2)
        l2instr.setScale(0.25)
        l2instr.position = CGPoint(x: size.width * 0.85, y: size.height * 0.4)
        addChild(l2instr)
        
        l3.setScale(1.7)
        l3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        addChild(l3)
        l3instr.setScale(0.25)
        l3instr.position = CGPoint(x: size.width * 0.85, y: size.height * 0.2)
        addChild(l3instr)
        
        l1_howto.setScale(0.5)
        l1_howto.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        l1_howto.zPosition = -2
        addChild(l1_howto)
        
        l2_howto.setScale(0.5)
        l2_howto.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        l2_howto.zPosition = -2
        addChild(l2_howto)
        
        l3_howto.setScale(0.5)
        l3_howto.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        l3_howto.zPosition = -2
        addChild(l3_howto)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if (l1.contains(touchLocation) && !instr1_up && !instr2_up && !instr3_up) {
            MenuScene.level = 1
            chosen = true
        } else if (l2.contains(touchLocation) && !instr1_up && !instr2_up && !instr3_up) {
            chosen = true
            MenuScene.level = 2
        } else if (l3.contains(touchLocation) && !instr1_up && !instr2_up && !instr3_up) {
            chosen = true
            MenuScene.level = 3
        }
        if(MenuScene.level != 0 && chosen && !instr1_up && !instr2_up && !instr3_up) {
            let reveal = SKTransition.flipVertical(withDuration: 3)
            let scene = RoundSelect(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            chosen = false
        }
        
            
        if (instr1_up) {
            // if first instr page clicked
            l1_howto.zPosition = -2
            instr1_up = false
        }
        else if (instr2_up) {
            // if second instr page clicked
            l2_howto.zPosition = -2
            instr2_up = false
        }
        else if (instr3_up) {
            // if third instr page clicked
            l3_howto.zPosition = -2
            instr3_up = false
        }
        
        // instruction buttons
        else if l1instr.contains(touchLocation) {
            // if instruction button clicked
            l1_howto.zPosition = 3
            
            instr1_up = true
        }
        else if l2instr.contains(touchLocation) {
            // if instruction button clicked
            l2_howto.zPosition = 3
            
            instr2_up = true
        }
        else if l3instr.contains(touchLocation) {
            // if instruction button clicked
            l3_howto.zPosition = 3
            
            instr3_up = true
        }
        
        
    }
    
    
}
