//
//  Character1.swift
//  ButtonApp
//
//  Created by Riley Mahn on 21/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class Character1: SKNode {
    
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "battleaxe")
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSprite() -> SKSpriteNode {
        return sprite
    }
    
    
}

class Character2: SKNode {
    
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "gun")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSprite() -> SKSpriteNode {
        return sprite
    }
    
    
}

class Shade: SKNode {
    
    
    let shadeScene: SKScene!
    var crotch: SKNode!
    var body: SKNode!
    var upperArmFront: SKNode!
    var lowerArmFront: SKNode!
    var head: SKNode!
    var legs: SKNode!
    
    override init() {
        shadeScene = SKScene(fileNamed: "Shade")!
        super.init()
        crotch = shadeScene.childNode(withName: "crotch")
        body = crotch.childNode(withName: "body")
        upperArmFront = body.childNode(withName: "upper_arm_front")
        lowerArmFront = upperArmFront.childNode(withName: "lower arm front")
        head = body.childNode(withName: "head")
        legs = crotch.childNode(withName: "legs")
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func punchAt(_ location: CGPoint) {
        // 1
        let punch = SKAction.reach(to: location, rootNode: upperArmFront, duration: 0.1)
        // 2
        lowerArmFront.run(punch)
    }
    
    // 3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            print("hi")
            punchAt(location)
        }
    }
    
}

class Character4: SKNode {
    
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "snakes")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSprite() -> SKSpriteNode {
        return sprite
    }
    
    
}

class Character5: SKNode {
    
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "Knife")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSprite() -> SKSpriteNode {
        return sprite
    }
    
    
}

class Character6: SKNode {
    
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "lasergun")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSprite() -> SKSpriteNode {
        return sprite
    }
    
    
}
