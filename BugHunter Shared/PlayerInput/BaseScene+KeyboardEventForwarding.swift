//
//  Created by Carson Rau July 2023
//

import Cocoa

/*
    Extend `BaseScene` to forward events from the scene to a platform-specific
    control input source. On OS X, this is a `KeyboardControlInputSource`.
*/
extension BaseScene {
    // MARK: Properties
    
    var keyboardControlInputSource: KeyboardControlInputSource {
        return sceneManager.gameInput.nativeControlInputSource as! KeyboardControlInputSource
    }
    
    // MARK: NSResponder
    
    override func mouseDown(with event: NSEvent) {
        keyboardControlInputSource.handleMouseDownEvent()
    }
    
    override func mouseUp(with event: NSEvent) {
        keyboardControlInputSource.handleMouseUpEvent()
    }

    override func keyDown(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }

        for character in characters {
            keyboardControlInputSource.handleKeyDown(forCharacter: character)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }
        
        for character in characters {
            keyboardControlInputSource.handleKeyUp(forCharacter: character)
        }
    }
}
