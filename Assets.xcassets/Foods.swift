import Foundation
import SpriteKit

class Foods{
    
    //collection of food sprites
    static var collection = [Foods]()
    
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
    
    
    
    static func NewFood() {
        
        
        let pizzaNode = SKSpriteNode(imageNamed: "Foods.sprite/pizza.png")
        let f1 = Foods(node: pizzaNode, carb_count: 30, carb: true, b: false, l:true, d:true)
        collection.append(f1)
        
        let appleNode = SKSpriteNode(imageNamed: "Foods.sprite/apple.png")
        let f2 = Foods(node: appleNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        collection.append(f2)
        
        let burgerNode = SKSpriteNode(imageNamed: "Foods.sprite/burger.png")
        let f3 = Foods(node: burgerNode, carb_count: 30, carb: true, b: false, l:true, d:true)
        collection.append(f3)
        
        let broccoliNode = SKSpriteNode(imageNamed: "Foods.sprite/broccoli.png")
        let f4 = Foods(node: broccoliNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f4)
        
        let bananaNode = SKSpriteNode(imageNamed: "Foods.sprite/banana.png")
        let f5 = Foods(node: bananaNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        collection.append(f5)
        
        let cookieNode = SKSpriteNode(imageNamed: "Foods.sprite/cookie.png")
        let f6 = Foods(node: cookieNode, carb_count: 9, carb: true, b: true, l:true, d:true)
        collection.append(f6)
        
        let donutNode = SKSpriteNode(imageNamed: "Foods.sprite/donut.png")
        let f7 = Foods(node: donutNode, carb_count: 22, carb: true, b: true, l:true, d:true)
        collection.append(f7)
        
        let friesNode = SKSpriteNode(imageNamed: "Foods.sprite/fries.png")
        let f8 = Foods(node: friesNode, carb_count: 45, carb: true, b: false, l:true, d:true)
        collection.append(f8)
        
        let grapesNode = SKSpriteNode(imageNamed: "Foods.sprite/grapes.png")
        let f9 = Foods(node: grapesNode, carb_count: 15, carb: true, b: true, l:true, d:false)
        collection.append(f9)
        
        let hotdogNode = SKSpriteNode(imageNamed: "Foods.sprite/hotdog.png")
        let f10 = Foods(node: hotdogNode, carb_count: 21, carb: true, b: false, l:true, d:true)
        collection.append(f10)
        
        let ice_creamNode = SKSpriteNode(imageNamed: "Foods.sprite/ice_cream.png")
        let f11 = Foods(node: ice_creamNode, carb_count: 23, carb: true, b: false, l:true, d:true)
        collection.append(f11)
        
        let mangoNode = SKSpriteNode(imageNamed: "Foods.sprite/mango.png")
        let f12 = Foods(node: mangoNode, carb_count: 50, carb: true, b: true, l:true, d:false)
        collection.append(f12)
        
        let peachNode = SKSpriteNode(imageNamed: "Foods.sprite/peach.png")
        let f13 = Foods(node: peachNode, carb_count: 14, carb: true, b: true, l:true, d:false)
        collection.append(f13)
        
        let baconNode = SKSpriteNode(imageNamed: "Foods.sprite/bacon.png")
        let f14 = Foods(node: baconNode, carb_count: 0, carb: false, b: true, l:true, d:false)
        collection.append(f14)
        
        let carrotNode = SKSpriteNode(imageNamed: "Foods.sprite/carrot.png")
        let f15 = Foods(node: carrotNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f15)
        
        let celeryNode = SKSpriteNode(imageNamed: "Foods.sprite/celery.png")
        let f16 = Foods(node: celeryNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f16)
        
        let chickenNode = SKSpriteNode(imageNamed: "Foods.sprite/chicken.png")
        let f17 = Foods(node: chickenNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f17)
        
        let fishNode = SKSpriteNode(imageNamed: "Foods.sprite/fish.png")
        let f18 = Foods(node: fishNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f18)
        
        let mushroomNode = SKSpriteNode(imageNamed: "Foods.sprite/mushroom.png")
        let f19 = Foods(node: mushroomNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f19)
        
        let porkNode = SKSpriteNode(imageNamed: "Foods.sprite/pork.png")
        let f20 = Foods(node: porkNode, carb_count: 0, carb: false, b: true, l:true, d:true)
        collection.append(f20)
        
        let spinachNode = SKSpriteNode(imageNamed: "Foods.sprite/spinach.png")
        let f21 = Foods(node: spinachNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f21)
        
        let steakNode = SKSpriteNode(imageNamed: "Foods.sprite/steak.png")
        let f22 = Foods(node: steakNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f22)
        
        //        let olive_oilNode = SKSpriteNode(imageNamed: "Foods.sprite/olive_oil.png")
        //        let f29 = Foods(node: olive_oilNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        //        collection.append(f29)
        
        let bagelNode = SKSpriteNode(imageNamed: "Foods.sprite/bagel.png")
        let f23 = Foods(node: bagelNode, carb_count: 48, carb: true, b: true, l:true, d:false)
        collection.append(f23)
        let biscuitNode = SKSpriteNode(imageNamed: "Foods.sprite/biscuit.png")
        let f24 = Foods(node: biscuitNode, carb_count: 6, carb: true, b: true, l:false, d:false)
        collection.append(f24)
        let burritoNode = SKSpriteNode(imageNamed: "Foods.sprite/burrito.png")
        let f25 = Foods(node: burritoNode, carb_count: 71, carb: true, b: false, l:true, d:true)
        collection.append(f25)
        //        let carrot_sticksNode = SKSpriteNode(imageNamed: "Foods.sprite/carrot_sticks.png")
        //        let f33 = Foods(node: carrot_sticksNode, carb_count: 6, carb: true, b: false, l:true, d:true)
        //        collection.append(f33)
        let cerealNode = SKSpriteNode(imageNamed: "Foods.sprite/cereal.png")
        let f26 = Foods(node: cerealNode, carb_count: 25, carb: true, b: true, l:false, d:false)
        collection.append(f26)
        let cheeseNode = SKSpriteNode(imageNamed: "Foods.sprite/cheese.png")
        let f27 = Foods(node: cheeseNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f27)
        let chicken_nuggetsNode = SKSpriteNode(imageNamed: "Foods.sprite/chicken_nuggets.png")
        let f28 = Foods(node: chicken_nuggetsNode, carb_count: 10, carb: true, b: false, l:true, d:true)
        collection.append(f28)
        let chipsNode = SKSpriteNode(imageNamed: "Foods.sprite/chips.png")
        let f29 = Foods(node: chipsNode, carb_count: 15, carb: true, b: false, l:true, d:true)
        collection.append(f29)
        let eggNode = SKSpriteNode(imageNamed: "Foods.sprite/egg.png")
        let f30 = Foods(node: eggNode, carb_count: 0, carb: false, b: true, l:false, d:false)
        collection.append(f30)
        let enchiladasNode = SKSpriteNode(imageNamed: "Foods.sprite/enchiladas.png")
        let f31 = Foods(node: enchiladasNode, carb_count: 30, carb: true, b: false, l:true, d:true)
        collection.append(f31)
        let mac_and_cheeseNode = SKSpriteNode(imageNamed: "Foods.sprite/mac_and_cheese.png")
        let f32 = Foods(node: mac_and_cheeseNode, carb_count: 44, carb: true, b: false, l:true, d:true)
        collection.append(f32)
        let milkNode = SKSpriteNode(imageNamed: "Foods.sprite/milk.png")
        let f33 = Foods(node: milkNode, carb_count: 12, carb: true, b: true, l:true, d:true)
        collection.append(f33)
        let pickleNode = SKSpriteNode(imageNamed: "Foods.sprite/pickle.png")
        let f34 = Foods(node: pickleNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f34)
        let quesadillaNode = SKSpriteNode(imageNamed: "Foods.sprite/quesadilla.png")
        let f35 = Foods(node: quesadillaNode, carb_count: 43, carb: true, b: false, l:true, d:true)
        collection.append(f35)
        let riceNode = SKSpriteNode(imageNamed: "Foods.sprite/rice.png")
        let f36 = Foods(node: riceNode, carb_count: 45, carb: true, b: false, l:true, d:true)
        collection.append(f36)
        let sandwichNode = SKSpriteNode(imageNamed: "Foods.sprite/sandwich.png")
        let f37 = Foods(node: sandwichNode, carb_count: 26, carb: true, b: false, l:true, d:true)
        collection.append(f37)
        let sausageNode = SKSpriteNode(imageNamed: "Foods.sprite/sausage.png")
        let f38 = Foods(node: sausageNode, carb_count: 0, carb: false, b: true, l:true, d:true)
        collection.append(f38)
        let shrimpNode = SKSpriteNode(imageNamed: "Foods.sprite/shrimp.png")
        let f39 = Foods(node: shrimpNode, carb_count: 0, carb: false, b: false, l:true, d:true)
        collection.append(f39)
        let spaghettiNode = SKSpriteNode(imageNamed: "Foods.sprite/spaghetti.png")
        let f40 = Foods(node: spaghettiNode, carb_count: 43, carb: true, b: false, l:true, d:true)
        collection.append(f40)

        let tacosNode = SKSpriteNode(imageNamed: "Foods.sprite/tacos.png")
        let f41 = Foods(node: tacosNode, carb_count: 14, carb: true, b: false, l:true, d:true)
        collection.append(f41)
        let toastNode = SKSpriteNode(imageNamed: "Foods.sprite/toast.png")
        let f42 = Foods(node: toastNode, carb_count: 13, carb: true, b: true, l:false, d:true)
        collection.append(f42)
        
        let chocolatemilkNode = SKSpriteNode(imageNamed: "Foods.sprite/chocolate_milk.png")
        let f43 = Foods(node: chocolatemilkNode, carb_count: 26, carb: true, b: true, l:true, d:true)
        collection.append(f43)
        
        let waterNode = SKSpriteNode(imageNamed: "Foods.sprite/water.png")
        let f44 = Foods(node: waterNode, carb_count: 0, carb: false, b: true, l:true, d:true)
        collection.append(f44)
                let strawberry_milkNode = SKSpriteNode(imageNamed: "Foods.sprite/strawberry_milk.png")
                let f45 = Foods(node: strawberry_milkNode, carb_count: 33, carb: true, b: true, l:false, d:false)
                collection.append(f45)
        
        
        
    }
    
    
    
    
}
