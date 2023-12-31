//
//  Created by Carson Rau July 2023
//

import simd

enum ControlInputDirection: Int {
    case up = 0, down, left, right
    
    init?(vector: SIMD2<Float>) {
        // Require sufficient displacement to specify direction.
        guard length(vector) >= 0.5 else { return nil }
        
        // Take the max displacement as the specified axis.
        if abs(vector.x) > abs(vector.y) {
            self = vector.x > 0 ? .right : .left
        }
        else {
            self = vector.y > 0 ? .up : .down
        }
    }
}

/// Delegate methods for responding to control input that applies to the game as a whole.
protocol ControlInputSourceGameStateDelegate: AnyObject {
    func controlInputSourceDidSelect(_ controlInputSource: ControlInputSourceType)
    func controlInputSource(_ controlInputSource: ControlInputSourceType, didSpecifyDirection: ControlInputDirection)
    func controlInputSourceDidTogglePauseState(_ controlInputSource: ControlInputSourceType)
    
    #if DEBUG
    func controlInputSourceDidToggleDebugInfo(_ controlInputSource: ControlInputSourceType)
    
    func controlInputSourceDidTriggerLevelSuccess(_ controlInputSource: ControlInputSourceType)
    func controlInputSourceDidTriggerLevelFailure(_ controlInputSource: ControlInputSourceType)
    #endif
}

/// Delegate methods for responding to control input that applies to the `PlayerBot`.
protocol ControlInputSourceDelegate: AnyObject {
    /**
        Update the `ControlInputSourceDelegate` with new displacement
        in a top down 2D coordinate system (x, y):
            Up:    (0.0, 1.0)
            Down:  (0.0, -1.0)
            Left:  (-1.0, 0.0)
            Right: (1.0, 0.0)
    */
    func controlInputSource(_ controlInputSource: ControlInputSourceType, didUpdateDisplacement displacement: SIMD2<Float>)
    
    /**
        Update the `ControlInputSourceDelegate` with new angular displacement
        denoting both the requested angle, and magnitude with which to rotate.
        Measured in radians.
     */
    func controlInputSource(_ controlInputSource: ControlInputSourceType, didUpdateAngularDisplacement angularDisplacement: SIMD2<Float>)
    
    /**
        Update the `ControlInputSourceDelegate` to move forward or backward
        relative to the orientation of the entity.
            Forward:  (0.0, 1.0)
            Backward: (0.0, -1.0)
     */
    func controlInputSource(_ controlInputSource: ControlInputSourceType, didUpdateWithRelativeDisplacement relativeDisplacement: SIMD2<Float>)
    
    /**
        Update the `ControlInputSourceDelegate` with new angular displacement
        relative to the entity's existing orientation.
            Clockwise:        (-1.0, 0.0)
            CounterClockwise: (1.0, 0.0)
     */
    func controlInputSource(_ controlInputSource: ControlInputSourceType, didUpdateWithRelativeAngularDisplacement relativeAngularDisplacement: SIMD2<Float>)
    
    /// Instructs the `ControlInputSourceDelegate` to cause the player to attack.
    func controlInputSourceDidBeginAttacking(_ controlInputSource: ControlInputSourceType)
    
    /// Instructs the `ControlInputSourceDelegate` to end the player's attack.
    func controlInputSourceDidFinishAttacking(_ controlInputSource: ControlInputSourceType)
}

/// A protocol to be adopted by classes that provide control input and notify their delegates when input is available.
protocol ControlInputSourceType: AnyObject {
    /// A delegate that receives information about actions that apply to the `PlayerBot`.
    var delegate: ControlInputSourceDelegate? { get set }
    
    /// A delegate that receives information about actions that apply to the game as a whole.
    var gameStateDelegate: ControlInputSourceGameStateDelegate? { get set }
    
    var allowsStrafing: Bool { get }
    
    func resetControlState()
}
