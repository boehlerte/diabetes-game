//
//  Level3.swift
//  SpriteKitGame
//
//  Created by Marina Kashgarian on 4/18/17.
//  Copyright © 2017 Marina Kashgarian. All rights reserved.
//

import Foundation
import SpriteKit

enum object3:UInt32{
    case food = 1
    case player = 2
}

class Level3: SKScene, SKPhysicsContactDelegate{
    var gameOver = false
    var collectedItems = [Foods]()
    var count = 0
    var interval = 1
    
    var hat = SKSpriteNode(imageNamed: "chef_hat")
    let feedback = UILabel()
    let background_breakfast = SKSpriteNode(imageNamed: "background_breakfast")
    let background_lunch = SKSpriteNode(imageNamed: "background_lunch")
    let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
    let back = SKSpriteNode(imageNamed: "back_button")

    
    var b_empty_plate = SKSpriteNode(imageNamed: "empty_plate")
    var b_full_plate = SKSpriteNode(imageNamed: "full_plate")
    
    var l_empty_plate = SKSpriteNode(imageNamed: "empty_plate")
    var l_full_plate = SKSpriteNode(imageNamed: "full_plate")
    
    var d_empty_plate = SKSpriteNode(imageNamed: "empty_plate")
    var d_full_plate = SKSpriteNode(imageNamed: "full_plate")
    
    var b_plate = true
    var l_plate = false
    var d_plate = false
    
    var done = false
    
    var b_goal1 = 30    //start of breakfast range
    var b_goal2 = 45    //start of 
    var ld_goal1 = 60
    var ld_goal2 = 75
    
    //initialize player avatar
    let player = SKSpriteNode(imageNamed: "ram")
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    let successScreen = SKSpriteNode(imageNamed: "success-icon")
    let levelThreeScreen = SKSpriteNode(imageNamed: "level3icon")
    
    //pause when touch contact ends
    let pauseScreen = SKSpriteNode(imageNamed: "paused_button")
    
    // static var backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
    
    
    // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
    
    

    
    override func didMove(to view: SKView) {
        
        feedback.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: Selector(("tapFunction:")))
        feedback.addGestureRecognizer(tap)
        
        
        background_breakfast.size = self.frame.size
        background_breakfast.position = CGPoint(x: size.width/2, y: size.height * 0.5)
        background_breakfast.zPosition = -1
        addChild(background_breakfast)
        
        
        //add background music
        let backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
        self.addChild(backgroundMusic)
        
        
        //add physics to allow for contact between food and player
        physicsWorld.contactDelegate = self
        player.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = object.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = object.food.rawValue
        player.name = "player"
        addChild(player)
        
        back.position = CGPoint(x: size.width * 0.05, y: size.height * 0.97)
        back.zPosition = 1.0
        back.setScale(0.25)
        addChild(back)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: 0.75) // was 1
                ])
        ))
        
        
        pauseScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseScreen.zPosition = 1.0
        
        
        //position success screen to center
        successScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        successScreen.zPosition = 1.0
        
        
        levelThreeScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        levelThreeScreen.zPosition = 1.0
        addChild(levelThreeScreen)
        levelThreeScreen.run(
            SKAction.fadeOut(withDuration: 0.5)
        )
        
        feedback.textColor = .black
//        feedback.fontSize = 40
//        feedback.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
//        feedback.zPosition = 1.0
    }
    
    // RECOGNIZING TOUCH GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if (!gameOver){
            playerTouched = true
            //play game when player puts down finger
            view?.scene?.isPaused = false
            pauseScreen.removeFromParent()
            
            for touch in touches {
                playerLocation = touch.location(in: self)
            }
            
        }else{
            let reveal = SKTransition.doorsCloseHorizontal(withDuration: 5)
            let scene = RoundSelect(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            playerLocation = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if(back.contains(touchLocation)) {
            let reveal = SKTransition.doorsCloseHorizontal(withDuration: 5)
            let scene = MenuScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }
//        if(feedback.contains(touchLocation)) {
//            feedback.isHidden = true
//        }
        else if (!gameOver){
            playerTouched = false
            //pause game when player lifts finger
            view?.scene?.isPaused = true
            addChild(pauseScreen)
            
        } else {
        
            if (successScreen).contains(touchLocation) {
                let reveal = SKTransition.doorsCloseHorizontal(withDuration: 5)
                let scene = RoundSelect(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
        

    }
    
    
    
    override func update(_ currentTime: CFTimeInterval) {
        if(playerTouched) {
            moveNodeToLocation()
        }
    }
    
    func moveNodeToLocation() {
        let speed: CGFloat = 0.25
        
        var dx = playerLocation.x - player.position.x
        var dy = playerLocation.y - player.position.y
        
        dx = dx * speed
        dy = dy * speed
        player.position = CGPoint(x: player.position.x+dx, y: player.position.y + dy)
        
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addFood() {
        var food = Foods.collection[0].node.copy() as! SKSpriteNode
        done = false
        while(!done) {
            if(interval == 6) {
                interval = 0
                hat = SKSpriteNode(imageNamed: "chef_hat")
                food = hat
                food.setScale(0.2)
                done = true
                print("\(interval)")
            } else {
                let randd = Int(arc4random_uniform(43))
                // pick food to show
                if((b_plate && Foods.collection[randd].b) || (l_plate && Foods.collection[randd].l) || (d_plate && Foods.collection[randd].d)) {
                    interval += 1
                    food = Foods.collection[randd].node.copy() as! SKSpriteNode
                    done = true
                    print("\(interval)")
                }
            }
        }
        
        // Determine where to spawn the food along the Y axis
        let actualY = random(min: food.size.height/2 + 230, max: size.height - food.size.height/2)
        
        food.position = CGPoint(x: size.width + food.size.width/2, y: actualY)
        food.physicsBody = SKPhysicsBody(circleOfRadius: food.size.width/2)
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.collisionBitMask = 0
        food.physicsBody?.categoryBitMask = object.food.rawValue
        food.name = "food"

        // Add the food to the game
        addChild(food)
        
        // Calculate the speed of the food
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -food.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        food.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    //COLLISION DETECTION
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.node?.name == "food") {
            if let node = contact.bodyA.node as? SKSpriteNode {
                contact.bodyA.node?.removeFromParent()
                testFoodNode(node: node)
            }
            
        }else if(contact.bodyB.node?.name == "food"){
            if let node = contact.bodyB.node as? SKSpriteNode {
                contact.bodyB.node?.removeFromParent()
                testFoodNode(node: node)
            }
        }
        
    }
    
    func testFoodNode(node: SKSpriteNode){
        if (node == hat) {
            
            let feedback = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            feedback.center = CGPoint(x: size.width * 0.5, y: size.height/2)
            feedback.backgroundColor = UIColor.red
            feedback.textAlignment = .center
            feedback.numberOfLines = 5
            
            if (b_plate) {
                view?.scene?.isPaused = true
                if(count < b_goal1) {
                    feedback.numberOfLines = 5; // for example

                    feedback.text = "You needed between 30 and 45 grams of carbs \n for breakfast. You only got \(count)!"
                } else if(count >= b_goal1 && count <= b_goal2) {
                    feedback.text = "You got \(count) grams of carbs! \n Very well done!"
                } else  {
                    feedback.text = "Aww, you needed between 30 and 45 grams \n of carbs for breakfast, but you picked up \(count)!"
                }
                //feedback.isHidden = false
                // self.view?.addSubview(feedback)
                

                //addChild(feedback)
                //SKAction.wait(forDuration: 5)
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//                    // Put your code which should be executed with a delay here
//                        //self.feedback.removeFromParent()
//                    self.view?.willRemoveSubview(feedback)
//                    self.view?.scene?.isPaused = false
//                })
                
                //set up lunch round
                b_plate = false
                l_plate = true
                background_lunch.size = self.frame.size
                background_lunch.position = CGPoint(x: size.width/2, y: size.height * 0.5)
                background_lunch.zPosition = -1
                addChild(background_lunch)
            } else if (l_plate) {
                
                //set up dinner round
                l_plate = false
                d_plate = true
                background_dinner.size = self.frame.size
                background_dinner.position = CGPoint(x: size.width/2, y: size.height * 0.5)
                background_dinner.zPosition = -1
                addChild(background_dinner)
            } else if (d_plate) {
                // finish round, give feedback?
            }
        }
        for food in Foods.collection {
            if food.node.texture == node.texture {
                //alert player with number of carbs of item they collected
                carbCountAlert(carbs: food.carb_count)
                
                //add food to collectedItems
                collectedItems.append(food)
                
                if(!food.carb){
                    playSound(sound: good_carb)
                    
                }else{
                    playSound(sound: bad_carb)
                    count += food.carb_count
    
                }
            }
        }
        
    }
    
    func playSound(sound : SKAction) {
        run(sound)
    }
    
    func carbCountAlert(carbs: Int){
        let food_number = SKLabelNode(fontNamed: "Marker Felt")
        
        //alert the player with the number of carbs of each item they collect
        food_number.text = "\(carbs)"
        food_number.fontSize = 100
        food_number.fontColor = SKColor.green
        food_number.position = CGPoint(x: frame.midX, y: frame.midY)
        food_number.zPosition = 1.0
        addChild(food_number)
        
        let scaleUp = SKAction.scale(to: 2.0, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let sequence = SKAction.sequence([scaleUp, fade])
        food_number.run(sequence)
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        feedback.isHidden = true
    }
    
    
    func endRound(){
        gameOver = true
        view?.scene?.isPaused = true
        player.removeFromParent()
        addChild(successScreen)
        playSound(sound: level_complete)
    }
    
    
}
