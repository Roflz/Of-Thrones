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

class World1: SKScene {
    
    let battleButton: SKSpriteNode = SKSpriteNode(imageNamed: "owl")
    let mainButton: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake2")
    let characterButton: SKSpriteNode = SKSpriteNode(imageNamed: "head")
    
    override func didMove(to view: SKView) {
        
        battleButton.position = CGPoint(x: 700/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        battleButton.setScale(0.3)
        battleButton.name = "Battle Button"
        addChild(battleButton)
        
        mainButton.position = CGPoint(x: 1000/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        mainButton.setScale(0.3)
        mainButton.name = "Main Button"
        addChild(mainButton)
        
        characterButton.position = CGPoint(x: 850/*size.width * 1/6*/, y: 400/*size.height / 2*/)
        characterButton.setScale(3.0)
        characterButton.name = "Character Button"
        addChild(characterButton)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
                if name == "Battle Button"
                {
                    let scene = BattleScene(fileNamed: "BattleScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
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
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
}
