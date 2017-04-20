import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MenuScene(size: view.bounds.size)

        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    

}
