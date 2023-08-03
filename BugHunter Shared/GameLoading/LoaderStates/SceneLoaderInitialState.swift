//
//  Created by Carson Rau July 2023
//

import GameplayKit

class SceneLoaderInitialState: GKState {
    // MARK: Properties
    
    unowned let sceneLoader: SceneLoader

    // MARK: Initialization
    
    init(sceneLoader: SceneLoader) {
        self.sceneLoader = sceneLoader
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        #if os(iOS) || os(tvOS)
        // Move the `stateMachine` to the available state if no on-demand resources are required.
        if !sceneLoader.sceneMetadata.requiresOnDemandResources {
            stateMachine!.enter(SceneLoaderResourcesAvailableState.self)
        }
        #elseif os(OSX)
        // On OS X the resources will always be in local storage available for download.
        _ = stateMachine!.enter(SceneLoaderResourcesAvailableState.self)
        #endif
    }
    
    override func isValidNextState(_  stateClass: AnyClass) -> Bool {
        #if os(iOS) || os(tvOS)
        if stateClass is SceneLoaderDownloadingResourcesState.Type {
            return true
        }
        #endif
        
        return stateClass is SceneLoaderResourcesAvailableState.Type
    }
}
