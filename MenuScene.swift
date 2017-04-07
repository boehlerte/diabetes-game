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
    let l2 = SKLabelNode(fontNamed: "Chalkduster")
    let l3 = SKLabelNode(fontNamed: "Chalkduster")
    let info = SKLabelNode(fontNamed: "Chalkduster")
    let music = SKLabelNode(fontNamed: "Chalkduster")

//    override func didMove(to view: SKView) {
//
//        let background = SKSpriteNode(imageNamed: "sky.png")
//        background.position = CGPoint(x: size.width/2, y: size.height * 0.55)
//        background.setScale(1.22)
//        background.zPosition = -1
//        addChild(background)
//    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        playButton.fontColor = SKColor.white
        playButton.text = "Level 1"
        playButton.fontSize = 50
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(playButton)
        
        l2.fontColor = SKColor.white
        l2.text = "Level 2"
        l2.fontSize = 50
        l2.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        addChild(l2)
        
        l3.fontColor = SKColor.white
        l3.text = "Level 3"
        l3.fontSize = 50
        l3.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(l3)
        
        info.fontColor = SKColor.white
        info.text = "Info Tab"
        info.fontSize = 50
        info.position = CGPoint(x: size.width / 2, y: size.height * 0.05)
        addChild(info)
        
        music.fontColor = SKColor.white
        music.text = "Music On/Off"
        music.fontSize = 20
        music.position = CGPoint(x: size.width * 0.13, y: size.height * 0.98)
        addChild(music)
        
        
        title.text = "CHEF RAMESES"
        title.fontColor = SKColor.white
        title.fontSize = 70
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
            
            let scene = Level1(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            
        }
        else if l2.contains(touchLocation) {
            
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
            
            let scene = Level2(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
    }
    
    
}
