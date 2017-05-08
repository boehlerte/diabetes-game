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
    var isOpen = false
    var gameOver = false
    
    //variable used to alternate between colors for carbCountAlert
    var alternateNum = 0
    
    var collectedItems = [Foods]()
    var count = 0
    var interval = 1
    var complete = false
    var feedbackshown = false
    
    var hat = SKSpriteNode(imageNamed: "chef_hat")
    let feedback = UILabel()
    let background_breakfast = SKSpriteNode(imageNamed: "background_breakfast")
    let background_lunch = SKSpriteNode(imageNamed: "background_lunch")
    let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
    let back = SKSpriteNode(imageNamed: "back_button")
    var seconds = CGFloat(1.0)
    let scoreBar = SKLabelNode(fontNamed: "Marker Felt")
    
    
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
    
    var score = 0
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
    
    
    //food plate screen labels and background
    let collectedItemsLabel = SKSpriteNode(imageNamed: "foods_on_your_plate")
    let collectionBackground = SKSpriteNode(imageNamed: "blue_screen")
    
    //define safe zone
    let safeRange = SKRange(lowerLimit:309)
    
    
    
    override func didMove(to view: SKView) {
        
        //        feedback.isUserInteractionEnabled = true
        //        let tap = UITapGestureRecognizer(target: self, action: Selector(("tapFunction:")))
        //        feedback.addGestureRecognizer(tap)
        
        
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
        
        //add plates to keep track of players progress
        b_empty_plate.position = CGPoint(x: 100, y: 160)
        b_empty_plate.zPosition = 1.5
        b_empty_plate.name = "b_plate"
        addChild(b_empty_plate)
        
        l_empty_plate.position = CGPoint(x: 200, y: 160)
        l_empty_plate.zPosition = 1.5
        l_empty_plate.name = "l_plate"
        addChild(l_empty_plate)
        
        d_empty_plate.position = CGPoint(x: 300, y: 160)
        d_empty_plate.zPosition = 1.5
        d_empty_plate.name = "d_plate"
        addChild(d_empty_plate)
        
        //add food plate scene
        //bring to front only when plate is clicked
        collectedItemsLabel.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        collectedItemsLabel.zPosition = -2.0
        addChild(collectedItemsLabel)
        
        collectionBackground.size = self.frame.size
        collectionBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        collectionBackground.zPosition = -2.0
        addChild(collectionBackground)
        
        
        //back button to return to main menu
        back.position = CGPoint(x: size.width * 0.05, y: size.height * 0.97)
        back.zPosition = 1.0
        back.setScale(0.25)
        addChild(back)
        
        
        if(RoundSelect.round==1) {
            seconds = CGFloat(1.0)
        } else if(RoundSelect.round==2) {
            seconds = CGFloat(0.9)
        } else if(RoundSelect.round==3) {
            seconds = CGFloat(0.8)
        } else if(RoundSelect.round==4) {
            seconds = CGFloat(0.7)
        } else if(RoundSelect.round==5) {
            seconds = CGFloat(0.6)
        }
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: TimeInterval(seconds)) // was 1
                ])
        ))
        
        //add score bar
        scoreBar.fontSize = 30
        scoreBar.fontColor = SKColor.blue
        scoreBar.position = CGPoint(x: size.width * 0.9, y: size.height * 0.95)
        scoreBar.zPosition = 2.5
        scoreBar.text = "SCORE: 0"
        addChild(scoreBar)
        
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
        
        
        //prevent Rameses from moving to the safe zone
        let keepOffBottom = SKConstraint.positionY(safeRange)
        player.constraints = [keepOffBottom]
        
    }
    
    // RECOGNIZING TOUCH GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        
        if (!gameOver && !feedbackshown){
            playerTouched = true
            //play game when player puts down finger
            view?.scene?.isPaused = false
            pauseScreen.removeFromParent()
            
            for touch in touches {
                playerLocation = touch.location(in: self)
            }
            
            if(collectionBackground.contains(touchLocation)){
                isOpen = false
                for child in self.children {
                    if child.name == "hint" {
                        child.removeFromParent()
                    }
                }
                collectionBackground.zPosition = -2.0
                collectedItemsLabel.zPosition = -2.0
            }
            
        }else if (gameOver){
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
            
        else if (!gameOver && !feedbackshown){
            playerTouched = false
            //pause game when player lifts finger
            view?.scene?.isPaused = true
            addChild(pauseScreen)
            
            //if plate clicked, open screen to show food on plate
            if (!isOpen && (b_empty_plate.contains(touchLocation) || l_empty_plate.contains(touchLocation) || d_empty_plate.contains(touchLocation)) && collectedItems.count > 0){
                
                isOpen = true
                
                //show already collected items
                showCollectedItems()
                
            }
            
        } else {
            
            if ((successScreen).contains(touchLocation) && !feedbackshown) {
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
                let randd = Int(arc4random_uniform(42))
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
        food.zPosition = 0.5
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
            collectedItems.removeAll()
            
            let feedback = UILabel(frame: CGRect(x: 0, y: 0, width: 700, height: 500))
            feedback.center = CGPoint(x: size.width * 0.5, y: size.height/2)
            feedback.backgroundColor = UIColor.init(red: 0.09, green: 0.09, blue: 0.44, alpha: 1.0)
            feedback.textAlignment = .center
            feedback.numberOfLines = 5
            feedback.textColor = .lightText
            feedback.numberOfLines = 5 // for example
            feedback.font = feedback.font.withSize(50)
            feedback.layer.masksToBounds = true
            feedback.layer.cornerRadius = 50
            
            if (b_plate) {
                view?.scene?.isPaused = true
                if(count < b_goal1) {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You needed between 30 and 45 grams of carbs \n for breakfast. You only got \(count)!"
                    count = 0
                    
                    //clear scene
                    removeAssets()
                } else if(count >= b_goal1 && count <= b_goal2) {
                    score += 100
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You got \(count) grams of carbs! \n Very well done!"
                    //set up lunch round
                    
                    //clear scene
                    removeAssets()
                    
                    b_plate = false
                    l_plate = true
                    background_lunch.size = self.frame.size
                    background_lunch.position = CGPoint(x: size.width/2, y: size.height * 0.5)
                    background_breakfast.zPosition = -2
                    background_lunch.zPosition = -1
                    addChild(background_lunch)
                    count = 0
                    b_empty_plate.removeFromParent()
                    b_full_plate.position = CGPoint(x: 100, y: 160)
                    b_full_plate.zPosition = 1.0
                    addChild(b_full_plate)
                    
                } else  {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "Aww, you needed between 30 and 45 grams \n of carbs for breakfast, but you picked up \(count)!"
                    count = 0
                    //clear scene
                    removeAssets()
                }
                self.view?.addSubview(feedback)
                self.feedbackshown = true
                self.view?.bringSubview(toFront: feedback)
                let when = DispatchTime.now() + 5 // delay
                DispatchQueue.main.asyncAfter(deadline: when) {
                    feedback.removeFromSuperview()
                    self.feedbackshown = false
                    
                }
            } else if (l_plate) {
                view?.scene?.isPaused = true
                if(count < ld_goal1) {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You needed between 60 and 75 grams of carbs \n for lunch. You only got \(count)!"
                    count = 0
                    //clear scene
                    removeAssets()
                } else if(count >= ld_goal1 && count <= ld_goal2) {
                    score += 100
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You got \(count) grams of carbs! \n Very well done!"
                    //set up dinner round
                    //clear scene
                    removeAssets()
                    
                    l_plate = false
                    d_plate = true
                    background_dinner.size = self.frame.size
                    background_dinner.position = CGPoint(x: size.width/2, y: size.height * 0.5)
                    background_lunch.zPosition = -2
                    background_dinner.zPosition = -1
                    addChild(background_dinner)
                    count = 0
                    l_empty_plate.removeFromParent()
                    l_full_plate.position = CGPoint(x: 200, y: 160)
                    l_full_plate.zPosition = 1.0
                    addChild(l_full_plate)
                } else  {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "Aww, you needed between 60 and 75 grams \n of carbs for lunch, but you picked up \(count)!"
                    count = 0
                    //clear scene
                    removeAssets()
                }
                self.view?.addSubview(feedback)
                self.feedbackshown = true
                self.view?.bringSubview(toFront: feedback)
                let when = DispatchTime.now() + 5 // delay
                DispatchQueue.main.asyncAfter(deadline: when) {
                    feedback.removeFromSuperview()
                    self.feedbackshown = false
                    
                }
                
            } else if (d_plate) {
                view?.scene?.isPaused = true
                if(count < ld_goal1) {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You needed between 60 and 75 grams of carbs \n for dinner. You only got \(count)!"
                    count = 0
                    //clear scene
                    removeAssets()
                } else if(count >= ld_goal1 && count <= ld_goal2) {
                    score += 100
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "You got \(count) grams of carbs! \n Very well done! You finished with a score of \(score)!"
                    count = 0
                    d_empty_plate.removeFromParent()
                    d_full_plate.position = CGPoint(x: 300, y: 160)
                    d_full_plate.zPosition = 1.0
                    addChild(d_full_plate)
                    complete = true
                } else  {
                    score -= 30
                    scoreBar.text = "SCORE: \(score)"
                    feedback.text = "Aww, you needed between 60 and 75 grams \n of carbs for dinner, but you picked up \(count)!"
                    count = 0
                    removeAssets()
                }
                self.view?.addSubview(feedback)
                self.feedbackshown = true
                self.view?.bringSubview(toFront: feedback)
                let when = DispatchTime.now() + 5 // delay
                DispatchQueue.main.asyncAfter(deadline: when) {
                    feedback.removeFromSuperview()
                    self.feedbackshown = false
                }
                if(complete) {
                    endRound()
                }
                
            }
        }
        for food in Foods.collection {
            if food.node.texture == node.texture {
                var duplicate = false
                for item in collectedItems {                                            //look at all collected foods
                    if(food.node.texture == item.node.texture){                         //if food has been collected
                        duplicate = true
                        playSound(sound: bad_carb)
                        print("duplicate item")                                         //it is a duplicate!
                        let retryScreen = SKSpriteNode(imageNamed: "duplicate_item")
                        retryScreen.position = CGPoint(x: player.position.x, y: player.position.y)
                        retryScreen.zPosition = 1.0
                        retryScreen.setScale(0.5)
                        addChild(retryScreen)
                        retryScreen.run(
                            SKAction.fadeOut(withDuration: 0.5)
                        )
                    }
                }
                if(!duplicate) {
                    //alert player with number of carbs of item they collected
                    carbCountAlert(carbs: food.carb_count)
                    
                    //add food to collectedItems
                    collectedItems.append(food)
                    playSound(sound: good_carb)
                    if(food.carb) {
                        count += food.carb_count
                    }
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
        
        //alternate between colors
        //0 for blue
        //1 for magenta
        let orangeFont = SKColor.orange
        let magentaFont = SKColor.magenta
        
        if(alternateNum == 0){
            food_number.fontColor = orangeFont
            alternateNum = 1
        }else if(alternateNum == 1){
            food_number.fontColor = magentaFont
            alternateNum = 0
        }
        
        
        food_number.position = CGPoint(x: player.position.x, y: player.position.y)
        food_number.zPosition = 1.0
        //        food_number.fontColor = .darkText
        //        if(d_plate) {
        //            food_number.fontColor = .lightText
        //        }
        addChild(food_number)
        
        let scaleUp = SKAction.scale(to: 2.0, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let sequence = SKAction.sequence([scaleUp, fade])
        food_number.run(sequence)
    }
    
    //show collected items on plate click and after each completed plate
    func showCollectedItems(){
        var xspacing = 100
        var yspacing = 0
        collectionBackground.zPosition = 3.0
        collectedItemsLabel.zPosition = 3.2
        
        
        //show collected items before moving on to next plate
        
        for items in collectedItems{
            print(items.node)
            //show already collected items
            let itemCard = items.node
            let xfloatSpacing = (CGFloat)(xspacing)
            let yfloatSpacing = (CGFloat)(yspacing)
            itemCard.position = CGPoint(x: xfloatSpacing, y: (frame.midY + 100) - yfloatSpacing)
            itemCard.zPosition = 4.0
            itemCard.name = "hint"
            addChild(itemCard)
            xspacing += 200
            if(xfloatSpacing >= (self.frame.width - 200)){
                xspacing = 100
                yspacing += 150
            }
        }
        
    }
    
    func removeAssets(){
        //remove retry/success screen
        //remove carbcount numbers
        //remove foods
        //clear scene for restarting a plate
        //or clear scene for starting a new plate
        for child in self.children {
            if child.name == "asset"{
                child.removeFromParent()
            }
        }
        for child in self.children {
            if child.name == "food"{
                child.removeFromParent()
            }
        }
    }
    
    func endRound(){
        removeAssets()
        gameOver = true
        view?.scene?.isPaused = true
        player.removeFromParent()
        addChild(successScreen)
        playSound(sound: level_complete)
    }
    
    
}
