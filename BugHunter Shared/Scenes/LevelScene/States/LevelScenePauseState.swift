//
//  Created by Carson Rau July 2023
//

import SpriteKit
import GameplayKit

class LevelScenePauseState: LevelSceneOverlayState {
    // MARK: Properties

    override var overlaySceneFileName: String {
        return "PauseScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        levelScene.worldNode.isPaused = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LevelSceneActiveState.Type
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.worldNode.isPaused = false
    }
}
