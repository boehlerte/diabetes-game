//
//  RoundSelect.swift
//  SpriteKitGame
//
//  Created by Marina Kashgarian on 4/17/17.
//  Copyright © 2017 Marina Kashgarian. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class RoundSelect: SKScene {
    
    
    let r1 = SKLabelNode(fontNamed: "Chalkduster")
    let r2 = SKLabelNode(fontNamed: "Chalkduster")
    let r3 = SKLabelNode(fontNamed: "Chalkduster")
    let r4 = SKLabelNode(fontNamed: "Chalkduster")
    let r5 = SKLabelNode(fontNamed: "Chalkduster")
    static var round = 0
    
//    let r1 = SKSpriteNode(imageNamed: "")
//    let r2 = SKSpriteNode(imageNamed: "")
//    let r3 = SKSpriteNode(imageNamed: "")
//    let r4 = SKSpriteNode(imageNamed: "")
//    let r5 = SKSpriteNode(imageNamed: "")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.cyan
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //r1.setScale(2)
        r1.fontColor = SKColor.white
        r1.text = "1"
        r1.fontSize = 50
        r1.position = CGPoint(x: size.width * 1/6, y: size.height * 0.5)
        addChild(r1)
        
        //r2.setScale(2)
        r2.fontColor = SKColor.white
        r2.text = "2"
        r2.fontSize = 50
        r2.position = CGPoint(x: size.width * 2/6, y: size.height * 0.5)
        addChild(r2)
        
        //r3.setScale(2)
        r3.fontColor = SKColor.white
        r3.text = "3"
        r3.fontSize = 50
        r3.position = CGPoint(x: size.width * 3/6, y: size.height * 0.5)
        addChild(r3)

        //r4.setScale(2)
        r4.fontColor = SKColor.white
        r4.text = "4"
        r4.fontSize = 50
        r4.position = CGPoint(x: size.width * 4/6, y: size.height * 0.5)
        addChild(r4)
        
      //  r5.setScale(2)
        r5.fontColor = SKColor.white
        r5.text = "5"
        r5.fontSize = 50
        r5.position = CGPoint(x: size.width * 5/6, y: size.height * 0.5)
        addChild(r5)
        
    
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        // change round variable depending on which was chosen
        if r1.contains(touchLocation) {
            RoundSelect.round = 1
        } else if r2.contains(touchLocation) {
            RoundSelect.round = 2
        } else if r3.contains(touchLocation) {
            RoundSelect.round = 3
        } else if r4.contains(touchLocation) {
            RoundSelect.round = 4
        } else if r5.contains(touchLocation) {
            RoundSelect.round = 5
        }
        
        // open to the level that was selected earlier
        if(RoundSelect.round != 0) {
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
            if(MenuScene.level == 1) {
                let scene = Level1(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            } else if(MenuScene.level == 2) {
                let scene = Level2(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            } else if(MenuScene.level == 3){
                let scene = Level2(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    
}
