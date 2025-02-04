//
//  Territory.swift
//  Of Thrones
//
//  Created by Riley Mahn on 29/12/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import SpriteKit
import UIKit

class Territory: SKSpriteNode, EventListenerNode {
    
    let defaults = UserDefaults.standard
    
    //MARK: Initialized Properties
    var territoryL: SKSpriteNode
    var nextTerritory: Bool
    var locked: Bool
    var resourceSpots: Int
    var resources: [SKSpriteNode]
    var territory: SKNode
    var labelNode: SKNode
    var victoryPrize: [(String,Int)]
    var progress: CGFloat
    var resourceLabelNode: SKSpriteNode
    var mineDescription: SKSpriteNode
    var forestryDescription: SKSpriteNode
    var magicRiftDescription: SKSpriteNode
    var mineIcon: SKSpriteNode
    var forestryIcon: SKSpriteNode
    var magicRiftIcon: SKSpriteNode
    var label: SKLabelNode
    
    
    //MARK: Optional Properties
    let battleButton: SKSpriteNode = SKSpriteNode(imageNamed: "BattleButton")
    var addButton: SKSpriteNode = SKSpriteNode(imageNamed:"addButton")
    var addButtonPushed: SKSpriteNode = SKSpriteNode(imageNamed:"addButtonPushed")
    var followers: Int = 0
    var progressLabel: SKLabelNode!
    var resourcesLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    var labelHidden = true
    var resourcesLabelHidden = true
    var resourceDescriptionHidden = true
    var lastTouchedResource: SKSpriteNode!
    let resourceEmitter = SKScene(fileNamed: "resource.sks") as! SKNode
    
    
    //MARK: Initialization
    init(territory: SKSpriteNode, resourceSpots: Int, victoryPrize: [(String,Int)], resourceLocations: [CGPoint]? = nil) {
        
        let territoryLocked = territory.childNode(withName: "*L") as! SKSpriteNode
        let texture = SKTexture(imageNamed: territory.name!)
        let textureLocked = SKTexture(imageNamed: territoryLocked.name!)
        
        self.label = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        self.mineIcon = SKSpriteNode(imageNamed: "mineIcon")
        self.forestryIcon = SKSpriteNode(imageNamed: "forestryIcon")
        self.magicRiftIcon = SKSpriteNode(imageNamed: "magicalRiftIcon")
        self.resourceLabelNode = SKSpriteNode(imageNamed: "resourceLabel")
        self.mineDescription = SKSpriteNode(imageNamed: "speechBubble")
        self.forestryDescription = SKSpriteNode(imageNamed: "speechBubble")
        self.magicRiftDescription = SKSpriteNode(imageNamed: "speechBubble")
        self.nextTerritory = false
        self.progress = 0
        self.victoryPrize = victoryPrize
        self.labelNode = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: 20, height: 20))
        self.resourceSpots = resourceSpots
        self.resources = []
        self.locked = true
        self.territory = territory
        self.territoryL = SKSpriteNode(texture: textureLocked, color: UIColor.darkGray, size: territory.size)
        
        super.init(texture: texture, color: UIColor.clear, size: territory.size )
        
        
        //set up main label
        label.position = CGPoint(x: self.position.x , y: self.position.y)
        label.fontSize = 80
        label.fontColor = SKColor.black
        
        //set up resource Label
        resourceLabelNode.zPosition = 25
        mineIcon.name = "mineIcon"
        forestryIcon.name = "forestryIcon"
        magicRiftIcon.name = "magicRiftIcon"
        mineIcon.zPosition = resourceLabelNode.zPosition + 5
        forestryIcon.zPosition = resourceLabelNode.zPosition + 5
        magicRiftIcon.zPosition = resourceLabelNode.zPosition + 5
        resourceLabelNode.move(toParent: self)
        mineIcon.move(toParent: resourceLabelNode)
        forestryIcon.move(toParent: resourceLabelNode)
        magicRiftIcon.move(toParent: resourceLabelNode)
        mineIcon.position += CGPoint(x:0,y:-resourceLabelNode.size.height/8)
        forestryIcon.position = mineIcon.position + CGPoint(x:-resourceLabelNode.size.width/3.3,y:0)
        magicRiftIcon.position = mineIcon.position + CGPoint(x:resourceLabelNode.size.width/3.3,y:0)
        
        //set up resource descriptions
        mineDescription.move(toParent: resourceLabelNode)
        forestryDescription.move(toParent: resourceLabelNode)
        magicRiftDescription.move(toParent: resourceLabelNode)
        mineDescription.zPosition = resourceLabelNode.zPosition + 5
        forestryDescription.zPosition = resourceLabelNode.zPosition + 5
        magicRiftDescription.zPosition = resourceLabelNode.zPosition + 5
        mineDescription.setScale(2.5)
        forestryDescription.setScale(2.5)
        magicRiftDescription.setScale(2.5)
        
        let mineDescriptionLabel = label.copy() as! SKLabelNode
        mineDescriptionLabel.fontSize = 50
        mineDescriptionLabel.fontColor = UIColor.darkGray
        mineDescriptionLabel.position += CGPoint(x: -mineDescription.size.width/3, y: mineDescription.size.height/4)
        mineDescriptionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode(rawValue: 1)!
        mineDescriptionLabel.zPosition = mineDescription.zPosition + 5
        
        let mineDescriptionLabel2 = mineDescriptionLabel.copy() as! SKLabelNode
        mineDescriptionLabel2.position -= CGPoint(x: 0, y: mineDescriptionLabel2.fontSize*1.5)
        mineDescriptionLabel2.fontSize = 30
        let mineDescriptionLabel3 = mineDescriptionLabel2.copy() as! SKLabelNode
        mineDescriptionLabel3.position -= CGPoint(x: 0, y: mineDescriptionLabel3.fontSize*2.2)
        let mineDescriptionLabel4 = mineDescriptionLabel3.copy() as! SKLabelNode
        mineDescriptionLabel4.position -= CGPoint(x: 0, y: mineDescriptionLabel4.fontSize*2.2)
        
        mineDescriptionLabel.text = "Mine:"
        mineDescriptionLabel2.text = "Gathers some ores to forge equipment and make items"
        splitTextIntoFields(theText: mineDescriptionLabel2.text!, firstLabel: mineDescriptionLabel2, secondLabel: mineDescriptionLabel3, maxInOneLine: 20)
        //splitTextIntoFields(theText: mineDescriptionLabel3.text!, firstLabel: mineDescriptionLabel3, secondLabel: mineDescriptionLabel4, maxInOneLine: 20)
        
        mineDescriptionLabel.move(toParent: mineDescription)
        mineDescriptionLabel2.move(toParent: mineDescription)
        mineDescriptionLabel3.move(toParent: mineDescription)
        mineDescriptionLabel4.move(toParent: mineDescription)
        
        addButton.setScale(0.2)
        addButton.name = "addButton"
        addButton.zPosition = mineDescription.zPosition + 5
        addButton.position = mineDescriptionLabel3.position - CGPoint(x: 0, y: mineDescriptionLabel3.fontSize*4)
        addButtonPushed.name = "addButtonPushed"
        addButtonPushed.zPosition = addButton.zPosition + 5
        addButtonPushed.position = mineDescriptionLabel3.position - CGPoint(x: 0, y: mineDescriptionLabel3.fontSize*4)
        
        addButton.move(toParent: mineDescription)
        addButtonPushed.move(toParent: addButton)
        addButtonPushed.run(SKAction.hide())
        
        
        forestryDescription.position = forestryIcon.position + CGPoint(x: forestryDescription.size.width/4 + forestryIcon.size.width/2, y: forestryIcon.size.height/2 + forestryDescription.size.height/2)
        magicRiftDescription.position = magicRiftIcon.position + CGPoint(x: magicRiftDescription.size.width/4 + magicRiftIcon.size.width/2, y: magicRiftIcon.size.height/2 + magicRiftDescription.size.height/2)
        
        mineDescription.run(SKAction.hide())
        forestryDescription.run(SKAction.hide())
        magicRiftDescription.run(SKAction.hide())
        resourceLabelNode.run(SKAction.hide())
        resourceLabelNode.setScale(0)
        
        //Set up resource spots
        if let locations = resourceLocations {
            var i = 1
            for location in locations {
                let resourceSpot = SKSpriteNode(imageNamed: "squareTarget")
                resourceSpot.name = "resourceSpot" + String(i)
                resourceSpot.colorBlendFactor = 1.0
                resourceSpot.color = SKColor.gray
                resourceSpot.zPosition = 10
                resourceSpot.setScale(0.5)
                resourceSpot.position = location
                resourceSpot.zPosition = 10
                resourceSpot.move(toParent: self)
                resources.append(resourceSpot)
                i += 1
            }
        }
        
        self.colorBlendFactor = 1.0
        territoryL.colorBlendFactor = 1.0
        territoryL.alpha = 0.8
        self.labelNode.move(toParent: self)
        self.territoryL.move(toParent: self)
        self.position = territory.position
        self.name = territory.name
        if let progress = defaults.object(forKey: self.name! + "progress") {
            self.progress = progress as! CGFloat
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: didMoveToScene()
    func didMoveToScene() {
        
        resourceEmitter.move(toParent: self)
        
        if progress == 1.0 {
            locked = false
        }
        
        territoryL.zPosition = 15
        labelNode.zPosition = 20
        
        
        
        //Any unlocked territory
        if locked == false {
            self.color = UIColor(hue: 0.32, saturation: 0.87, brightness: 0.54, alpha: 1.0)
            territoryL.run(SKAction.hide())
            label.text = "\(self.name!)"
            
            if resources != [] {
                for resource in resources {
                    resource.color = SKColor.cyan
                    //resource.addGlow()
                }
            }
            
            label.move(toParent: labelNode)
            
        }
        
        
        //Any locked territory
        if locked == true && nextTerritory == false {
            
            label.fontColor = SKColor.white
            label.text = "\(self.name!)"
            let secondLabel = label.copy() as! SKLabelNode
            let thirdLabel = label.copy() as! SKLabelNode
            secondLabel.position = label.position - CGPoint(x: 0, y: label.fontSize)
            thirdLabel.position = secondLabel.position - CGPoint(x: 0, y: label.fontSize)
            secondLabel.text = "LOCKED!!"
            thirdLabel.text = "Conquer previous territory"
            label.move(toParent: labelNode)
            secondLabel.move(toParent: labelNode)
            thirdLabel.move(toParent: labelNode)
            
        }
        
        //Next territory
        if nextTerritory == true {
            
            self.color = UIColor.lightGray
            territoryL.run(SKAction.hide())
            
            progressLabel = label.copy() as! SKLabelNode
            resourcesLabel = label.copy() as! SKLabelNode
            victoryLabel = label.copy() as! SKLabelNode
            progressLabel.position = label.position - CGPoint(x: 0, y: label.fontSize)
            resourcesLabel.position = progressLabel.position - CGPoint(x: 0, y: label.fontSize)
            victoryLabel.position = resourcesLabel.position - CGPoint(x: 0, y: label.fontSize)
            label.text = "\(self.name!)"
            progressLabel.text = "Progress: \(Int(progress*100))%"
            resourcesLabel.text = "\(self.resourceSpots) Resource Spot"
            victoryLabel.text = "Upon Completion:"
            
            var i = 1
            for (str,count) in victoryPrize {
                let prize = label.copy() as! SKLabelNode
                prize.fontSize = label.fontSize * 5/7
                prize.text = "+ \(count) \(str)"
                prize.position = victoryLabel.position - CGPoint(x: 0, y: prize.fontSize * CGFloat(i))
                prize.move(toParent: victoryLabel)
                i += 1
            }
            
            battleButton.setScale(2.5)
            battleButton.position = victoryLabel.position - CGPoint(x: 0, y: label.fontSize * 5/7 * CGFloat(i) + battleButton.size.height/2)
            battleButton.zPosition = 10
            battleButton.name = "Battle Button"
            victoryLabel.move(toParent: labelNode)
            resourcesLabel.move(toParent: labelNode)
            progressLabel.move(toParent: labelNode)
            label.move(toParent: labelNode)
            battleButton.move(toParent: labelNode)
        }
        
        labelNode.run(SKAction.hide())
        
        
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            let position = touch.location(in: self)
            let touchedNode = self.atPoint(position)
            if let name = touchedNode.name
            {
                
                if name == "addButton" {
                    addButtonPushed.run(SKAction.unhide())
                }
                
                if name == "mineIcon" {
                    
                }
                
                if name == "forestryIcon" {
                    
                }
                
                if name == "magicRiftIcon" {
                    
                }
                
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        addButtonPushed.run(SKAction.hide())
        
        if let touch = touches.first {
            let position = touch.location(in: self)
            let touchedNode = self.atPoint(position)
            if let name = touchedNode.name
            {
                
                
                if resources != [] {
                    for resource in resources {
                        if name == resource.name {
                            lastTouchedResource = touchedNode as! SKSpriteNode
                            if resourcesLabelHidden == true {
                                resourceLabelNode.setScale(0)
                                resourceLabelNode.alpha = 1.0
                                self.resourceLabelNode.position = touchedNode.position + CGPoint(x:0,
                                                                                                 y:200 + lastTouchedResource.size.height/2)
                                self.resourceLabelNode.run(SKAction.unhide())
                                self.resourceLabelNode.run(SKAction.scale(to: 0.6, duration: 0.3))
                                resourcesLabelHidden = false
                            } else {
                                self.resourceLabelNode.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.3),
                                                                              SKAction.hide()]))
                                resourcesLabelHidden = true
                            }
                        }
                        
                        if name == "addButtonPushed" {
                            let fadeOut = SKAction.group([SKAction.fadeOut(withDuration: 0.2),
                                                          SKAction.scale(by: 1.2, duration: 0.2)])
                            let reset = SKAction.run {
                                self.mineDescription.setScale(0)
                                self.mineDescription.run(SKAction.hide())
                                for child in self.resourceLabelNode.children {
                                    child.removeAllActions()
                                }
                            }
                            self.resourceLabelNode.run(SKAction.sequence([fadeOut,
                                                                          SKAction.hide(),
                                                                          reset]))
                            
                            
                            lastTouchedResource.texture = SKTexture(imageNamed: "mineIcon")
                            
                            let resourceEmitter = SKScene(fileNamed: "resource.sks") as! SKNode
                            resourceEmitter.zPosition = 50
                            
                            let emitterIn = SKAction.run {
                                resourceEmitter.move(toParent: self.lastTouchedResource)
                            }
                            let emitterOut = SKAction.run {
                                resourceEmitter.removeFromParent()
                            }
                            let emitterSequence = SKAction.sequence([emitterIn,
                                                                     SKAction.wait(forDuration: 0.5)])
                            resourcesLabelHidden = true
                            print(resourceEmitter.position)
                            lastTouchedResource.run(emitterSequence)
                        }
                    }
                }
                
                
                if name == "mineIcon" {
                    if resourceDescriptionHidden == true {
                        let scaleUp = SKAction.scale(to: 1.2, duration: 0.3)
                        let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
                        let sequence = SKAction.sequence([scaleUp,scaleDown])
                        let repeatAction = SKAction.repeatForever(sequence)
                        touchedNode.run(repeatAction)
                        mineDescription.setScale(2.5)
                        mineDescription.position = mineIcon.position + CGPoint(x: mineDescription.size.width/4 + mineIcon.size.width/2, y: mineIcon.size.height/2 + mineDescription.size.height/2)
                        mineDescription.setScale(0)
                        mineDescription.run(SKAction.unhide())
                        mineDescription.run(SKAction.scale(to: 2.5, duration: 0.3))
                        resourceDescriptionHidden = false
                    } else {
                        touchedNode.removeAllActions()
                        touchedNode.setScale(1.0)
                        mineDescription.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.3),
                                                                      SKAction.hide()]))
                        resourceDescriptionHidden = true
                    }
                }
                
                if name == "forestryIcon" {
                    
                }
                
                if name == "magicRiftIcon" {
                    
                }
                
                if name == "Battle Button"
                {
                    let scene = BattleScene(fileNamed: "BattleScene")
                    scene?.scaleMode = .aspectFill
                    let reveal = SKTransition.doorway(withDuration: 0.5)
                    self.scene?.view?.presentScene(scene!, transition: reveal)
                    self.progress += 0.25
                    defaults.set(self.progress, forKey: self.name! + "progress")
                }
                
                if name == self.name {
                    if labelHidden == true {
                        labelNode.run(SKAction.unhide())
                        labelHidden = false
                    } else {
                        labelNode.run(SKAction.hide())
                        labelHidden = true
                    }
                }
                
            }
    
        }
    }
    
    func addResource(resourceSpot: SKSpriteNode) {
        
    }
    
}
