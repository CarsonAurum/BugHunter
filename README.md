#  BugHunter

### Written By: Carson Rau, Carlos Ravago, George Prado Garzon, and Chase Perkkola

## Runtime

This game is fully written in Swift. In the interest of efficiency on the development-end, multiple
Apple-specific platforms (SpriteKit, GameplayKit, UIKit/AppKit) are at the core of its functionality.
This game requires XCode version 14 (or later) to build.

This game functions on iOS v14+ and macOS v12+ (with slight differences explained later).

Note: The iOS target is not included, as it was not tested completely in the allowed project timeframe.
While most subsystems have been tested in an iOS target, the successful building of a full iOS project could not
be completed.

## About The Game

While originally intended to be a zombie shooter, the limited availability of assets has shifted
our focus towards a game of fighting robots. 

You, as the player robot, are responsible for locating all agents in a given level. Some agents
will be passive, where others will be hostile (as indicated by their red or green color). There
are two varieties of enemy robots with unique abilities:
  * The first kind of agents are GroundBots that use treads to push themselves closer to their enemies. When they hit the player, they will remove health from the player.
  * The second kind of agents are FlyingBots that fly around in the air. These bots use a radial "blast" attack to be more effective than the ground variants.

Agents can attack passive agents and turn them hostile. Therefore, protecting passive taskbots
can be critical in certain stages of play.

The player is equipped with a beam ray that can neutralize enemies; however, this beam can only
run for a certain time length before needing to recharge. If a bot does not receive enough impulse
from a beam to fully neutralize, it may resume being hostile.

### Controls

On iOS, there are two touchpads that appear on either side of the screen. These attempt to simulate
thumbsticks that would be found on a true gamepad.
  * The left stick controls movement.
  * The right stick, when tapped, controls the beam. The right stick can also be used to change
  orientation independent of movement controls.
  * To pause the game, tap on the timer at the top of the screen.
  
On macOS: 
  * Movement is dictated with the w-a-s-d keyboard combinations (as well as the arrow keys).
  * The beam may be fired with the space bar, the moust, or with the "f" key.
  * To pause the game, press "p"
  
#### Debug Controls

On macOS only, extra debugging controls are available:
  * "]" triggers a failure for the current level.
  * "[" triggers a success for the current level.
  * "/" enables a debugging overlay.

The debugging overlay contains useful visuals for diagnosing issues with game logic and pathfinding:
  * Each enemy's path is represented with a color:
    * Green = Good patrol path
    * Purple = Bad patrol path
    * Red = Enemy in pursuit
    * Yellow = Returning to path
  * White lines identify the pathfinding grid for the level.
  * Orange boxes represent the extended physics bodies given to enemies for pathfinding. This 
    enables tighter control over the enemy movement throughout a level.
  * A blue arc is shown as the target zone when the beam is activated by the player.
  * Cyan outlines show the true physics body for each entity in a level.
  * Frame rate, draw time, and other SpriteKit diagnostics are also visible in the bottom right 
    corner of the window.

### Game Controllers

Basic support for game controllers was attempted to allow bluetooth controllers to be used in lieu
of a keyboard. This functionality appears to be working, but has not been fully tested. Despite
the potential of this subsystem to be unusable, the code written this far is still included.

### Level Replays

Perhaps one of the simplest features to implement on iOS, App-wide replay functionality is baked
directly into SceneKit via the ReplayKit library. On iOS, the auto-recording button will enable
users to capture real time gameplay and watch it back at the completion of a level. This
functionality is implemented by Carson, but it generally follows the available tutorial from
Apple's developer documentation regarding ReplayKit.


## Code Structure

A full diagram of this project would be fairly untenable. The large number of types, subtypes, function
calls, and interrelation via Swift's protocol system would make a UML diagram of this software unusable. 
As such, the general structure is explained as follows:

  * Each application has a front-end interface (found in `BugHunter iOS` and `BugHunter macOS` respectively).
    The types in these folders receive notifications from the OS runtime and begin calling into the scene loading
    mechanism.
  * In order to make the game extensible, most of the levels are created using a visual editor. In addition to the 
    data stored in the visual level data (found in the `BugHunter Assets / Scenes` directory), each level has an
    associated dictionary file containing relevant configuration data. All of this data must be preloaded by the 
    scene loading mechanism in an asynchronous manner. The `GameLoading` directory contains all classes to implement
    this behavior:
      - Initial scene management queries are directed to a `SceneManager` that coordinates loading.
      - Loading and parsing of metadata as `SceneLoader` produce the appropriate ``LoadResourceOperation`` to make the resources available.
      - Preloading is supported; however, given the small number of levels, this functionality is mostly unused.
  * Scene logic is stored in the `Scenes` directory. All scenes inherit from the `BaseScene` which layers functionality specific to our
    application on top of the standard SpriteKit `SKScene` type. All subsequent scenes take advantage of focus behaviors, buttons, and presentation
    behavior from the base scene.
      - Level scenes require a state machine as they support pause/play functionality in addition to replay functionality. 
      - Some scenes use custom nodes (such as the thumbsticks or the blast beam itself) to add additional visual flair. These can be found in `Scenes/Nodes`.
  * Player input mechanisms are all within the `PlayerInput` directory. The player input subsystem is designed to allow the central `GameInput` class
    to handle multiple inputs. In general, each platform has a native input (eg. touch or keyboard) and additional gamepads are supported by adding
    more inputs to this core class. This directory implements its own interface for devices (such as `TouchControlInputNode` and `KeyboardControlInputSource`)
    to wrap around the standard OS-level behavior and separate the OS from the core gameplay mechanisms.
  * The `GameLogic` directory contains all relevant systems for the functional implementation of the gameplay rules outlined above:
    - An entity-component system is employed heavily in this game. All players and enemiers are represented as entities, and all functionality 
    (movement, intelligence, rendering, animation, etc.) are attached as updatable components.
    - An element of fuzzy logic is used when determining which goal a task bot should follow. This is added by the `RulesComponent` and all fuzzy logic can be 
    found within the `Goals` subdirectory. The `Rules.swift` file outlines the fuzzy logic calculations themselves.
    - Very basic collision mechanics are needed for this game. In general, the contact matrix and collision matrix for this game focus primarily on the interactions
    that entities have with the player's beam; along with a few interactions between the enemies themselves. 
    In general, SpriteKit will handle the physics calculations internally provided the scene files properly configure the `physicsBody` on each `SKSpriteNode`: which is done in both of the completed levels.
  * Screen Recording, as explained earlier, is a relatively simple implementation. Those files reside in the `ScreenRecording` directory.
  * Finally, `Utils` contains miscellaneous types, functions, and extensions that are used throughout the game and therefore not directly related to one of the above
  subsystems.
