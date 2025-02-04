//
//  CharacterScene.swift
//  ButtonApp
//
//  Created by Riley Mahn on 9/12/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

class CharacterScene: SKScene {
    
    var shadeNode: Shade!
    
    override func didMove(to view: SKView) {
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        shadeNode = childNode(withName: "//Overlay") as! Shade
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
        }
    }
}
