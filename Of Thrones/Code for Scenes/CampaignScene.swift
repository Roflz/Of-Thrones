//
//  SecondScene.swift
//  ButtonApp
//
//  Created by Riley Mahn on 20/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CampaignScene: SKScene {
    
    let mainButton: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake2")
    let portalButton: SKSpriteNode = SKSpriteNode(imageNamed: "Portal1")
    var portal: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        mainButton.position = CGPoint(x: 700/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        mainButton.setScale(0.3)
        mainButton.name = "Main Button"
        addChild(mainButton)
        
        portal = loadPortal("Portal")
        let initialPortal = portal.copy() as! SKSpriteNode
        initialPortal.position = CGPoint(x: size.width/2, y: size.height/2)
        initialPortal.name = "Portal Button"
        addChild(initialPortal)
        
    }
    
    func loadPortal(_ fileName: String) -> SKSpriteNode {
        let portalScene = SKScene(fileNamed: fileName)!
        let portalTemplate = portalScene.childNode(withName: "Portal")
        return portalTemplate as! SKSpriteNode
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
                    let scene = GameScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    view?.presentScene(scene!, transition: reveal)
                }
                if name == "Portal Button"
                {
                    let scene = Universe1(fileNamed: "Universe1")
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

