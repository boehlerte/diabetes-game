import Foundation
import SpriteKit

enum object2:UInt32{
    case food = 1
    case player = 2
}

class Level2: SKScene, SKPhysicsContactDelegate{
    var gameOver = false
    //hint bar open variable
    var isOpen = false
    //collection of food sprites
    var collection = [Foods]()
    var collectedItems = [Foods]()
    var count = 0
    let count_label = SKLabelNode(fontNamed: "Marker Felt")
    let background_breakfast = SKSpriteNode(imageNamed: "background_breakfast")
    let background_lunch = SKSpriteNode(imageNamed: "background_lunch")
    let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
    
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
    
    var goal1 = 100
    var goal2 = 100
    var goal3 = 100
    
    //initialize player avatar
    let player = SKSpriteNode(imageNamed: "ram")
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    let successScreen = SKSpriteNode(imageNamed: "success-icon")
    let levelTwoScreen = SKSpriteNode(imageNamed: "level2icon")
    
    //pause when touch contact ends
    let pauseScreen = SKSpriteNode(imageNamed: "paused_button")
    
    // static var backgroundMusic = SKAudioNode(fileNamed: "GameSounds/BackgroundMusic.wav")
    
    
    // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
    
    
    //meter to keep track of number of carbs per plate
    var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
    
    
    
    override func didMove(to view: SKView) {
        
        //set background color
        // backgroundColor = SKColor.cyan
        
        //   let background = SKSpriteNode(imageNamed: "background_breakfast.png")
        background_breakfast.size = self.frame.size
        background_breakfast.position = CGPoint(x: size.width/2, y: size.height * 0.55)
        // background_breakfast.setScale(1.22)
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
        
        
        //create all foods and put them in an array
        NewFood()
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        //clear out section at bottom of screen for meter
        let meterFrame = SKSpriteNode(color: SKColor .white, size: CGSize(width: size.width * 2, height: 100))
        meterFrame.position = CGPoint(x: size.width, y: 50)
        addChild(meterFrame)
        
        //add meter
        foodMeter.name = "meter"
        meterFrame.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:0, y:100), to: CGPoint(x:
            size.width, y: 100))
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
        
        
        count_label.text = "CARBS: \(count) g"
        count_label.fontSize = 30
        count_label.fontColor = SKColor.blue
        count_label.position = CGPoint(x: size.width * 0.9, y: size.height * 0.95)
        count_label.zPosition = 1.5
        addChild(count_label)
        
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
            
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
            
            let scene = MenuScene(size: self.size)
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
        
        if (!gameOver){
            playerTouched = false
            //pause game when player lifts finger
            view?.scene?.isPaused = true
            addChild(pauseScreen)
            
            let collectedItemsLabel = SKLabelNode(fontNamed: "Marker Felt")
            let tipLabel = SKLabelNode(fontNamed: "Marker Felt")
            let collectionBackground = SKSpriteNode(imageNamed: "blue_screen")
            
            if (!isOpen && (b_empty_plate.contains(touchLocation) || l_empty_plate.contains(touchLocation) || d_empty_plate.contains(touchLocation))){
                var count = 100
                isOpen = true
                
                collectedItemsLabel.fontSize = 100
                collectedItemsLabel.text = "Collected Items:"
                collectedItemsLabel.position = CGPoint(x: frame.midX, y: frame.midY + 200)
                collectedItemsLabel.zPosition = 3.5
                collectedItemsLabel.fontColor = SKColor.blue
                addChild(collectedItemsLabel)
                
                tipLabel.fontSize = 100
                tipLabel.text = "Try this food next:"
                tipLabel.position = CGPoint(x: frame.midX, y: frame.midY - 100)
                tipLabel.zPosition = 3.5
                tipLabel.fontColor = SKColor.blue
                addChild(tipLabel)
                
                
                collectionBackground.size = self.frame.size
                collectionBackground.position = CGPoint(x: frame.midX, y: frame.midY)
                collectionBackground.zPosition = 1.5
                addChild(collectionBackground)
                
                for items in collectedItems{
                    print(items.node)
                    
                    let itemCard = items.node
                    let floatCount = (CGFloat)(count)
                    itemCard.position = CGPoint(x: floatCount, y: frame.midY + 100)
                    itemCard.zPosition = 2.0
                    itemCard.name = "hint"
                    addChild(itemCard)
                    count += 100
                }
            }else if(isOpen &&  collectionBackground.contains(touchLocation)){
                isOpen = false
                for child in self.children {
                    if child.name == "hint" {
                        child.removeFromParent()
                    }
                }
                
            }
            
        }else{
            
            
            if (successScreen).contains(touchLocation) {
                
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 5)
                
                let scene = MenuScene(size: self.size)
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
        var food = collection[0].node.copy() as! SKSpriteNode
        done = false
        while(!done) {
            let randd = Int(arc4random_uniform(20))
            // random number casted as int to pick food to show
            if((b_plate && collection[randd].b) || (l_plate && collection[randd].l) || (d_plate && collection[randd].d)) {
                food = collection[randd].node.copy() as! SKSpriteNode
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
    
    //
    //    struct Sound {
    //        static var isVolumeOn = true
    //
    //        static func playSound() {
    //            backgroundMusic.run(SKAction.play())
    //        }
    //        static func stopSound() {
    //            backgroundMusic.run(SKAction.stop())
    //        }
    //    }
    
    //CREATE NEW FOODS FOR GAME
    
    func NewFood() {
        
        
        let pizzaNode = SKSpriteNode(imageNamed: "Foods.sprite/pizza.png")
        let f1 = Foods(node: pizzaNode, carb_count: 30, carb: true, b: false, l:true, d:true)
        f1.node.name = "pizza"
        collection.append(f1)
        
        let appleNode = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
        let f2 = Foods(node: appleNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        f2.node.name = "apple"
        collection.append(f2)
        
        let burgerNode = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
        let f3 = Foods(node: burgerNode, carb_count: 30, carb: true, b: false, l:true, d:true)
        f3.node.name = "burger"
        collection.append(f3)
        
        let broccoliNode = SKSpriteNode(imageNamed: "Foods.sprite/broccoli.png")
        let f4 = Foods(node: broccoliNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f4.node.name = "broccoli"
        collection.append(f4)
        
        let bananaNode = SKSpriteNode(imageNamed: "Foods.sprite/banana.png")
        let f5 = Foods(node: bananaNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        f5.node.name = "banana"
        collection.append(f5)
        
        let cookieNode = SKSpriteNode(imageNamed: "Foods.sprite/cookie.png")
        let f6 = Foods(node: cookieNode, carb_count: 9, carb: true, b: true, l:true, d:true)
        f6.node.name = "cookie"
        collection.append(f6)
        
        let donutNode = SKSpriteNode(imageNamed: "Foods.sprite/donut.png")
        let f7 = Foods(node: donutNode, carb_count: 22, carb: true, b: true, l:true, d:true)
        f7.node.name = "donut"
        collection.append(f7)
        
        let friesNode = SKSpriteNode(imageNamed: "Foods.sprite/fries.png")
        let f8 = Foods(node: friesNode, carb_count: 45, carb: true, b: false, l:true, d:true)
        f8.node.name = "fries"
        collection.append(f8)
        
        let grapesNode = SKSpriteNode(imageNamed: "Foods.sprite/grapes.png")
        let f9 = Foods(node: grapesNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        f9.node.name = "grapes"
        collection.append(f9)
        
        let hotdogNode = SKSpriteNode(imageNamed: "Foods.sprite/hotdog.png")
        let f10 = Foods(node: hotdogNode, carb_count: 21, carb: true, b: false, l:true, d:true)
        f10.node.name = "hotdog"
        collection.append(f10)
        
        let ice_creamNode = SKSpriteNode(imageNamed: "Foods.sprite/ice_cream.png")
        let f11 = Foods(node: ice_creamNode, carb_count: 23, carb: true, b: false, l:true, d:true)
        f11.node.name = "ice_cream"
        collection.append(f11)
        
//        let mangoNode = SKSpriteNode(imageNamed: "Foods.sprite/mango.png")
//        let f12 = Foods(node: mangoNode, carb_count: 50, carb: true, b: true, l:true, d:false)
//        collection.append(f12)
        
        let peachNode = SKSpriteNode(imageNamed: "Foods.sprite/peach.png")
        let f12 = Foods(node: peachNode, carb_count: 14, carb: true, b: true, l:true, d:false)
        f12.node.name = "peach"
        collection.append(f12)
        
        let baconNode = SKSpriteNode(imageNamed: "Foods.sprite/bacon.png")
        let f13 = Foods(node: baconNode, carb_count: 0, carb: false, b: true, l:true, d:false)
        f13.node.name = "bacon"
        collection.append(f13)
        
        let carrotNode = SKSpriteNode(imageNamed: "Foods.sprite/carrot.png")
        let f14 = Foods(node: carrotNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f14.node.name = "carrot"
        collection.append(f14)
        
        let celeryNode = SKSpriteNode(imageNamed: "Foods.sprite/celery.png")
        let f15 = Foods(node: celeryNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f15.node.name = "celery"
        collection.append(f15)
        
        let chickenNode = SKSpriteNode(imageNamed: "Foods.sprite/chicken.png")
        let f16 = Foods(node: chickenNode, carb_count: 0, carb: false, b: true, l:true, d:true)
        f16.node.name = "chicken"
        collection.append(f16)
        
        let fishNode = SKSpriteNode(imageNamed: "Foods.sprite/fish.png")
        let f17 = Foods(node: fishNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f17.node.name = "fish"
        collection.append(f17)
        
        let mushroomNode = SKSpriteNode(imageNamed: "Foods.sprite/mushroom.png")
        let f18 = Foods(node: mushroomNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f18.node.name = "mushroom"
        collection.append(f18)
        
//        let porkNode = SKSpriteNode(imageNamed: "Foods.sprite/pork.png")
//        let f20 = Foods(node: porkNode, carb_count: 0, carb: false, b: true, l:true, d:true)
//        collection.append(f20)
        
        let spinachNode = SKSpriteNode(imageNamed: "Foods.sprite/spinach.png")
        let f19 = Foods(node: spinachNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f19.node.name = "spinach"
        collection.append(f19)
        
        let steakNode = SKSpriteNode(imageNamed: "Foods.sprite/steak.png")
        let f20 = Foods(node: steakNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        f20.node.name = "steak"
        collection.append(f20)
        
        
        
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
        for food in collection {
            
                if food.node.texture == node.texture {
                    for item in collectedItems {
                        if(food.node.texture == item.node.texture){
                            print("duplicate item")
                            let retryScreen = SKSpriteNode(imageNamed: "retry-icon")
                            retryScreen.position = CGPoint(x: frame.midX, y: frame.midY)
                            retryScreen.zPosition = 1.0
                            addChild(retryScreen)
                            retryScreen.run(
                                SKAction.fadeOut(withDuration: 0.5)
                            )
                        }
                    }
                        //alert player with number of carbs of item they collected
                        carbCountAlert(carbs: food.carb_count)
                        
                        //add food to collectedItems
                        collectedItems.append(food)
                        
                        if(!food.carb){
                            playSound(sound: good_carb)
                            
                        }else{
                            playSound(sound: bad_carb)
                            count += food.carb_count
                            count_label.text = "CARBS: \(count) g"
                            incrementMeter(carbs: food.carb_count)
                            
                            
                            
                            if(count>100 && b_plate) {
                                //reset all parameters to prepare for lunch round
                                count = 0
                                count_label.text = "CARBS: \(count) g"
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
                                
                                //let background_lunch = SKSpriteNode(imageNamed: "background_lunch")
                                background_lunch.size = self.frame.size
                                background_lunch.position = CGPoint(x: size.width/2, y: size.height * 0.55)
                                //   background_lunch.setScale(1.22)
                                background_lunch.zPosition = -1
                                addChild(background_lunch)
                            }else if(count>100 && l_plate) {
                                //reset all parameters to prepare for dinner round
                                count = 0
                                count_label.text = "CARBS: \(count) g"
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
                                //let background_dinner = SKSpriteNode(imageNamed: "background_dinner")
                                background_dinner.size = self.frame.size
                                background_dinner.position = CGPoint(x: size.width/2, y: size.height * 0.55)
                                //background_dinner.setScale(1.22)
                                background_dinner.zPosition = -1
                                addChild(background_dinner)
                            }else if(count>100 && d_plate) {
                                d_plate = false
                                d_empty_plate.removeFromParent()
                                d_full_plate.position = CGPoint(x: 300, y: 160)
                                d_full_plate.zPosition = 1.0
                                addChild(d_full_plate)
                                endRound()
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
        food_number.fontColor = SKColor.green
        food_number.position = CGPoint(x: frame.midX, y: frame.midY)
        food_number.zPosition = 1.0
        addChild(food_number)
        
        let scaleUp = SKAction.scale(to: 2.0, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let sequence = SKAction.sequence([scaleUp, fade])
        food_number.run(sequence)
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
