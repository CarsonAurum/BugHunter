//
//  Created by Carson Rau July 2023
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

extension LevelScene {
    // MARK: Properties
    
    /**
        The scene's `paused` property is set automatically when the
        app enters the background. Override to check if an `overlay` node is
        being presented to determine if the game should be paused.
    */
    override var isPaused: Bool {
        didSet {
            if overlay != nil {
                worldNode.isPaused = true
            }
        }
    }
    
    /// Platform specific notifications about the app becoming inactive.
    private var pauseNotificationNames: [NSNotification.Name] {
        #if os(OSX)
        return [
            NSApplication.willResignActiveNotification,
            NSWindow.didMiniaturizeNotification
        ]
        #else
        return [
            UIApplication.willResignActiveNotification
        ]
        #endif
    }
    
    // MARK: Convenience
    
    /**
        Register for notifications about the app becoming inactive in
        order to pause the game. 
    */
    func registerForPauseNotifications() {
        for notificationName in pauseNotificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(LevelScene.pauseGame), name: notificationName, object: nil)
        }
    }
    
    @objc func pauseGame() {
        stateMachine.enter(LevelScenePauseState.self)
    }
    
    func unregisterForPauseNotifications() {
        for notificationName in pauseNotificationNames {
            NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        }
    }
}
