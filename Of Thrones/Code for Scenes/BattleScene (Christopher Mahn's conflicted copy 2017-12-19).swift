//
//  BattleScene.swift
//  ButtonApp
//
//  Created by Riley Mahn on 21/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol attackNode {
    func attack(positions: [CGPoint]) -> SKAction
}

class BattleScene: SKScene {
    
    let backArrow: SKSpriteNode = SKSpriteNode(imageNamed: "BackArrow")
    let goButton: SKSpriteNode = SKSpriteNode(imageNamed: "GoButton")
    
    var character1: SKNode!
    var character2: Shade!
    var character3: Shade!
    var character4: Shade!
    var character5: Shade!
    var character6: Shade!
    var character7: Shade!
    var character8: Shade!
    var character9: Shade!
    var character10: Shade!
    var character11: Shade!
    var character12: Shade!
    
    var position1: CGPoint!
    var position2: CGPoint!
    var position3: CGPoint!
    var position4: CGPoint!
    var position5: CGPoint!
    var position6: CGPoint!
    var position7: CGPoint!
    var position8: CGPoint!
    var position9: CGPoint!
    var position10: CGPoint!
    var position11: CGPoint!
    var position12: CGPoint!
    
    var midHighPoint: CGPoint!
    
    override func didMove(to view: SKView) {
        
        //initialize positions
        position1 = CGPoint(x: size.width/6, y: 2*size.height/3)
        position2 = CGPoint(x: size.width/6, y: size.height/2)
        position3 = CGPoint(x: size.width/6, y: size.height/3)
        position4 = CGPoint(x: size.width/3, y: 2*size.height/3)
        position5 = CGPoint(x: size.width/3, y: size.height/2)
        position6 = CGPoint(x: size.width/3, y: size.height/3)
        position7 = CGPoint(x: 2*size.width/3, y: 2*size.height/3)
        position8 = CGPoint(x: 2*size.width/3, y: size.height/2)
        position9 = CGPoint(x: 2*size.width/3, y: size.height/3)
        position10 = CGPoint(x: 5*size.width/6, y: 2*size.height/3)
        position11 = CGPoint(x: 5*size.width/6, y: size.height/2)
        position12 = CGPoint(x: 5*size.width/6, y: size.height/3)
        
        //initialize important points
        midHighPoint = CGPoint(x: size.width/2, y: 2*size.height/3)
        
        //initialize buttons
        backArrow.anchorPoint = CGPoint(x: 0, y: 1.0)
        backArrow.position = CGPoint(x: 0, y: 1344)
        backArrow.setScale(0.5)
        backArrow.name = "Back Arrow"
        addChild(backArrow)
        
        goButton.position = CGPoint(x: size.width * 1/2, y: size.height / 2)
        goButton.setScale(1.0)
        goButton.name = "Go Button"
        addChild(goButton)
        
        
        //initialize characters
        character1 = loadSprite("Shade", name: "character1", position: position1, scale: 0.9)
        character2 = loadSprite("Shade", name: "character2", position: position2, scale: 0.9) as! Shade
        character3 = loadSprite("Shade", name: "character3", position: position3, scale: 0.9) as! Shade
        character4 = loadSprite("Shade", name: "character4", position: position4, scale: 0.9) as! Shade
        character5 = loadSprite("Shade", name: "character5", position: position5, scale: 0.9) as! Shade
        character6 = loadSprite("Shade", name: "character6", position: position6, scale: 0.9) as! Shade
        
        character7 = loadSprite("Shade", name: "character7", position: position7, scale: 0.9) as! Shade
        character8 = loadSprite("Shade", name: "character8", position: position8, scale: 0.9) as! Shade
        character9 = loadSprite("Shade", name: "character9", position: position9, scale: 0.9) as! Shade
        character10 = loadSprite("Shade", name: "character10", position: position10, scale: 0.9) as! Shade
        character11 = loadSprite("Shade", name: "character11", position: position11, scale: 0.9) as! Shade
        character12 = loadSprite("Shade", name: "character12", position: position12, scale: 0.9) as! Shade
        
        character7.reversed = true
        character8.reversed = true
        character9.reversed = true
        character10.reversed = true
        character11.reversed = true
        character12.reversed = true
        
        //initialize listener nodes
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
    }
    
    
    func loadSprite(_ fileName: String, name: String, position: CGPoint, scale: CGFloat) -> Shade {
        let characterScene = SKScene(fileNamed: fileName)!
        let characterTemplate = characterScene.childNode(withName: "Overlay")
        characterTemplate?.move(toParent: self)
        characterTemplate?.position = position
        characterTemplate?.setScale(scale)
        characterTemplate?.name = name
        return characterTemplate as! Shade
    }
    
    func setupCharacter(_ character: String, position: CGPoint, scale: CGFloat) {
        enumerateChildNodes(withName: "Overlay", using: { node, _ in
            node.move(toParent: self)
            node.position = position
            node.setScale(scale)
        })
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
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
                if name == "Back Arrow"
                {
                    let scene = World1(fileNamed: "World1")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
                }
                if name == "Go Button"
                {
                    //character5.punchAt(position8)
                    
                    var nodesAndActions: [(SKNode,SKAction)] = [(SKNode,SKAction)]()
                    
                    enumerateChildNodes(withName: "//character*") { node, _ in
                        if let attackNode = node as? attackNode {
                            let attack = attackNode.attack(positions: [self.position7, self.position8, self.position9, self.position10, self.position11, self.position12])
                            nodesAndActions.append((node, attack))
                        }
                    }
                    runInSequence(actions: nodesAndActions, index: 0)
                    nodesAndActions.removeAll()
                }
                    
                
            }
        }
    }
    
    func runInSequence(actions: [(node: SKNode ,action: SKAction)], index: Int) {
        if index < actions.count {
            let node = actions[index].node
            let action = actions[index].action
            node.run(action) {
                // Avoid retain cycle
                [weak self] in
                self?.runInSequence(actions: actions, index: index+1)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
        }
    }
    
}
