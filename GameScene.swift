
import SpriteKit
import UIKit

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
      // make sound effects here, then call playSound(sound: soundname) to play them
    var good_carb = SKAction.playSoundFileNamed("GameSounds/good_carb.wav", waitForCompletion: false)
    var bad_carb = SKAction.playSoundFileNamed("GameSounds/bad_carb.wav", waitForCompletion: false)
    var great_carb = SKAction.playSoundFileNamed("GameSounds/great_carb.wav", waitForCompletion: false)
    var level_complete = SKAction.playSoundFileNamed("GameSounds/level_complete.wav", waitForCompletion: false)
=======
    // use this for sound effects, then call playSound(sound: sound) in DidMove
    // var sound = SKAction.playSoundFileNamed("sound.wav", waitForCompletion: false)
    
    
    var streak = 0
    var foodMeter = SKSpriteNode(color: SKColor .magenta, size: CGSize(width: 0, height: 50))
    
    override func didMove(to view: SKView) {
        
        let backgroundMusic = SKAudioNode(fileNamed: "BackgroundMusic.wav")
        self.addChild(backgroundMusic)
        
        physicsWorld.contactDelegate = self
        
       backgroundColor = SKColor.cyan
    

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
        
        let randd = Int(arc4random_uniform(13))
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
        
        let apple = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
        let f5 = Foods(carb_count: 15, carb: true, foodType: apple)
        collection.append(f5)
        let banana = SKSpriteNode(imageNamed: "Foods.sprite/banana.png")
        let f6 = Foods(carb_count: 15, carb: true, foodType: banana)
        collection.append(f6)
        let burger = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
        let f7 = Foods(carb_count: 30, carb: true, foodType: burger)
        collection.append(f7)
        let cookie = SKSpriteNode(imageNamed: "Foods.sprite/cookie.png")
        let f8 = Foods(carb_count: 9, carb: true, foodType: cookie)
        collection.append(f8)
        let donut = SKSpriteNode(imageNamed: "Foods.sprite/donut.png")
        let f9 = Foods(carb_count: 22, carb: true, foodType: donut)
        collection.append(f9)
        let fries = SKSpriteNode(imageNamed: "Foods.sprite/fries.png")
        let f10 = Foods(carb_count: 45, carb: true, foodType: fries)
        collection.append(f10)
        let grapes = SKSpriteNode(imageNamed: "Foods.sprite/grapes.png")
        let f11 = Foods(carb_count: 15, carb: true, foodType: grapes)
        collection.append(f11)
        let hotdog = SKSpriteNode(imageNamed: "Foods.sprite/hotdog.png")
        let f12 = Foods(carb_count: 21, carb: true, foodType: hotdog)
        collection.append(f12)
        let icecream = SKSpriteNode(imageNamed: "Foods.sprite/icecream.png")
        let f13 = Foods(carb_count: 23, carb: true, foodType: icecream)
        collection.append(f13)
        let mango = SKSpriteNode(imageNamed: "Foods.sprite/mango.png")
        let f14 = Foods(carb_count: 50, carb: true, foodType: mango)
        collection.append(f14)
        let peach = SKSpriteNode(imageNamed: "Foods.sprite/peach.png")
        let f15 = Foods(carb_count: 14, carb: true, foodType: peach)
        collection.append(f15)
        let pizza = SKSpriteNode(imageNamed: "Foods.sprite/pizza.png")
        let f16 = Foods(carb_count: 30, carb: true, foodType: pizza)
        collection.append(f16)
        
        
        
    }
    
    // COLLISION DETECTION
    func didBegin(_ contact: SKPhysicsContact) {
        
        playSound(sound: good_carb)
        // add conditions to change sounds based on food
        
        if(contact.bodyA.node?.name == "food"){
            contact.bodyA.node?.removeFromParent()
        }else if(contact.bodyB.node?.name == "food"){
            contact.bodyB.node?.removeFromParent()
        }
        
        
        
    }
    
    // CALL THIS TO PLAY MUSIC/SOUND
    func playSound(sound : SKAction) {
        run(sound)
    }

}
