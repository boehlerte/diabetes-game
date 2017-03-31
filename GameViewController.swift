import UIKit
import SpriteKit

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
    
        
        let soundSwitch=UISwitch();
        soundSwitch.isOn = true
        soundSwitch.setOn(true, animated: false);
//        switchDemo.addTarget(self, action: "switchValueDidChange:", for: .valueChanged);
        self.view?.addSubview(soundSwitch);
        
//        if(soundSwitch) {
//            
//        }

    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    

}
