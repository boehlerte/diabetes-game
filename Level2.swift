
import Foundation
import SpriteKit

enum object2:UInt32{
    case food = 1
    case player = 2
    case gameBoundary = 3
}

class Level2: SKScene, SKPhysicsContactDelegate{
    var gameOver = false
    
    //hint bar open variable
    var isOpen = false
    
    
    
    //collection of food sprites
    var collectedItems = [Foods]()
    var carb_count = 0
    let background_breakfast = SKSpriteNode(imageNamed: "background_breakfast")
    let background_lunch = SKSpriteNode(imageNamed: "background_lunch")
    let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
    let back = SKSpriteNode(imageNamed: "back_button")
    let goal_label = SKLabelNode(fontNamed: "Marker Felt")
    
    //goal scene images - breakfast goal, lunch goal, dinner goal
    //show goals before player starts each plate
    let b_goal = SKSpriteNode(imageNamed: "breakfast_goal")
    let l_goal = SKSpriteNode(imageNamed: "lunch_goal")
    let d_goal = SKSpriteNode(imageNamed: "dinner_goal")
    
    
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
    
    var goal1 = 45
    var goal2 = 75
    var goal3 = 75
    var seconds = CGFloat(1.0)
    
    
    //initialize player avatar
    let player = SKSpriteNode(imageNamed: "ram")
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    let successScreen = SKSpriteNode(imageNamed: "success-icon")
    let levelTwoScreen = SKSpriteNode(imageNamed: "level2icon")
    
    //pause when touch contact ends
    let pauseScreen = SKSpriteNode(imageNamed: "paused_button")
    let scoreBar = SKLabelNode(fontNamed: "Marker Felt")
    
    // static var backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
    
    
    // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
    
    
    //meter to keep track of number of carbs per plate
    var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
    
    //scoring and completion variables
    var score = 0
    var bfastMinCarbs = 30
    var bfastMaxCarbs = 45
    var lunchMinCarbs = 60
    var lunchMaxCarbs = 75
    var dinnerMinCarbs = 60
    var dinnerMaxCarbs = 75
    
    //food plate hints labels and background
    let collectedItemsLabel = SKSpriteNode(imageNamed: "foods_on_your_plate")
    let tipLabel = SKSpriteNode(imageNamed: "try_this_one")
    let collectionBackground = SKSpriteNode(imageNamed: "blue_screen")
    
    //define safe zone
    let safeRange = SKRange(lowerLimit:309)
    
    override func didMove(to view: SKView) {
        
        background_breakfast.size = self.frame.size
        background_breakfast.position = CGPoint(x: size.width/2, y: size.height * 0.55)
        background_breakfast.zPosition = -1
        addChild(background_breakfast)
        
        goal_label.text = "You need 30-45g for breakfast. You have 0!"
        goal_label.fontSize = 40
        goal_label.fontColor = SKColor.black
        goal_label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        goal_label.zPosition = 2.0
        addChild(goal_label)
        
        
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
        
        //        //game border - keeps player sprite within boundaries
        //        let gameBoundary = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 100))
        //        gameBoundary.lineWidth = 10
        //        gameBoundary.strokeColor = SKColor.black
        //        gameBoundary.position = CGPoint(x: size.width / 2, y: 50)
        //        gameBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 100))
        //        gameBoundary.physicsBody?.categoryBitMask = object2.gameBoundary.rawValue
        //        gameBoundary.physicsBody?.collisionBitMask = object.player.rawValue
        //        addChild(gameBoundary)
        //
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
        
        //add food to scene
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: TimeInterval(seconds))
                ])
        ))
        
        //clear out section at bottom of screen for meter
        let meterFrame = SKSpriteNode(color: SKColor .white, size: CGSize(width: size.width * 2, height: 100))
        meterFrame.position = CGPoint(x: size.width, y: 50)
        addChild(meterFrame)
        
        //add score bar
        scoreBar.fontSize = 30
        scoreBar.fontColor = SKColor.blue
        scoreBar.position = CGPoint(x: size.width * 0.9, y: size.height * 0.95)
        scoreBar.zPosition = 2.5
        scoreBar.text = "SCORE: 0"
        addChild(scoreBar)
        
        //add meter
        foodMeter.name = "meter"
        meterFrame.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:0, y:100), to: CGPoint(x:size.width, y: 100))
        foodMeter.position = CGPoint(x: 0 , y: 50)
        foodMeter.zPosition = 1.5
        foodMeter.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(foodMeter)
        
        
        pauseScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseScreen.zPosition = 1.0
        
        //position success screen to center
        successScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        successScreen.zPosition = 1.0
        
        
        levelTwoScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        levelTwoScreen.zPosition = 1.0
        addChild(levelTwoScreen)
        levelTwoScreen.run(
            SKAction.fadeOut(withDuration: 0.5)
        )
        
        
        //goal icons
        b_goal.position = CGPoint(x: frame.midX, y: frame.midY)
        b_goal.zPosition = 3.0
        b_goal.setScale(0.5)
        l_goal.position = CGPoint(x: frame.midX, y: frame.midY)
        l_goal.zPosition = -5.0
        l_goal.setScale(0.5)
        d_goal.position = CGPoint(x: frame.midX, y: frame.midY)
        d_goal.zPosition = -5.0
        d_goal.setScale(0.5)
        
        //breakfast goal screen
        //addChild(b_goal)
        
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
        
        //adding food plate hint scene
        //make z position really small to hide it
        //bring to front only when plate is clicked
        collectedItemsLabel.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        collectedItemsLabel.zPosition = -2.0
        addChild(collectedItemsLabel)
        
        tipLabel.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        tipLabel.zPosition = -2.0
        addChild(tipLabel)
        
        
        collectionBackground.size = self.frame.size
        collectionBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        collectionBackground.zPosition = -2.0
        addChild(collectionBackground)
        
        //prevent Rameses from moving to the safe zone
        let keepOffBottom = SKConstraint.positionY(safeRange)
        player.constraints = [keepOffBottom]
        
        
        
        
    }
    
    // RECOGNIZING TOUCH GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        
        if (!gameOver){
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
                tipLabel.zPosition = -2.0
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
        } else if (!gameOver){
            playerTouched = false
            //pause game when player lifts finger
            view?.scene?.isPaused = true
            addChild(pauseScreen)
            
            
            if (!isOpen && (b_empty_plate.contains(touchLocation) || l_empty_plate.contains(touchLocation) || d_empty_plate.contains(touchLocation)) && collectedItems.count > 0){
                
                isOpen = true
                
                tipLabel.zPosition = 3.0
                
                //show already collected items
                showCollectedItems()
                
                //determine a food to collect next
                showHintItem()
                
                
                
            }
        }else{
            
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
            let randd = Int(arc4random_uniform(43))
            // random number casted as int to pick food to show
            if((b_plate && Foods.collection[randd].b) || (l_plate && Foods.collection[randd].l) || (d_plate && Foods.collection[randd].d)) {
                food = Foods.collection[randd].node.copy() as! SKSpriteNode
                done = true
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
        
        for food in Foods.collection {                                                  //look at every food
            if food.node.texture == node.texture {                                      //compare to current food
                var duplicate = false
                for item in collectedItems {                                            //look at all collected foods
                    if(food.node.texture == item.node.texture){                         //if food has been collected
                        duplicate = true
                        playSound(sound: bad_carb)
                        print("duplicate item")                                         //it is a duplicate!
                        let retryScreen = SKSpriteNode(imageNamed: "retry-icon")
                        retryScreen.position = CGPoint(x: player.position.x, y: player.position.y)
                        retryScreen.zPosition = 1.0
                        addChild(retryScreen)
                        retryScreen.run(
                            SKAction.fadeOut(withDuration: 0.5)
                        )
                    }
                }
                
                if(!duplicate){
                    //alert player with number of carbs of item they collected
                    carbCountAlert(carbs: food.carb_count)
                    
                    //add food to collectedItems
                    collectedItems.append(food)
                    playSound(sound: good_carb)
                    
                    if(food.carb){
                        playSound(sound: good_carb)
                        carb_count += food.carb_count
                        incrementMeter(carbs: food.carb_count)
                        
                        if(carb_count>bfastMinCarbs && carb_count<bfastMaxCarbs && b_plate) {
                            //breakfast complete
                            
                            view?.scene?.isPaused = true
                            score += 100
                            scoreBar.text = "SCORE: \(score)"
                            
                            //show collected items
                            showCollectedItems()
                            
                            
                            //reset all parameters to prepare for lunch round
                            carb_count = 0
                            resetMeter()
                            b_plate = false
                            b_empty_plate.removeFromParent()
                            b_full_plate.position = CGPoint(x: 100, y: 160)
                            b_full_plate.zPosition = 1.0
                            addChild(b_full_plate)
                            background_breakfast.removeFromParent()
                            collectedItems.removeAll()
                            
                            //set up lunch round
                            l_plate = true
                            
                            //                            //add l_goal to scene
                            //                            l_goal.zPosition = 3.0
                            //
                            background_lunch.size = self.frame.size
                            background_lunch.position = CGPoint(x: size.width/2, y: size.height * 0.55)
                            background_lunch.zPosition = -1
                            addChild(background_lunch)
                            
                            
                            
                        }else if(carb_count>bfastMaxCarbs && b_plate){
                            //breakfast overshot
                            score -= 30
                            scoreBar.text = "SCORE: \(score)"
                            //reset count
                            carb_count = 0
                            collectedItems.removeAll()
                            resetMeter()
                        }else if(carb_count>lunchMinCarbs && carb_count<lunchMaxCarbs && l_plate) {
                            view?.scene?.isPaused = true
                            //lunch complete
                            score += 100
                            scoreBar.text = "SCORE: \(score)"
                            
                            //show all collected items before moving on to next plate
                            showCollectedItems()
                            
                            //reset all parameters to prepare for dinner round
                            carb_count = 0
                            resetMeter()
                            l_plate = false
                            l_empty_plate.removeFromParent()
                            l_full_plate.position = CGPoint(x: 200, y: 160)
                            l_full_plate.zPosition = 1.0
                            addChild(l_full_plate)
                            background_lunch.removeFromParent()
                            collectedItems.removeAll()
                            
                            //set up dinner round
                            d_plate = true
                            
                            
                            //                            //add d_goal to scene
                            //                            d_goal.zPosition = 3.0
                            
                            
                            //let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
                            background_dinner.size = self.frame.size
                            background_dinner.position = CGPoint(x: size.width/2, y: size.height * 0.55)
                            background_dinner.zPosition = -1
                            addChild(background_dinner)
                        }else if(carb_count>lunchMaxCarbs && l_plate){
                            //lunch overshot
                            score -= 30
                            scoreBar.text = "SCORE: \(score)"
                            //reset count
                            carb_count = 0
                            collectedItems.removeAll()
                            resetMeter()
                        }else if(carb_count>=dinnerMinCarbs && carb_count<=dinnerMaxCarbs && d_plate) {
                            //dinner complete
                            score += 100
                            scoreBar.text = "SCORE: \(score)"
                            
                            //show all collected items
                            showCollectedItems()
                            
                            d_plate = false
                            d_empty_plate.removeFromParent()
                            d_full_plate.position = CGPoint(x: 300, y: 160)
                            d_full_plate.zPosition = 1.0
                            addChild(d_full_plate)
                            endRound()
                            
                        }else if(carb_count>=dinnerMaxCarbs && d_plate){
                            //dinner overshot
                            score -= 30
                            scoreBar.text = "SCORE: \(score)"
                            //reset count
                            carb_count = 0
                            collectedItems.removeAll()
                            resetMeter()
                        }
                        
                        //change goal label once plate has been established
                        if(b_plate) {
                            goal_label.text = "You need 30-45g for breakfast. You have \(carb_count)!"
                        } else if(l_plate) {
                            goal_label.text = "You need 60-75g for lunch. You have \(carb_count)!"
                        }else if(d_plate) {
                            goal_label.text = "You need 60-75g for dinner. You have \(carb_count)!"
                        }
                    }
                }
                
            }
        }
        if(b_plate) {
            goal_label.text = "You need 30-45g for breakfast. You have \(carb_count)!"
        } else if(l_plate) {
            goal_label.text = "You need 60-75g for lunch. You have \(carb_count)!"
        }else if(d_plate) {
            goal_label.text = "You need 60-75g for dinner. You have \(carb_count)!"
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
        food_number.position = CGPoint(x: player.position.x, y: player.position.y)
        food_number.zPosition = 1.0
        addChild(food_number)
        
        let scaleUp = SKAction.scale(to: 2.0, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let sequence = SKAction.sequence([scaleUp, fade])
        food_number.run(sequence)
    }
    
    //show collected items after each plate
    func showCollectedItems(){
        var spacing = 100
        collectionBackground.zPosition = 2.6
        collectedItemsLabel.zPosition = 3.0
        
        
        //show collected items before moving on to next plate
        
        for items in collectedItems{
            print(items.node)
            //show already collected items
            let itemCard = items.node
            let floatSpacing = (CGFloat)(spacing)
            itemCard.position = CGPoint(x: floatSpacing, y: frame.midY + 100)
            itemCard.zPosition = 4.0
            itemCard.name = "hint"
            addChild(itemCard)
            spacing += 200
        }
        
        
    }
    
    //determine a random item that keeps player in carb range - show hint
    func showHintItem(){
        var food_hint = Foods.collection[0].node.copy() as! SKSpriteNode
        if (b_plate){
            let carbs_allowed = goal1 - carb_count
            
            done = false
            while(!done) {
                let randd = Int(arc4random_uniform(43))
                // random number casted as int to pick food to show
                if(Foods.collection[randd].b && Foods.collection[randd].carb_count <= carbs_allowed) {
                    food_hint = Foods.collection[randd].node.copy() as! SKSpriteNode
                    for item in collectedItems {
                        if(food_hint.texture != item.node.texture){
                            done = true
                        }
                    }
                }
            }
        } else if (l_plate){
            let carbs_allowed = goal2 - carb_count
            
            done = false
            while(!done) {
                let randd = Int(arc4random_uniform(43))
                // random number casted as int to pick food to show
                if(Foods.collection[randd].l && Foods.collection[randd].carb_count <= carbs_allowed) {
                    food_hint = Foods.collection[randd].node.copy() as! SKSpriteNode
                    for item in collectedItems {
                        if(food_hint.texture != item.node.texture){
                            done = true
                        }
                    }
                }
            }
        } else if (d_plate){
            let carbs_allowed = goal3 - carb_count
            
            done = false
            while(!done) {
                let randd = Int(arc4random_uniform(43))
                // random number casted as int to pick food to show
                if(Foods.collection[randd].d && Foods.collection[randd].carb_count <= carbs_allowed) {
                    food_hint = Foods.collection[randd].node.copy() as! SKSpriteNode
                    for item in collectedItems {
                        if(food_hint.texture != item.node.texture){
                            done = true
                        }
                    }
                }
            }
        }
        
        let hintCard = food_hint
        print(hintCard)
        hintCard.position = CGPoint(x: frame.midX, y: frame.midY - 250)
        hintCard.zPosition = 4.0
        hintCard.name = "hint"
        addChild(hintCard)
    }
    
    
    //increment meter by number of carbs
    func incrementMeter(carbs: Int){
        if(b_plate){
            let carbs = (Float)(carbs)
            let goal1 = (Float) (self.goal1)
            let meter_count = CGFloat(carbs/goal1)
            foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width * meter_count), height: foodMeter.size.height)
        }else if(l_plate){
            let carbs = (Float)(carbs)
            let goal2 = (Float) (self.goal2)
            let meter_count = CGFloat(carbs/goal2)
            foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width * meter_count), height: foodMeter.size.height)
        }else if(d_plate){
            let carbs = (Float)(carbs)
            let goal3 = (Float) (self.goal3)
            let meter_count = CGFloat(carbs/goal3)
            foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width * meter_count), height: foodMeter.size.height)
        }
        
    }
    
    func resetMeter(){
        foodMeter.size = CGSize(width: 0, height: foodMeter.size.height)
    }
    
    func endRound(){
        gameOver = true
        view?.scene?.isPaused = true
        player.removeFromParent()
        addChild(successScreen)
        playSound(sound: level_complete)
    }
    
    
}
