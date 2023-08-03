//
//  Created by Carson Rau July 2023
//

import SpriteKit
import GameplayKit

class BeamIdleState: GKState {
    // MARK: Properties
    
    unowned var beamComponent: BeamComponent
    
    // MARK: Initializers
    
    required init(beamComponent: BeamComponent) {
        self.beamComponent = beamComponent
    }
    
    // MARK: GKState life cycle
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        // If the beam has been triggered, enter `BeamFiringState`.
        if beamComponent.isTriggered {
            stateMachine?.enter(BeamFiringState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BeamFiringState.Type
    }
}
