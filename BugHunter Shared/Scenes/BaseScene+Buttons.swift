//
//  Created by Carson Rau July 2023
//

import Foundation

/// Extends `BaseScene` to respond to ButtonNode events.
extension BaseScene: ButtonNodeResponderType {
    
    /// Searches the scene for all `ButtonNode`s.
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allButtonIdentifiers.compactMap { buttonIdentifier in
            childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
    
    // MARK: ButtonNodeResponderType
    
    @objc func buttonTriggered(button: ButtonNode) {
        switch button.buttonIdentifier! {
            case .home:
                sceneManager.transitionToScene(identifier: .home)
            
            case .proceedToNextScene:
                sceneManager.transitionToScene(identifier: .nextLevel)
            
            case .replay:
                sceneManager.transitionToScene(identifier: .currentLevel)
            
            case .screenRecorderToggle:
                #if os(iOS)
                toggleScreenRecording(button: button)
                #endif
            
            case .viewRecordedContent:
                #if os(iOS)
                displayRecordedContent()
                #endif

            default:
                fatalError("Unsupported ButtonNode type in Scene.")
        }
    }
}
