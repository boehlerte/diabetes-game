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
    
    

    static var round = 0
    
    let r1 = SKSpriteNode(imageNamed: "1_button")
    let r2 = SKSpriteNode(imageNamed: "2_button")
    let r3 = SKSpriteNode(imageNamed: "3_button")
    let r4 = SKSpriteNode(imageNamed: "4_button")
    let r5 = SKSpriteNode(imageNamed: "5_button")
    let round_sel = SKSpriteNode(imageNamed: "pick_a_round_button")
    let bg = SKSpriteNode(imageNamed: "blue_screen")
    let back = SKSpriteNode(imageNamed: "back_button")

    
    override func didMove(to view: SKView) {
        bg.size = self.frame.size
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -1
        addChild(bg)
        
        back.position = CGPoint(x: size.width * 0.05, y: size.height * 0.97)
        back.zPosition = 1.0
        back.setScale(0.25)
        addChild(back)
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        round_sel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        addChild(round_sel)
        
        r1.position = CGPoint(x: size.width * 1/6, y: size.height * 0.5)
        addChild(r1)
        
        r2.position = CGPoint(x: size.width * 2/6, y: size.height * 0.5)
        addChild(r2)
        
        r3.position = CGPoint(x: size.width * 3/6, y: size.height * 0.5)
        addChild(r3)

        r4.position = CGPoint(x: size.width * 4/6, y: size.height * 0.5)
        addChild(r4)
        
        r5.position = CGPoint(x: size.width * 5/6, y: size.height * 0.5)
        addChild(r5)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let reveals = SKTransition.flipVertical(withDuration: 3)

        if(back.contains(touchLocation)) {
            //let reveal = SKTransition.flipVertical(withDuration: 3)
            let scenes = MenuScene(size: self.size)
            self.view?.presentScene(scenes, transition: reveals)
        }
        
        // change round variable depending on which was chosen
        else if r1.contains(touchLocation) {
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
                let scene = Level3(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            }
            RoundSelect.round = 0
        }
    }
    
    
}
