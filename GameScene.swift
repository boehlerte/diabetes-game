import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "dot")
    var touched:Bool = false
    var location = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.cyan
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(player)
       
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        touched = true
        for touch in touches {
            location = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            location = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        touched = false
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if(touched) {
            moveNodeToLocation()
        }
    }
    
    func moveNodeToLocation() {
        let speed: CGFloat = 0.25
        
        var dx = location.x - player.position.x
        var dy = location.y - player.position.y
        
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
        
        let apple = SKSpriteNode(imageNamed: "apple")
        
        // Determine where to spawn the food along the Y axis
        let actualY = random(min: apple.size.height/2, max: size.height - apple.size.height/2)
        
        apple.position = CGPoint(x: size.width + apple.size.width/2, y: actualY)
        
        // Add the food to the game
        addChild(apple)
        
        // Calculate the speed of the food
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -apple.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        apple.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
}
