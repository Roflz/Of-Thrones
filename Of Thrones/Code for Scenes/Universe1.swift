//
//  Universe1.swift
//  ButtonApp
//
//  Created by Riley Mahn on 21/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Universe1: SKScene {
    
    let world1Button: SKSpriteNode = SKSpriteNode(imageNamed: "back")
    let mainButton: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake2")
    
    override func didMove(to view: SKView) {
        
        world1Button.position = CGPoint(x: 700/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        world1Button.setScale(0.3)
        world1Button.name = "World1 Button"
        addChild(world1Button)
        
        mainButton.position = CGPoint(x: 1000/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        mainButton.setScale(0.3)
        mainButton.name = "Main Button"
        addChild(mainButton)
        
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
                if name == "Main Button"
                {
                    let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
                }
                if name == "World1 Button"
                {
                    let scene = World1(fileNamed: "World1")
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
