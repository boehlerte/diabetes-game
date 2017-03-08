
import SpriteKit

enum object:UInt32{
    case food = 1
    case player = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var collection = [Foods]()
    // create array for all food items
    
    let player = SKSpriteNode(imageNamed: "ram")
    
    var playerTouched:Bool = false
    var playerLocation = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        
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
        
    }
    
    // RECOGNIZING TOUCH GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        playerTouched = true
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
        
        let randd = Int(arc4random_uniform(3))
        // random number casted as int to pick food to show next
        let food = collection[randd].foodType.copy() as! SKSpriteNode
        
        // Determine where to spawn the food along the Y axis
        let actualY = random(min: food.size.height/2, max: (size.height - food.size.height/2)/2)
        
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
        
        let Bread = SKSpriteNode(imageNamed: "Foods.sprite/Bread.png")
        let f1 = Foods(carb_count: 5, carb: true, foodType: Bread)
        collection.append(f1)
        
        let Banana = SKSpriteNode(imageNamed: "Foods.sprite/Banana.png")
        let f2 = Foods(carb_count: 5, carb: true, foodType: Banana)
        collection.append(f2)
        
        let Pizza = SKSpriteNode(imageNamed: "Foods.sprite/Pizza.png")
        let f3 = Foods(carb_count: 5, carb: true, foodType: Pizza)
        collection.append(f3)
        
        let Strawberry = SKSpriteNode(imageNamed: "Foods.sprite/Strawberry.png")
        let f4 = Foods(carb_count: 5, carb: true, foodType: Strawberry)
        collection.append(f4)
        
        
    }
    
    // COLLISION DETECTION
    func didBegin(_ contact: SKPhysicsContact) {
        
        if(contact.bodyA.node?.name == "food"){
            contact.bodyA.node?.removeFromParent()
        }else if(contact.bodyB.node?.name == "food"){
            contact.bodyB.node?.removeFromParent()
        }
        
        
    }
    
    
}
