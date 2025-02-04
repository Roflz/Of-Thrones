//
//  GameScene.swift
//  ButtonApp
//
//  Created by Riley Mahn on 20/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: Properties
    
    let cameraNode = SKCameraNode()
    var lastUpdateTimeInterval: TimeInterval = 0
    var dt: TimeInterval = 0
    let stopsCamera: CGFloat = 300.0 // This is employed to stop camera movement when it is close to zero
    var averagePanVelocity = CGPoint.zero
    let cameraSpeedScalar: CGFloat = 2.0 // Increase to increase camera speed
    var lastPanTranslation: [CGPoint] = []
    var viewRectangle = SKShapeNode(rectOf: CGSize(width: 2048, height: 1152)) // applies 16:9 aspect ratio for compatability with old iphones
    var playRectangle = SKShapeNode(rectOf: CGSize(width: 5000, height: 5000))
    var touched = false
    
    let button: SKSpriteNode = SKSpriteNode(imageNamed: "snowflake1")
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(myPanAction))
        myPanGestureRecognizer.minimumNumberOfTouches = 1
        myPanGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(myPanGestureRecognizer)
        
        viewRectangle.name = "view rectangle"
        viewRectangle.position = CGPoint(x: 1024, y:768)
        viewRectangle.strokeColor = SKColor.red
        viewRectangle.lineWidth = 10
        addChild(viewRectangle)
        
        playRectangle.name = "play rectangle"
        playRectangle.position = CGPoint(x: 1024, y:768)
        playRectangle.strokeColor = SKColor.white
        playRectangle.lineWidth = 10
        addChild(playRectangle)
        
        
        button.position = CGPoint(x: 1024, y: 768)
        button.setScale(0.3)
        button.name = "button"
        addChild(button)
        
        cameraNode.position = CGPoint(x: 1024 , y: 768)
        cameraNode.setScale(1.0)
        addChild(cameraNode)
        camera = cameraNode
    
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
        
        averagePanVelocity = currentPanVelocity/5
        averagePanVelocity = CGPoint(x: averagePanVelocity.x * cameraSpeedScalar, y: averagePanVelocity.y * cameraSpeedScalar)
        let newCameraPosition = CGPoint(x: (camera?.position.x)! - averagePanVelocity.x, y: (camera?.position.y)! + averagePanVelocity.y)
        let diff = newCameraPosition - (camera?.position)!
        if diff.length() >= stopsCamera * CGFloat(dt) {
            if touched == false {
                camera?.position = newCameraPosition
            }
        }
        viewRectangle.position = (camera?.position)!
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
        
        // This employs the button touch and transitions to a new scene
        if let touch = touches.first {
            let position = touch.location(in: self)
            let touchedNode = self.atPoint(position)
            if let name = touchedNode.name
            {
                if name == "button"
                {
                    if let nextScene = CampaignScene(fileNamed: "CampaignScene")
                    {
                        nextScene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 0.5)
                        view?.presentScene(nextScene, transition: transition)
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // This action moves the camera with respect to a pan finger movement on the device.
    // averagePanVelocity is the average of the last 5 instances of the currentPanVelocity, which is
    // registered once every update cycle.
    @objc func myPanAction(recognizer: UIPanGestureRecognizer) {
        touched = false
        
        let translation = recognizer.translation(in: recognizer.view)
        lastPanTranslation.append(translation)
        
        if lastPanTranslation.count > 5 {
            lastPanTranslation.removeFirst()
        }
        
        var currentPanVelocity = CGPoint.zero
        for index in lastPanTranslation {
            currentPanVelocity += index
        }
        
        averagePanVelocity = currentPanVelocity/5
        averagePanVelocity = CGPoint(x: averagePanVelocity.x * cameraSpeedScalar, y: averagePanVelocity.y * cameraSpeedScalar)
        cameraNode.position = CGPoint(x: cameraNode.position.x - averagePanVelocity.x, y: cameraNode.position.y + averagePanVelocity.y)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: recognizer.view)
    }
    

    
}

