//
//  Created by Carson Rau July 2023
//

import GameplayKit

class SceneLoaderDownloadFailedState: GKState {
    // MARK: Properties
    
    unowned let sceneLoader: SceneLoader
    
    // MARK: Initialization
    
    init(sceneLoader: SceneLoader) {
        self.sceneLoader = sceneLoader
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Clear the `sceneLoader`'s progress.
        sceneLoader.progress = nil

        // Notify any interested objects that the download has failed.
        NotificationCenter.default.post(name: NSNotification.Name.SceneLoaderDidFailNotification, object: sceneLoader)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SceneLoaderDownloadingResourcesState.Type
    }
}
