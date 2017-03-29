import SpriteKit

enum object:UInt32{
    case food = 1
    case player = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
   
    
    var collection = [Foods]()
    
    let player = SKSpriteNode(imageNamed: "ram")
    
    let welcomeScreen = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 500, height: 500))
    let welcomeText = SKLabelNode(fontNamed: "Chalkduster")
    
    let pauseScreen = SKLabelNode(fontNamed: "Chalkduster")
    
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
    
    
    var streak = 0
    var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
    
    
    override func didMove(to view: SKView) {
        
        
        let backgroundMusic = SKAudioNode(fileNamed: "BackgroundMusic.wav")
        self.addChild(backgroundMusic)
        
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.cyan
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = object.player.rawValue
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = object.food.rawValue
        
        player.name = "player"
        addChild(player)
        
        NewFood()
        // create all the foods and put them in an array
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        //clear out section at top of screen for meter
        let meterFrame = SKSpriteNode(color: SKColor .white, size: CGSize(width: size.width * 2, height: 100))
        meterFrame.position = CGPoint(x: size.width, y: 50)
        addChild(meterFrame)
        
        //add fill of meter as food is collected
        foodMeter.name = "meter"
        meterFrame.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:0, y:100), to: CGPoint(x:
            size.width, y: 100))
        foodMeter.position = CGPoint(x: 0 , y: 50)
        foodMeter.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        
        addChild(foodMeter)
        
        pauseScreen.text = "PAUSED"
        pauseScreen.fontSize = 150
        pauseScreen.fontColor = SKColor.black
        pauseScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseScreen.zPosition = 1.0
        
        
    }
    
    // RECOGNIZING TOUCH GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        playerTouched = true
        
        //play game when player puts down finger
        view?.scene?.isPaused = false
        welcomeScreen.removeFromParent()
        welcomeText.removeFromParent()
        pauseScreen.removeFromParent()
        
        for touch in touches {
            playerLocation = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            playerLocation = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        playerTouched = false
        
        //pause game when player lifts finger
        view?.scene?.isPaused = true
        addChild(pauseScreen)
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
        
        
        
        let randd = Int(arc4random_uniform(4))
        // random number casted as int to pick food to show
        let food = collection[randd].node.copy() as! SKSpriteNode
     
        
        // Determine where to spawn the food along the Y axis
        let actualY = random(min: food.size.height/2 + 100, max: size.height - food.size.height/2)
        
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

    //CREATE NEW FOODS FOR GAME
    
    func NewFood() {
        

        let pizzaNode = SKSpriteNode(imageNamed: "Foods.sprite/pizza.png")
        let f1 = Foods(node: pizzaNode, carb_count: 30, carb: true)
        collection.append(f1)
        
        let appleNode = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
        let f2 = Foods(node: appleNode, carb_count: 15, carb: true)
        collection.append(f2)
        
        let burgerNode = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
        let f3 = Foods(node: burgerNode, carb_count: 30, carb: true)
        collection.append(f3)
        
        let broccoliNode = SKSpriteNode(imageNamed: "Foods.sprite/broccoli.png")
        let f4 = Foods(node: broccoliNode, carb_count: 0, carb: false)
        collection.append(f4)
        
        let bananaNode = SKSpriteNode(imageNamed: "Foods.sprite/banana.png")
        let f5 = Foods(node: bananaNode, carb_count: 15, carb: true)
        collection.append(f5)
        
        let cookieNode = SKSpriteNode(imageNamed: "Foods.sprite/cookie.png")
        let f6 = Foods(node: cookieNode, carb_count: 9, carb: true)
        collection.append(f6)
        
        let donutNode = SKSpriteNode(imageNamed: "Foods.sprite/donut.png")
        let f7 = Foods(node: donutNode, carb_count: 22, carb: true)
        collection.append(f7)
        
        let friesNode = SKSpriteNode(imageNamed: "Foods.sprite/fries.png")
        let f8 = Foods(node: friesNode, carb_count: 45, carb: true)
        collection.append(f8)
        
        let grapesNode = SKSpriteNode(imageNamed: "Foods.sprite/grapes.png")
        let f9 = Foods(node: grapesNode, carb_count: 15, carb: true)
        collection.append(f9)
        
        let hotdogNode = SKSpriteNode(imageNamed: "Foods.sprite/hotdog.png")
        let f10 = Foods(node: hotdogNode, carb_count: 21, carb: true)
        collection.append(f10)
        
        let ice_creamNode = SKSpriteNode(imageNamed: "Foods.sprite/ice_cream.png")
        let f11 = Foods(node: ice_creamNode, carb_count: 23, carb: true)
        collection.append(f11)
        
        let mangoNode = SKSpriteNode(imageNamed: "Foods.sprite/mango.png")
        let f12 = Foods(node: mangoNode, carb_count: 50, carb: true)
        collection.append(f12)
        
        let peachNode = SKSpriteNode(imageNamed: "Foods.sprite/peach.png")
        let f13 = Foods(node: peachNode, carb_count: 14, carb: true)
        collection.append(f13)
        
        let baconNode = SKSpriteNode(imageNamed: "Foods.sprite/bacon.png")
        let f14 = Foods(node: baconNode, carb_count: 0, carb: false)
        collection.append(f14)
        
        let carrotNode = SKSpriteNode(imageNamed: "Foods.sprite/carrot.png")
        let f15 = Foods(node: carrotNode, carb_count: 0, carb: false)
        collection.append(f15)
        
        let celeryNode = SKSpriteNode(imageNamed: "Foods.sprite/celery.png")
        let f16 = Foods(node: celeryNode, carb_count: 0, carb: false)
        collection.append(f16)
        
        let chickenNode = SKSpriteNode(imageNamed: "Foods.sprite/chicken.png")
        let f17 = Foods(node: chickenNode, carb_count: 0, carb: false)
        collection.append(f17)
        
        let fishNode = SKSpriteNode(imageNamed: "Foods.sprite/fish.png")
        let f18 = Foods(node: fishNode, carb_count: 0, carb: false)
        collection.append(f18)
        
        let mushroomNode = SKSpriteNode(imageNamed: "Foods.sprite/mushroom.png")
        let f19 = Foods(node: mushroomNode, carb_count: 0, carb: false)
        collection.append(f19)
        
        let olive_oilNode = SKSpriteNode(imageNamed: "Foods.sprite/olive_oil.png")
        let f20 = Foods(node: olive_oilNode, carb_count: 0, carb: false)
        collection.append(f20)
        
        let porkNode = SKSpriteNode(imageNamed: "Foods.sprite/pork.png")
        let f21 = Foods(node: porkNode, carb_count: 0, carb: false)
        collection.append(f21)
        
        let spinachNode = SKSpriteNode(imageNamed: "Foods.sprite/spinach.png")
        let f22 = Foods(node: spinachNode, carb_count: 0, carb: false)
        collection.append(f22)
        
        let steakNode = SKSpriteNode(imageNamed: "Foods.sprite/steak.png")
        let f23 = Foods(node: steakNode, carb_count: 0, carb: false)
        collection.append(f23)
        
        let waterNode = SKSpriteNode(imageNamed: "Foods.sprite/water.png")
        let f24 = Foods(node: waterNode, carb_count: 0, carb: false)
        collection.append(f24)
        
        
        
    }
    
    //COLLISION DETECTION
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == "food") {
            if let node = contact.bodyA.node as? SKSpriteNode {
                for food in collection {
                    if food.node.texture == node.texture {
                        if(!food.carb){
                            incrementMeter()
                        }
                    }
                }
            }
            contact.bodyA.node?.removeFromParent()
            if(streak == 10){
                endRound()
            }
            

        }else if(contact.bodyB.node?.name == "food"){
            if let node = contact.bodyB.node as? SKSpriteNode {
                for food in collection {
                    if food.node.texture == node.texture {
                        if(!food.carb){
                            incrementMeter()
                            print("incremented meter")
                        }
                    }
                }}
            contact.bodyB.node?.removeFromParent()
    
            if(streak == 10){
                endRound()
            }
        }
        
        
    }
    
    func playSound(sound : SKAction) {
        run(sound)
    }
    
    
    //increment meter by number of carbs
    func incrementMeter(){
        foodMeter.size = CGSize(width: foodMeter.size.width + (frame.size.width / 10), height: foodMeter.size.height)
    }
    
    func endRound(){
        view?.scene?.isPaused = true
        
    }
   
        
}




