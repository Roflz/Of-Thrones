//
//  ShadeNode.swift
//  ButtonApp
//
//  Created by Riley Mahn on 9/12/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import SpriteKit

class Shade: SKSpriteNode, EventListenerNode, InteractiveNode, attackNode {
    
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
    var reversed = false
    var attack1 = false
    var attack2 = false
    var attack3 = true
    var upperFrontArmAngleDeg: CGFloat!
    var lowerFrontArmAngleDeg: CGFloat!
    var upperBackArmAngleDeg: CGFloat!
    var lowerBackArmAngleDeg: CGFloat!
    
    var characterTouched = false
    var lastSwipe: [CGPoint] = []
    
    let attack1Triangle: SKSpriteNode = SKSpriteNode(imageNamed: "TurnSelectionTriangle")
    let attack2Triangle: SKSpriteNode = SKSpriteNode(imageNamed: "TurnSelectionTriangle")
    let attack3Triangle: SKSpriteNode = SKSpriteNode(imageNamed: "TurnSelectionTriangle")
    let attack1Icon: SKSpriteNode = SKSpriteNode(imageNamed: "Skull Icon")
    let attack2Icon: SKSpriteNode = SKSpriteNode(imageNamed: "ShadeFlyingIcon")
    let attack3Icon: SKSpriteNode = SKSpriteNode(imageNamed: "GlowingSpearIcon")
    
    let emitter = SKEmitterNode(fileNamed: "Darkness.sks")!
    
    func didMoveToScene() {
        
        
        if reversed == true {
            self.xScale = self.xScale * -1
        }
        
        
        
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
        
        upperFrontArmAngleDeg = upperArmFront.zRotation
        lowerFrontArmAngleDeg = lowerArmFront.zRotation
        upperBackArmAngleDeg = upperArmBack.zRotation
        lowerBackArmAngleDeg = lowerArmBack.zRotation

        skull.alpha = 2.0
        let rotationConstraintArm = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(160))
        lowerArmFront.reachConstraints = SKReachConstraints(lowerAngleLimit: CGFloat(-40), upperAngleLimit: CGFloat(160))
        lowerArmBack.reachConstraints = rotationConstraintArm
        
        attack1Triangle.anchorPoint = CGPoint(x: 0.5, y: 0)
        attack2Triangle.anchorPoint = attack1Triangle.anchorPoint
        attack3Triangle.anchorPoint = attack1Triangle.anchorPoint
        attack1Triangle.size = CGSize(width: 300, height: 300)
        attack2Triangle.size = attack1Triangle.size
        attack3Triangle.size = attack1Triangle.size
        attack1Triangle.zRotation = π/3
        attack3Triangle.zRotation = -π/3
        attack1Triangle.move(toParent: self.lowerTorso)
        attack2Triangle.move(toParent: self.lowerTorso)
        attack3Triangle.move(toParent: self.lowerTorso)
        attack1Triangle.position = CGPoint(x: 0, y: 70)
        attack2Triangle.position = attack1Triangle.position
        attack3Triangle.position = attack1Triangle.position
        attack1Triangle.alpha = 0
        attack2Triangle.alpha = attack1Triangle.alpha
        attack3Triangle.alpha = attack1Triangle.alpha
        
        attack1Icon.size = CGSize(width: 100, height: 100)
        attack2Icon.size = CGSize(width: 100, height: 100)
        attack3Icon.size = CGSize(width: 100, height: 100)
        attack1Icon.setScale(0)
        attack2Icon.setScale(0)
        attack3Icon.setScale(0)
        attack1Icon.move(toParent: self.lowerTorso)
        attack2Icon.move(toParent: self.lowerTorso)
        attack3Icon.move(toParent: self.lowerTorso)
        attack1Icon.alpha = 0
        attack2Icon.alpha = 0
        attack3Icon.alpha = 0
        attack1Icon.position = CGPoint(x: -150, y: 150)
        attack2Icon.position = CGPoint(x: 0, y: 275)
        attack3Icon.position = CGPoint(x: 150, y: 150)
        
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
    }
    
    func attack(positions: [CGPoint]) -> SKAction {
        var positionsList = positions
        var numberOfPositions = positions.count
        var attackPositions: [CGPoint] = [CGPoint]()
        var move: SKAction!
        
        if attack1 == true {
            let positionToAttack = Int(arc4random_uniform(UInt32(numberOfPositions)))
            move = punchAt(positionsList.remove(at: positionToAttack))
        }
        
        if attack2 == true {
            for _ in 0...2 {
                let positionToAttack = Int(arc4random_uniform(UInt32(numberOfPositions)))
                attackPositions.append(positionsList.remove(at: positionToAttack))
                numberOfPositions -= 1
            }
            move = attack3(position1: attackPositions[0], position2: attackPositions[1], position3: attackPositions[2])
        }
        
        if attack3 == true {
            let positionToAttack = Int(arc4random_uniform(UInt32(numberOfPositions)))
            move = jump(position: positionsList.remove(at: positionToAttack))
        }
        
        return move
    }
    
    //MARK: Regulatory Functions
    
    func restore() -> SKAction {
        let restore = SKAction.run {
            let duration = 0.5
            self.lowerTorso.run(SKAction.move(to: CGPoint.zero, duration: duration))
            self.lowerTorso.run(SKAction.rotate(toAngle: 0, duration: duration, shortestUnitArc: true))
            self.run(SKAction.fadeAlpha(to: 0.4, duration: duration))
            self.legs.run(SKAction.rotate(toAngle: 0, duration: duration, shortestUnitArc: true))
            self.upperTorso.run(SKAction.rotate(toAngle: 0, duration: 0.3, shortestUnitArc: true))
            self.upperArmFront.run(SKAction.rotate(toAngle: self.upperFrontArmAngleDeg, duration: duration, shortestUnitArc: true))
            self.upperArmBack.run(SKAction.rotate(toAngle: self.upperBackArmAngleDeg, duration: duration, shortestUnitArc: true))
            self.lowerArmBack.run(SKAction.rotate(toAngle: self.lowerBackArmAngleDeg, duration: duration, shortestUnitArc: true))
            self.lowerArmFront.run(SKAction.rotate(toAngle: self.lowerFrontArmAngleDeg, duration: duration, shortestUnitArc: true))
            self.head.run(SKAction.rotate(toAngle: 0, duration: duration, shortestUnitArc: true))
        }
        return restore
    }
    
    //MARK: Touch Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        var touch = touches.first as! UITouch
        characterTouched = true
        print("hello")
        
        
        let fadeIn = SKAction.fadeAlpha(to: 3.4, duration: 0.2)
        let scale = SKAction.scale(to: 1.0, duration: 0.2)
        
        let showMoves = SKAction.run {
            self.attack1Icon.run(scale)
            self.attack2Icon.run(scale)
            self.attack3Icon.run(scale)
            self.attack1Icon.run(fadeIn)
            self.attack2Icon.run(fadeIn)
            self.attack3Icon.run(fadeIn)
        }
        
        run(showMoves)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as! UITouch
        let lastTranslation = touch.location(in: self) - touch.previousLocation(in: self)
        
        lastSwipe.append(lastTranslation)
        
        if lastSwipe.count > 5 {
            lastSwipe.removeFirst()
        }
        
        var swipe = CGPoint.zero
        for index in lastSwipe {
            swipe += index
        }
        
        if  swipe.angle < π/3 && swipe.angle > -π/2 {
            attack1 = false
            attack2 = false
            attack3 = true
        }
        if  swipe.angle < 2*π/3 && swipe.angle > π/3 {
            attack1 = false
            attack2 = true
            attack3 = false
        }
        if  swipe.angle < 3*π/2 && swipe.angle > 2*π/3 {
            attack1 = true
            attack2 = false
            attack3 = false
        }
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
        
        if attack1 == true {
            attack1Triangle.run(SKAction.unhide())
            attack1Triangle.run(fadeIn)
            attack2Triangle.run(SKAction.hide())
            attack3Triangle.run(SKAction.hide())
        }
        
        if attack2 == true {
            attack2Triangle.run(SKAction.unhide())
            attack1Triangle.run(SKAction.hide())
            attack2Triangle.run(fadeIn)
            attack3Triangle.run(SKAction.hide())
        }
        
        if attack3 == true {
            attack3Triangle.run(SKAction.unhide())
            attack1Triangle.run(SKAction.hide())
            attack2Triangle.run(SKAction.hide())
            attack3Triangle.run(fadeIn)
        }
        
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("hola")
        characterTouched = false
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let scale = SKAction.scale(to: 0, duration: 0.2)
        
        let hideMoves = SKAction.run {
            self.attack1Icon.run(scale)
            self.attack2Icon.run(scale)
            self.attack3Icon.run(scale)
            self.attack1Icon.run(fadeOut)
            self.attack2Icon.run(fadeOut)
            self.attack3Icon.run(fadeOut)
            self.attack1Triangle.run(fadeOut)
            self.attack2Triangle.run(fadeOut)
            self.attack3Triangle.run(fadeOut)
        }
        
        run(hideMoves)
    }
    
    
    //MARK: Third Move
    
    func fadeOut() -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let action = SKAction.run {
            self.run(fadeOut)
        }
        let waitTime = fadeOut.duration
        let waitForCompletion = SKAction.wait(forDuration: waitTime)
        let group = SKAction.group([action,
                                    waitForCompletion])
        return group
    }
    
    func move1() -> SKAction {
        
        let aura = SKScene(fileNamed: "DarkAura") as! SKNode
        let frontFistMagic = SKScene(fileNamed: "Bubblies3") as! SKNode
        let backFistMagic = frontFistMagic.copy() as! SKNode
        
        if let i = shadow.parent?.convert(shadow.position, to: self.scene!) {
            aura.position = i
        }
        
        let fadeEyes = SKAction.fadeAlpha(by: 2.0, duration: 1.0)
        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        let fadeOut = SKAction.fadeOut(withDuration: 1.5)
        
        let action = SKAction.run {
            aura.move(toParent: self.scene!)
            frontFistMagic.move(toParent: self.fistFront)
            backFistMagic.move(toParent: self.fistBack)
            backFistMagic.position = CGPoint(x:-18,y:0)
            frontFistMagic.position = CGPoint(x:-18,y:0)
            backFistMagic.zRotation = π / 2
            frontFistMagic.zRotation = π / 2
            aura.run(fadeIn)
            frontFistMagic.run(fadeIn)
            backFistMagic.run(fadeIn)
            self.skull.run(fadeOut)
            self.eyes.run(fadeEyes)
        }
        let removeParticles = SKAction.run {
            aura.run(SKAction.removeFromParent())
            frontFistMagic.run(SKAction.removeFromParent())
            backFistMagic.run(SKAction.removeFromParent())
        }
        let wait = SKAction.wait(forDuration: 0.1)
        let waitTime = fadeIn.duration
        let waitForCompletion = SKAction.wait(forDuration: waitTime)
        let sequence = SKAction.sequence([action,
                                    waitForCompletion,
                                    move2(),
                                    dive(),
                                    removeParticles,
                                    wait])
        return sequence
    }
    
    func move2() -> SKAction {
        let backArmPositionInScene =  upperArmBack.parent?.convert(upperArmBack.position, to: self.scene!)
        let frontArmPositionInScene =  upperArmFront.parent?.convert(upperArmFront.position, to: self.scene!)
        let reachBackArm = SKAction.reach(to: backArmPositionInScene! + CGPoint(x: 200, y: 200), rootNode: upperArmBack, duration: 0.8)
        let reachFrontArm = SKAction.reach(to: frontArmPositionInScene! + CGPoint(x: -200, y: 200), rootNode: upperArmFront, duration: 0.8)
        let moveUp = SKAction.move(by: CGVector(dx: 0 , dy: 30), duration: 0.8)
        let action = SKAction.run {
            self.fistBack.run(reachBackArm)
            self.fistFront.run(reachFrontArm)
            self.lowerTorso.run(moveUp)
        }
        let waitTime = reachBackArm.duration
        let waitForCompletion = SKAction.wait(forDuration: waitTime)
        let group = SKAction.group([action,
                                    waitForCompletion])
        return group
    }
    
    func dive() -> SKAction {
        let dive = SKAction.move(by: CGVector(dx: 0 , dy: -500), duration: 0.4)
        let fadeEyes = SKAction.fadeAlpha(by: -2.0, duration: 1.0)
        let action = SKAction.run {
            self.lowerTorso.run(dive)
            self.eyes.run(fadeEyes)
        }
        let waitTime = dive.duration
        let waitForCompletion = SKAction.wait(forDuration: waitTime)
        let group = SKAction.group([action,
                                    fadeOut(),
                                    waitForCompletion])
        return group
    }
    
    func flyUp(position1: CGPoint, position2: CGPoint, position3: CGPoint) -> SKAction {
        
        let frontFistMagic = SKScene(fileNamed: "Bubblies3") as! SKNode
        let backFistMagic = frontFistMagic.copy() as! SKNode
        
        let selfCopy1 = self.copy() as! Shade
        selfCopy1.didMoveToScene()
        selfCopy1.upperArmFront.zRotation = CGFloat(GLKMathDegreesToRadians(-38.757))
        selfCopy1.lowerArmFront.zRotation = CGFloat(GLKMathDegreesToRadians(-54.605))
        selfCopy1.upperArmBack.zRotation = CGFloat(GLKMathDegreesToRadians(40.556))
        selfCopy1.lowerArmBack.zRotation = CGFloat(GLKMathDegreesToRadians(55.678))
        selfCopy1.head.zRotation = CGFloat(GLKMathDegreesToRadians(15.112))
        selfCopy1.skull.removeFromParent()
        
        frontFistMagic.move(toParent: selfCopy1.fistFront)
        backFistMagic.move(toParent: selfCopy1.fistBack)
        backFistMagic.position = CGPoint(x:-18 , y:0)
        frontFistMagic.position = CGPoint(x:-18 , y:0)
        backFistMagic.zRotation = π / 2
        frontFistMagic.zRotation = π / 2
        
        let selfCopy2 = selfCopy1.copy() as! Shade
        let selfCopy3 = selfCopy1.copy() as! Shade
        
        let fly = SKAction.move(by: CGVector(dx: 0, dy: 1600), duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        
        let action = SKAction.run {
            selfCopy1.move(toParent: self.scene!)
            selfCopy2.move(toParent: self.scene!)
            selfCopy3.move(toParent: self.scene!)
            selfCopy1.position = position1 - CGPoint(x:0,y:500)
            selfCopy2.position = position2 - CGPoint(x:0,y:500)
            selfCopy3.position = position3 - CGPoint(x:0,y:500)
            selfCopy1.run(fly)
            selfCopy2.run(fly)
            selfCopy3.run(fly)
            selfCopy1.run(fadeOut)
            selfCopy2.run(fadeOut)
            selfCopy3.run(fadeOut)
        }
        let waitTime = fly.duration
        let waitForCompletion = SKAction.wait(forDuration: waitTime)
        let removeShades = SKAction.run {
            selfCopy1.removeFromParent()
            selfCopy2.removeFromParent()
            selfCopy3.removeFromParent()
        }
        let sequence = SKAction.sequence([action,
                                    waitForCompletion,
                                    removeShades])
        return sequence
    }
    
    func attack3(position1: CGPoint, position2: CGPoint, position3: CGPoint) -> SKAction {
        let wait2 = SKAction.wait(forDuration: 0.2)
        let fly = flyUp(position1: position1, position2: position2, position3: position3)
        let restoreSkull = SKAction.run {
            self.skull.run(SKAction.fadeAlpha(to: 2.0, duration: 0.5))
        }
        let sequence = SKAction.sequence([move1(), wait2, fly, restoreSkull, restore()])
        return sequence
    }
    
    //MARK: Jump Move
    
    func jump(/*jumpPoint: CGPoint,*/ position: CGPoint) -> SKAction {
        let waitForCompletion = SKAction.wait(forDuration: 3.8)
        let wait1 = SKAction.wait(forDuration: 0.5)
        let wait2 = SKAction.wait(forDuration: 0.45)
        let wait3 = SKAction.wait(forDuration: 0.2)
        let spear = SKSpriteNode(imageNamed: "GlowingSpear") as! SKNode
        spear.setScale(0)
        
        fistBack.addChild(spear)
        
        let jumpBack = SKAction.run {
            
            let path = CGMutablePath()
            let start = CGPoint(x:0,y:0)
            var end = self.lowerTorso.position * -1
            let cp1 = CGPoint(x: end.x/2, y: 0 - end.x/3)
            path.move(to: start)
            path.addQuadCurve(to: end, control: cp1)
            let follow = SKAction.follow(path, asOffset: true, orientToPath: false, duration: 1.0)
            self.lowerTorso.run(follow)
            //self.lowerTorso.run(SKAction.move(by: CGVector(dx:74.356, dy:-62.095), duration: 0.3))
            //self.legs.run(SKAction.move(by: CGVector(dx: -17.219 , dy:31.697), duration: 0.3))
            self.restore()
            //self.lowerTorso.run(
        }
        
        let fadeIn = SKAction.fadeAlpha(to: 1.6, duration: 0.3)
        let spearScale = SKAction.scale(to: 0.5, duration: 0.3)
        let spearFadeIn = SKAction.run {
            spear.run(spearScale)
            spear.run(fadeIn)
        }
        let armThrow = SKAction.run {
            //self.lowerTorso.run(SKAction.move(by: CGVector(dx:-74.356, dy:62.095), duration: 0.3)) {
                //self.lowerTorso.run(SKAction.move(by: CGVector(dx:74.356, dy:-62.095), duration: 0.3))
            //}
            //self.lowerTorso.run(SKAction.rotate(toAngle: -33.794*2*π/360, duration: 0.5))
            //self.upperTorso.run(SKAction.rotate(toAngle: 0*2*π/360, duration: 0.3))
            //self.legs.run(SKAction.rotate(toAngle: 24.656*2*π/360, duration: 0.3))
            //self.legs.run(SKAction.move(by: CGVector(dx: 17.219 , dy:-31.697), duration: 0.3)) {
                //self.legs.run(SKAction.move(by: CGVector(dx: -17.219 , dy:31.697), duration: 0.3))
            //}
            self.upperArmBack.run(SKAction.rotate(toAngle: -74.153*2*π/360, duration: 0.3))
            self.lowerArmBack.run(SKAction.rotate(toAngle: 0*2*π/360, duration: 0.3))
            //self.upperArmFront.run(SKAction.rotate(toAngle: 41.719*2*π/360, duration: 0.5))
            //self.lowerArmFront.run(SKAction.rotate(toAngle: 71.764*2*π/360, duration: 0.5))
        }
        let spearThrow = SKAction.run {
            let path = CGMutablePath()
            let convertedPosition = spear.parent!.convert(spear.position,
                                                         to: self.scene!)
            spear.move(toParent: self.scene!)
            path.move(to: CGPoint(x:0,y:0))
            path.addLine(to: position - spear.position)
            let follow = SKAction.follow(path, duration: 0.3)
            spear.run(follow) {
                spear.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
            }
        }
        let moveLegs = SKAction.run {
            self.legs.run(SKAction.move(to: CGPoint(x: -2.939, y: -32.266), duration: 0.5))
            self.legs.run(SKAction.rotate(toAngle: -17.361*2*π/360, duration: 0.5))
        }
        let crouch = SKAction.run {
            self.lowerTorso.run(SKAction.move(to: CGPoint(x:100, y:-20), duration: 0.5))
            self.lowerTorso.run(SKAction.rotate(toAngle: -33.794*2*π/360, duration: 0.5))
            self.upperTorso.run(SKAction.rotate(toAngle: 23.986*2*π/360, duration: 0.5))
            self.run(moveLegs)
            self.upperArmBack.run(SKAction.rotate(toAngle: -105.17*2*π/360, duration: 0.5))
            self.lowerArmBack.run(SKAction.rotate(toAngle: 72.054*2*π/360, duration: 0.5))
            self.upperArmFront.run(SKAction.rotate(toAngle: 41.719*2*π/360, duration: 0.5))
            self.lowerArmFront.run(SKAction.rotate(toAngle: 71.764*2*π/360, duration: 0.5))
        }
        let jump = SKAction.run {
            //let positionInScene = self.scene?.convert(jumpPoint,
                                                     //to: self.lowerTorso.parent!)
            //self.lowerTorso.run(SKAction.move(to: positionInScene!, duration: 0.3))
            //self.lowerTorso.run(SKAction.rotate(toAngle: -33.794*2*π/360, duration: 0.3))
            //self.upperTorso.run(SKAction.rotate(toAngle: 23.986*2*π/360, duration: 0.3))
            //self.run(moveLegs)
            self.upperArmBack.run(SKAction.rotate(toAngle: 29.05*2*π/360, duration: 0.3))
            self.lowerArmBack.run(SKAction.rotate(toAngle: 58.928*2*π/360, duration: 0.3))
            //self.upperArmFront.run(SKAction.rotate(toAngle: 41.719*2*π/360, duration: 0.3))
            //self.lowerArmFront.run(SKAction.rotate(toAngle: 71.764*2*π/360, duration: 0.3))
        }
        let sequence = SKAction.sequence([spearFadeIn, jump, wait2, spearThrow, armThrow])
        return SKAction.group([waitForCompletion, sequence])
    }
    
    //MARK: Skull Move
    
    func punchAt(upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode, lowerArmDegrees: CGFloat, upperArmDegrees: CGFloat, amountToReach: CGPoint) -> SKAction {
        let positionInScene = fistNode.parent?.convert(fistNode.position,
                                                       to: self.scene!)
        let punch = SKAction.reach(to: positionInScene! + amountToReach, rootNode: upperArmNode, duration: 0.3)
        let wait = SKAction.wait(forDuration: 2.9)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: upperArmDegrees, duration: 0.3))
            lowerArmNode.run(SKAction.rotate(toAngle: lowerArmDegrees, duration: 0.3))
        }
        return SKAction.run {
            fistNode.run(SKAction.sequence([punch, wait, restore]))
        }
    }
    
    func skullAttack(position: CGPoint) -> SKAction {
        let particleSkull = SKScene(fileNamed: "Skull") as! SKNode
        let shadowRain = SKScene(fileNamed: "Bubblies2") as! SKNode
        particleSkull.position = position
        shadowRain.position = position + CGPoint(x: 0, y: 150)
        shadowRain.xScale = 0.7
        particleSkull.setScale(0)
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let skullScale: SKAction!
        if reversed == false {
            skullScale = SKAction.scale(to: 3.0, duration: 2.0)
        } else {
            skullScale = SKAction.group([SKAction.scaleX(to: -3.0, duration: 2.0),
                                         SKAction.scaleY(to: 3.0, duration: 2.0)])
        }
        let wait = SKAction.wait(forDuration: 1.0)
        let wait2 = SKAction.wait(forDuration: 3.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let goSkull = SKAction.run {
            particleSkull.move(toParent: self.scene!)
            particleSkull.run(SKAction.sequence([skullScale, wait, fadeOut]), completion: particleSkull.removeFromParent)
        }
        let goShadow = SKAction.run {
            shadowRain.move(toParent: self.scene! )
            shadowRain.run(SKAction.sequence([fadeIn, wait2, fadeOut]), completion: shadowRain.removeFromParent)
        }
        let group = SKAction.group([goSkull, goShadow])
        return group
        
    }
    
    func rotateSkull() -> SKAction {
        let rotateTo = SKAction.rotate(toAngle: (-7*π/180), duration: 0.3)
        let wait = SKAction.wait(forDuration: 3.0)
        let restore = SKAction.rotate(toAngle: 37.986*(2*π)/360, duration: 0.3)
        let action = SKAction.run {
            self.skull.run(SKAction.sequence([rotateTo, wait, restore]))
        }
        return action
    }
    
    func punchAt(_ position: CGPoint) -> SKAction {
        let waitForCompletion = SKAction.wait(forDuration: 3.8)
        let group: SKAction!
        if reversed == false {
            group = SKAction.group([waitForCompletion,
                                    punchAt(upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront, lowerArmDegrees: lowerFrontArmAngleDeg, upperArmDegrees: upperFrontArmAngleDeg, amountToReach: CGPoint(x: 80, y: 70)),
                                        punchAt(upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack, lowerArmDegrees: lowerBackArmAngleDeg, upperArmDegrees: upperBackArmAngleDeg, amountToReach: CGPoint(x:15,y:10)),
                                        rotateSkull(),
                                        fadeBody(),
                                        fadeEyes(),
                                        skullAttack(position: position)])
        } else {
            group = SKAction.group([waitForCompletion,
                                    punchAt(upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront, lowerArmDegrees: lowerFrontArmAngleDeg, upperArmDegrees: upperFrontArmAngleDeg, amountToReach: CGPoint(x: -80, y: 70)),
                                        punchAt(upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack, lowerArmDegrees: lowerBackArmAngleDeg, upperArmDegrees: upperBackArmAngleDeg, amountToReach: CGPoint(x:-15,y:10)),
                                        rotateSkull(),
                                        fadeBody(),
                                        fadeEyes(),
                                        skullAttack(position: position)])
        }
        return group
    }
    
    func fadeBody() -> SKAction {
        let fadein = SKAction.fadeAlpha(to: 0.8, duration: 0.5)
        let wait = SKAction.wait(forDuration: 2.8)
        let fadeout = SKAction.fadeAlpha(to: 0.4, duration: 0.5)
        let action = SKAction.run {
            self.run(SKAction.sequence([fadein,wait,fadeout]))
            self.run(SKAction.sequence([fadein,wait,fadeout]))
        }
        return action
    }
    
    func fadeEyes() -> SKAction {
        let fadein = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let wait = SKAction.wait(forDuration: 2.8)
        let fadeout = SKAction.fadeOut(withDuration: 0.5)
        let action = SKAction.run {
            self.eyes.run(SKAction.sequence([fadein,wait,fadeout]))
        }
        return action
    }
    
}
