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

class BattleScene: SKScene {
    
    let mainButton: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake2")
    let character1 = Character1().sprite
    let character2 = Character2().sprite
    var shade = Shade()
    var shadeTemp: SKSpriteNode!
    //let crotch: SKNode = shade.crotch
    let character4 = Character4().sprite
    let character5 = Character5().sprite
    let character6 = Character6().sprite
    
    override func didMove(to view: SKView) {
        
        mainButton.position = CGPoint(x: 700/*size.width * 1/6*/, y: 900/*size.height / 2*/)
        mainButton.setScale(0.3)
        mainButton.name = "Main Button"
        addChild(mainButton)
        
        shadeTemp = shade.crotch as! SKSpriteNode!
        shadeTemp.move(toParent: self)
        print(shadeTemp.children)
        
        character1.position = CGPoint(x: size.width/6, y: size.height/4)
        character1.setScale(0.6)
        character2.position = CGPoint(x: size.width/6, y: size.height/2)
        shadeTemp.position = CGPoint(x: size.width/6, y: 3*size.height/4)
        print(shade)
        character4.position = CGPoint(x: 5*size.width/6, y: size.height/4)
        character4.setScale(0.6)
        character5.position = CGPoint(x: 5*size.width/6, y: size.height/2)
        character6.position = CGPoint(x: 5*size.width/6, y: 3*size.height/4)
        character6.setScale(0.35)
        addChild(character1)
        addChild(character2)
        //addChild(shadeTemp)
        addChild(character4)
        addChild(character5)
        addChild(character6)
        
        //loadCharacters()
        //setupCharacters()
        
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
                if name == "Main Button"
                {
                    let scene = GameScene(fileNamed: "GameScene")
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
    
    // 1
    func loadForegroundOverlayTemplate(_ fileName: String) ->
        SKSpriteNode {
            let overlayScene = SKScene(fileNamed: fileName)!
            let overlayTemplate =
                overlayScene.childNode(withName: "crotch")
            return overlayTemplate as! SKSpriteNode
    }
    
    
    func punchAt(_ location: CGPoint) {
        // 1
        let punch = SKAction.reach(to: location, rootNode: self.shadeTemp.childNode(withName: "legs")!, duration: 0.1)
        // 2
        shadeTemp.run(punch)
    }
    
    // 3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            print("hi")
            punchAt(location)
        }
    }
    /*
    func loadCharacters() {
        character1 = loadCharacter("Character1")
    }
    
    func setupCharacters() {
        let firstCharacter = character1.copy() as! SKSpriteNode
        addChild(firstCharacter)
    }
    
    func loadCharacter(_ fileName: String) -> SKSpriteNode {
            let character = SKScene(fileNamed: fileName)!
            return character as! SKSpriteNode
    }*/
    
}
