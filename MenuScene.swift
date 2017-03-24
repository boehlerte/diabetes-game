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
    
    let title = SKLabelNode(fontNamed: "Chalkduster")
    
    let playButton = SKLabelNode(fontNamed: "Chalkduster")
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.blue
        
        playButton.fontColor = SKColor.white
        playButton.text = "PLAY!"
        playButton.fontSize = 100
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(playButton)
        
        title.text = "*WORKING TITLE: DIABETES*"
        title.fontColor = SKColor.white
        title.fontSize = 50
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        addChild(title)

        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if playButton.contains(touchLocation) {
            
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
            
            let scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
    }
    
    
}
