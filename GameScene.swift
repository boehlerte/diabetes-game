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
        let pizza = Foods(node: pizzaNode, carb_count: 30, carb: true)
        collection.append(pizza)
        
        let appleNode = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
        let apple = Foods(node: appleNode, carb_count: 15, carb: true)
        collection.append(apple)
        
        let burgerNode = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
        let burger = Foods(node: burgerNode, carb_count: 30, carb: true)
        collection.append(burger)
        
        let broccoliNode = SKSpriteNode(imageNamed: "Foods.sprite/broccoli.png")
        let broccoli = Foods(node: broccoliNode, carb_count: 0, carb: false)
        collection.append(broccoli)
        
        
        
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




