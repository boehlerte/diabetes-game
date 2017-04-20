
import SpriteKit

enum object:UInt32{
    case food = 1
    case player = 2
}

class Level1: SKScene, SKPhysicsContactDelegate{
    var gameOver = false

    
    //initialize player avatar
    let player = SKSpriteNode(imageNamed: "ram")
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    let successScreen = SKSpriteNode(imageNamed: "success-icon")
    let levelOneScreen = SKSpriteNode(imageNamed: "level1icon")
    let background_lunch = SKSpriteNode(imageNamed: "background_breakfast")
    
    //pause when touch contact ends
    let pauseScreen = SKLabelNode(fontNamed: "Chalkduster")
    
    let scoreBar = SKLabelNode(fontNamed: "Marker Felt")
    let streakStar = SKSpriteNode(imageNamed: "star")
    let streakValue = SKLabelNode(fontNamed: "Marker Felt")
    let count_label = SKLabelNode(fontNamed: "Marker Felt")

    
    // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)

    var goal = 0
    var streak = 0
    var itemsCollected = 0
    var score = 0
    
    //meter to keep track of streak
    var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
    
    
    override func didMove(to view: SKView) {
        
        background_lunch.size = self.frame.size
        background_lunch.position = CGPoint(x: size.width/2, y: size.height * 0.55)
        background_lunch.zPosition = -1
        addChild(background_lunch)
        
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
        
        // change non-carb goal depending on round selected
        if(RoundSelect.round==1) {
            goal = 5
        } else if(RoundSelect.round==2) {
            goal = 10
        } else if(RoundSelect.round==3) {
            goal = 15
        } else if(RoundSelect.round==4) {
            goal = 20
        } else if(RoundSelect.round==5) {
            goal = 20
        }

        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: 0.5) // was 1
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
        foodMeter.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(foodMeter)
        
        //create pause screen attributes - add pause screen when touch contact ends
        pauseScreen.text = "PAUSED"
        pauseScreen.fontSize = 150
        pauseScreen.fontColor = SKColor.black
        pauseScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseScreen.zPosition = 1.0
        
        //position success screen to center
        successScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        successScreen.zPosition = 1.0
        
        
        levelOneScreen.position = CGPoint(x: frame.midX, y: frame.midY)
        levelOneScreen.zPosition = 1.0
        addChild(levelOneScreen)
        levelOneScreen.run(
            SKAction.fadeOut(withDuration: 0.5)
        )
        
        scoreBar.text = "SCORE: \(score)"
        scoreBar.fontSize = 30
        scoreBar.fontColor = SKColor.blue
        scoreBar.position = CGPoint(x: size.width * 0.9, y: size.height * 0.95)
        scoreBar.zPosition = 1.0
        addChild(scoreBar)
        
        streakStar.position = CGPoint(x: size.width * 0.80, y: size.height * 0.96)
        streakStar.zPosition = 1.0
        addChild(streakStar)
        
        streakValue.text = "\(streak)"
        streakValue.fontSize = 30
        streakValue.position = CGPoint(x: size.width * 0.77, y: size.height * 0.95)
        streakValue.zPosition = 1.0
        addChild(streakValue)
        
        count_label.text = "You have \(itemsCollected) out of \(goal) non-carbs!"
        count_label.fontSize = 60
        count_label.fontColor = SKColor.black
        count_label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        count_label.zPosition = 1.0
        addChild(count_label)
        
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
        if (!gameOver){
            playerTouched = false
            //pause game when player lifts finger
            view?.scene?.isPaused = true
            addChild(pauseScreen)
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
        
        
        
        let randd = Int(arc4random_uniform(43))
        // random number casted as int to pick food to show
        let food = Foods.collection[randd].node.copy() as! SKSpriteNode
        
        
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
        for food in Foods.collection {
            if food.node.texture == node.texture {
                if(!food.carb){
                    playSound(sound: good_carb)
                    streak += 1
                    itemsCollected += 1
                    count_label.text = "You have \(itemsCollected) out of \(goal) non-carbs!"
                    streakValue.text = "\(streak)"
                    //emphasize star on streak increase
                    let scaleUp = SKAction.scale(to: 1.5, duration: 0.5)
                    let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
                    let sequence = SKAction.sequence([scaleUp, scaleDown])
                    streakStar.run(sequence)
                    score += (100 * streak)
                    scoreBar.text = "SCORE: \(score)"
                    incrementMeter()
                }else{
                    playSound(sound: bad_carb)
                    let retryScreen = SKSpriteNode(imageNamed: "retry-icon")
                    retryScreen.position = CGPoint(x: frame.midX, y: frame.midY)
                    retryScreen.zPosition = 1.0
                    addChild(retryScreen)
                    retryScreen.run(
                        SKAction.fadeOut(withDuration: 0.5)
                    )
                    streak = 0
                    streakValue.text = "\(streak)"
                    score -= 20
                    scoreBar.text = "SCORE: \(score)"
                }
            }
        }
        
        if(itemsCollected == goal){
            endRound()
        }
        
    }
    
    func playSound(sound : SKAction) {
        run(sound)
    }
    
    
    //increment meter by number of carbs
    func incrementMeter(){
        let total = (Float) (frame.size.width)
        let goal = (Float) (self.goal)
        let meter_count = CGFloat(total/goal)
        foodMeter.size = CGSize(width: foodMeter.size.width + meter_count, height: foodMeter.size.height)
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


