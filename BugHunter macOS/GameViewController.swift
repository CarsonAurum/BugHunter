//
//
//  Created by Carson Rau July 2023
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController {
    // MARK: Properties
    
    /// A manager for coordinating scene resources and presentation.
    var sceneManager: SceneManager!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardControlInputSource = KeyboardControlInputSource()
        let gameInput = GameInput(nativeControlInputSource: keyboardControlInputSource)
        
        // Load the initial home scene.
        let skView = view as! SKView
        sceneManager = SceneManager(presentingView: skView, gameInput: gameInput)
        
        sceneManager.transitionToScene(identifier: .home)
    }
}

