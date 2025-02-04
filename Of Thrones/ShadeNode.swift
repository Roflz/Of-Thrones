//
//  ShadeNode.swift
//  ButtonApp
//
//  Created by Riley Mahn on 9/12/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import SpriteKit

class ShadeNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    var shadow: SKNode!
    var legs: SKNode!
    var head: SKNode!
    var eyes: SKNode!
    var lowerTorso: SKNode!
    var upperTorso: SKNode!
    var upperArmFront: SKNode!
    var lowerArmFront: SKNode!
    var upperArmBack: SKNode!
    var lowerArmBack: SKNode!
    var fistFront: SKNode!
    var fistBack: SKNode!
    var skull: SKNode!
    let upperFrontArmAngleDeg: CGFloat = 58.422
    let lowerFrontArmAngleDeg: CGFloat = 90
    let upperBackArmAngleDeg: CGFloat = -79.611
    let lowerBackArmAngleDeg: CGFloat = 101.671
    
    var lastUpdateTimeInterval: TimeInterval = 0
    var dt: TimeInterval = 0
    
    let emitter = SKEmitterNode(fileNamed: "Darkness.sks")!
    
    func didMoveToScene() {
        
        shadow  = childNode(withName: "shadow")
        lowerTorso = childNode(withName: "torso_lower")
        
        legs = lowerTorso.childNode(withName: "legs")
        upperTorso = lowerTorso.childNode(withName: "torso_upper")
        upperArmFront = upperTorso.childNode(withName: "arm_upper_front")
        lowerArmFront = upperArmFront.childNode(withName: "arm_lower_front")
        upperArmBack = upperTorso.childNode(withName: "arm_upper_back")
        lowerArmBack = upperArmBack.childNode(withName: "arm_lower_back")
        fistFront = lowerArmFront.childNode(withName: "fist_front")
        fistBack = lowerArmBack.childNode(withName: "fist_back")
        head = upperTorso.childNode(withName: "head")
        eyes = head.childNode(withName: "eyes")
        skull = fistFront.childNode(withName: "skull")
        
        let rotationConstraintArm = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(160))
        lowerArmFront.reachConstraints = rotationConstraintArm
        lowerArmBack.reachConstraints = rotationConstraintArm
        
        isUserInteractionEnabled = true
    }
    
    /*
    func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTimeInterval > 0 {
            dt = currentTime - lastUpdateTimeInterval
        } else {
            dt = 0
        }
        lastUpdateTimeInterval = currentTime
        print(lastUpdateTimeInterval)
        
        skull.position = fistFront.position + CGPoint(x:35,y:35)
        
    }*/
    
    func interact() {
        run(SKAction.sequence([
            SKAction.scale(to: 0.8, duration: 0.1),
            SKAction.removeFromParent()
            ]))
        isUserInteractionEnabled = false
    }
    
    func punchAt(upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode, lowerArmDegrees: CGFloat, upperArmDegrees: CGFloat, amountToReach: CGPoint) {
        let positionInScene = fistNode.scene?.convert(fistNode.position,
                                                      from: fistNode.parent!)
        let punch = SKAction.reach(to: positionInScene! + amountToReach, rootNode: upperArmNode, duration: 0.3)
        let wait = SKAction.wait(forDuration: 2.9)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: upperArmDegrees.degreesToRadians(), duration: 0.3))
            lowerArmNode.run(SKAction.rotate(toAngle: lowerArmDegrees.degreesToRadians(), duration: 0.3))
        }
        fistNode.run(SKAction.sequence([punch, wait, restore]))
    }
    
    func rotateSkull() {
        let rotateTo = SKAction.rotate(toAngle: 0*π/180, duration: 0.3)
        let wait = SKAction.wait(forDuration: 2.9)
        let restore = SKAction.rotate(toAngle: (32*π)/180, duration: 0.3)
        skull.run(SKAction.sequence([rotateTo, wait, restore]))
    }
    
    func punchAt() {
        
        punchAt(upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront, lowerArmDegrees: lowerFrontArmAngleDeg, upperArmDegrees: upperFrontArmAngleDeg, amountToReach: CGPoint(x: 80, y: 70))
        punchAt(upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack, lowerArmDegrees: lowerBackArmAngleDeg, upperArmDegrees: upperBackArmAngleDeg, amountToReach: CGPoint(x:15,y:10))
        rotateSkull()
        
    }
    
    func fadeBody() {
        let fadein = SKAction.fadeAlpha(to: 0.8, duration: 0.5)
        let wait = SKAction.wait(forDuration: 2.8)
        let fadeout = SKAction.fadeAlpha(to: 0.4, duration: 0.5)
        
        self.run(SKAction.sequence([fadein,wait,fadeout]))
        /*
        legs.run(SKAction.sequence([fadein,wait,fadeout]))
        upperTorso.run(SKAction.sequence([fadein,wait,fadeout]))
        */
    }
    
    func fadeEyes() {
        let fadein = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let wait = SKAction.wait(forDuration: 2.8)
        let fadeout = SKAction.fadeOut(withDuration: 0.5)
        
        eyes.run(SKAction.sequence([fadein,wait,fadeout]))
    }
}
