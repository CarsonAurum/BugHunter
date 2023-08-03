//
//  Created by Carson Rau July 2023
//

import GameplayKit

class SceneLoaderResourcesAvailableState: GKState {
    // MARK: Properties
    
    unowned let sceneLoader: SceneLoader
    
    // MARK: Initialization
    
    init(sceneLoader: SceneLoader) {
        self.sceneLoader = sceneLoader
    }
    
    // MARK: GKState Life Cycle
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
            case is SceneLoaderInitialState.Type, is SceneLoaderPreparingResourcesState.Type:
                return true
            
            default:
                return false
        }
    }
    
}
