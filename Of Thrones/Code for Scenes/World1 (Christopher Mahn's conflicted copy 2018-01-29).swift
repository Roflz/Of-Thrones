//
//  World1.swift
//  ButtonApp
//
//  Created by Riley Mahn on 21/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol TerritoryNode {
    func didMoveToScene(territoryName: String)
}

class World1: SKScene {
    
    //var saveData = SaveData()
    
    
    let defaults = UserDefaults.standard
    
    
    let resetButton: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake2")
    //let characterButton: SKSpriteNode = SKSpriteNode(imageNamed: "head")
    
    let cameraNode = SKCameraNode()
    var lastUpdateTimeInterval: TimeInterval = 0
    var dt: TimeInterval = 0
    let stopsCamera: CGFloat = 300.0 // This is employed to stop camera movement when it is close to zero
    var averagePanVelocity = CGPoint.zero
    let cameraSpeedScalar: CGFloat = 2.0 // Increase to increase camera speed
    var lastPanTranslation: [CGPoint] = []
    var touched = false
    
    let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    
    var territory1: Territory!
    var territory2: Territory!
    var territory3: Territory!
    var territory4: Territory!
    
    var territories: [String:Bool]!
    
    let resourceSpotScene = SKScene(fileNamed: "ResourceSpot")
    var resourceSpotNode: SKNode!
    
    override func didMove(to view: SKView) {
        
        background.size = CGSize(width: 4096, height: 3072)
        background.zPosition = -1
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(myPanAction))
        myPanGestureRecognizer.minimumNumberOfTouches = 1
        myPanGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(myPanGestureRecognizer)
        
        let myPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(myPinchAction))
        view.addGestureRecognizer(myPinchGestureRecognizer)
        
        
        
        territory1 = Territory(territory: childNode(withName: "territory1")! as! SKSpriteNode, resourceSpots: 1, victoryPrize: [("Followers",50),("Gold",5000)], resourceLocations: [CGPoint(x:200,y:250), CGPoint(x:-45, y: -250)])
        territory2 = Territory( territory: childNode(withName: "territory2")! as! SKSpriteNode, resourceSpots: 0, victoryPrize: [("Followers",100),("Gold",6000)], resourceLocations: [CGPoint(x:100, y: -15)])
        territory3 = Territory(territory: childNode(withName: "territory3")! as! SKSpriteNode, resourceSpots: 2, victoryPrize: [("Followers",70),("Gold",8000)], resourceLocations: [CGPoint(x: 250, y: 40)])
        territory4 = Territory(territory: childNode(withName: "territory4") as! SKSpriteNode, resourceSpots: 1, victoryPrize: [("Followers",120),("Gold",10000)])
        
        
        
        if let name = defaults.object(forKey: "territory1progress") {
            let progress = name as! CGFloat
            if progress < 1.0 {
                territory1.locked = true
            } else {
                territory1.locked = false
            }
        }
        if let name = defaults.object(forKey: "territory2progress") {
            let progress = name as! CGFloat
            if progress < 1.0 {
                territory2.locked = true
            } else {
                territory2.locked = false
            }
        }
        if let name = defaults.object(forKey: "territory3progress") {
            let progress = name as! CGFloat
            if progress < 1.0 {
                territory3.locked = true
            } else {
                territory3.locked = false
            }
        }
        if let name = defaults.object(forKey: "territory4progress") {
            let progress = name as! CGFloat
            if progress < 1.0 {
                territory4.locked = true
            } else {
                territory4.locked = false
            }
        }
        
        territory1.move(toParent: self)
        addChild(territory2)
        addChild(territory3)
        addChild(territory4)
        
        
        //let saveData = SaveData(territories: territories)
        
        
        resetButton.anchorPoint = CGPoint(x: 0, y: 1)
        resetButton.position = CGPoint(x: background.position.x - background.size.width/2, y: background.position.y + background.size.height/2)
        resetButton.setScale(1.0)
        resetButton.name = "Reset Button"
        resetButton.zPosition = 100
        addChild(resetButton)
        /*
        characterButton.position = CGPoint(x: 850/*size.width * 1/6*/, y: 400/*size.height / 2*/)
        characterButton.setScale(3.0)
        characterButton.name = "Character Button"
        addChild(characterButton)
        */
 
        
        cameraNode.position = CGPoint(x: 1024 , y: 768)
        cameraNode.setScale(1.5)
        addChild(cameraNode)
        camera = cameraNode
        
        enumerateChildNodes(withName: "territory*", using: { node, stop in
            if let progressNode = node as? Territory {
                if progressNode.progress < 1.0 {
                    progressNode.nextTerritory = true
                    stop.pointee = true
                }
            }
        })
        
        enumerateChildNodes(withName: "territory*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTimeInterval > 0 {
            dt = currentTime - lastUpdateTimeInterval
        } else {
            dt = 0
        }
        lastUpdateTimeInterval = currentTime
        
        
        
        
        // The code below controls the camera velocity after a pan movement is released.
        var currentPanVelocity = CGPoint.zero
        for index in lastPanTranslation {
            currentPanVelocity += index
        }
        
        let upperRightCornerConstraint = cameraNode.position + CGPoint(x: size.width/2*cameraNode.xScale, y: size.height/2*cameraNode.yScale)
        let bottomLeftCornerConstraint = cameraNode.position - CGPoint(x: size.width/2*cameraNode.xScale, y: size.height/2*cameraNode.yScale)
        
        
        averagePanVelocity = currentPanVelocity/5
        averagePanVelocity = CGPoint(x: averagePanVelocity.x * cameraSpeedScalar, y: averagePanVelocity.y * cameraSpeedScalar)
        var newCameraPosition = CGPoint(x: (cameraNode.position.x) - averagePanVelocity.x, y: (cameraNode.position.y) + averagePanVelocity.y)
        let diff = newCameraPosition - cameraNode.position
        if diff.length() >= stopsCamera * CGFloat(dt) {
            if touched == false {
                if upperRightCornerConstraint.y > (background.size.height/2 + size.height/2) {
                    let constraintDiff = upperRightCornerConstraint.y - (background.size.height/2 + size.height/2)
                    newCameraPosition.y -= constraintDiff/7
                }
                if upperRightCornerConstraint.x > (background.size.width/2 + size.width/2) {
                    let constraintDiff = upperRightCornerConstraint.x - (background.size.width/2 + size.width/2)
                    newCameraPosition.x -= constraintDiff/7
                }
                if bottomLeftCornerConstraint.y < -(background.size.height/2 - size.height/2) {
                    let constraintDiff = bottomLeftCornerConstraint.y + (background.size.height/2 - size.height/2)
                    newCameraPosition.y -= constraintDiff/7
                }
                if bottomLeftCornerConstraint.x < -(background.size.width/2 - size.width/2) {
                    let constraintDiff = bottomLeftCornerConstraint.x + (background.size.width/2 - size.width/2)
                    newCameraPosition.x -= constraintDiff/7
                }
                
                cameraNode.position = newCameraPosition
            
            }
        }
        
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        lastPanTranslation.removeAll()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            let position = touch.location(in: self)
            let touchedNode = self.atPoint(position)
            if let name = touchedNode.name
            {
                if name == "Reset Button"
                {
                    defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    defaults.synchronize()
                }
                if name == "Main Button"
                {
                    let scene = GameScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
                }
                if name == "Character Button"
                {
                    let scene = CharacterScene(fileNamed: "CharacterScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func myPinchAction(recognizer: UIPinchGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .began || recognizer.state == .changed {
            cameraNode.xScale -= recognizer.velocity*0.05
            cameraNode.yScale -= recognizer.velocity*0.05
            recognizer.scale = 1.0
        }
        if cameraNode.xScale < 0.6 {
            cameraNode.xScale += recognizer.velocity*0.06
            cameraNode.yScale += recognizer.velocity*0.06
            recognizer.scale = 1.0
        }
    }
    
    
    @objc func myPanAction(recognizer: UIPanGestureRecognizer) {
        touched = false
        
        //upperCornerConstraint.x < background.size.width && upperCornerConstraint.y < background.size.height
        
        
        let translation = recognizer.translation(in: recognizer.view)
        lastPanTranslation.append(translation)
        
        if lastPanTranslation.count > 5 {
            lastPanTranslation.removeFirst()
        }
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: recognizer.view)
    }
    
    
}
