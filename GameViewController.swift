//
//  GameViewController.swift
//  Swiftris
//
//  Created by Diane Pozefsky on 2/25/17.
//  Copyright (c) 2017 Erin Boehlert. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate {

    var scene: GameScene!
    
    var swiftris:Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        swiftris = Swiftris()
        swiftris.delegate = self
        
        swiftris.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
    
    }

    

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }


    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func didTick() {
        
        swiftris.letShapeFall()
    
    }
    
    func nextShape() {
        
        let newShapes = swiftris.newShape()
        
        guard let fallingShape = newShapes.fallingShape else {
            
            return
            
        }
        
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        
        self.scene.movePreviewShape(shape: fallingShape) {
            
            self.view.isUserInteractionEnabled = true
            
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                
                self.nextShape()
            }
        } else {
            
            nextShape()
            
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        
        view.isUserInteractionEnabled = false
        
        scene.stopTicking()
        
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        
        
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        
        
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        
        scene.stopTicking()
        
        nextShape()
        
    }
    
    func gameShapeDidMove(swiftris: Swiftris) {
        
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
}
