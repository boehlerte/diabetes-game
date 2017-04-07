import Foundation
import SpriteKit

class Foods{
    
    //    var collection = [Foods]()
    var node: SKSpriteNode
    var carb_count :Int
    var carb: Bool
    var b: Bool     // breakfast?
    var l: Bool     // lunch?
    var d: Bool     // dinner?
    
    init(node: SKSpriteNode, carb_count: Int, carb: Bool, b: Bool, l: Bool, d: Bool){
        self.node = node
        self.carb_count = carb_count
        self.carb = carb
        self.b = b
        self.l = l
        self.d = d
    }
    
    
    
    
    
    
}
