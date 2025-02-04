//
//  MyUtils.swift
//  ZombieConga
//
//  Created by Riley Mahn on 13/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

// Arithmetic Functions for CGPoint

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}
func /= ( left: inout CGPoint, right: CGPoint) {
    left = left / right
}
func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
func /= (point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

// 32 Bit setup, accepts CGFloats and Floats instead of just doubles
#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y), Float(x)))
    }
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

// Some Trigonometric Functions
extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func normalized() -> CGPoint {
        return self / length()
    }
    var angle: CGFloat {
        return atan2(y, x)
    }
}

//Finds Shortest angle btwn two angles

let π = CGFloat.pi
func shortestAngleBetween(angle1: CGFloat,
                          angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1)
        .truncatingRemainder(dividingBy: twoπ)
    if angle >= π {
        angle = angle - twoπ
    }
    if angle <= -π {
        angle = angle + twoπ
    }
    return angle
}

//Returns -1, 0, or 1, corresponding to sign of CGFloat
extension CGFloat {
    func sign() -> CGFloat {
        return self >= 0.0 ? 1.0 : -1.0
    }
}

//Random Number generator. 1st func is btwn 0..1, 2nd func is btwn specified min & max.
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}


import AVFoundation
var backgroundMusicPlayer: AVAudioPlayer!
func playBackgroundMusic(filename: String) {
    let resourceUrl = Bundle.main.url(forResource:
        filename, withExtension: nil)
    guard let url = resourceUrl else {
        print("Could not find file: \(filename)")
        return
    }
    do {
        try backgroundMusicPlayer =
            AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch {
        print("Could not create audio player!")
        return
    }
    
}


public extension CGFloat {
    /**
     * Converts an angle in degrees to radians.
     */
    public func degreesToRadians() -> CGFloat {
        return π * self / 180.0
    }
    
    /**
     * Converts an angle in radians to degrees.
     */
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / π
    }
    
    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    /**
     * Ensures that the float value stays between the given values, inclusive.
     */
    public mutating func clamp(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        self = clamped(v1, v2)
        return self
    }
    
    /**
     * Randomly returns either 1.0 or -1.0.
     */
    public static func randomSign() -> CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
}

/**
 * Returns the shortest angle between two angles. The result is always between
 * -π and π.
 */
public func shortestAngleBetween(_ angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}

func makeCurve(startPoint: CGPoint, endPoint: CGPoint, controlX: CGFloat, controlY: CGFloat, smoothness: Int) -> CGPath {
    
    let path = CGMutablePath()
    var x = startPoint.x
    path.move(to: startPoint)
    let line = endPoint-startPoint
    var theta = atan(line.y/line.x)
    if line.y <= 0 && line.x < 0 {
        theta = theta + π
    }
    let controlPoint = CGPoint(x: controlX , y: controlY)
    print(controlPoint)
    for i in 0...smoothness {
        //let 200 = a(50)^2 +b*50
        //let a = controlpoint.y
        //let y = -a*x*(x-(lengthX))
        if i < (smoothness/2) {
            let controlFactor = controlPoint.x - startPoint.x
            let controlEndPoint = CGPoint(x: startPoint.x + (controlPoint.x - startPoint.x)*2, y: startPoint.y + (controlPoint.y - startPoint.y)*2)
            let a = controlPoint.y/((controlPoint.x-startPoint.x)*(controlPoint.x-controlEndPoint.x))
            print(a)
            let y = a*(x-startPoint.x)*(x-controlEndPoint.x)
            let r = sqrt(x*x + y*y)
            print(CGPoint(x:x,y:y))
            let point = CGPoint(x: (r)*cos(theta), y: (r)*sin(theta))
            path.addLine(to: point)
            x += controlFactor / 5
        } else {
            let controlFactor = endPoint.x - controlPoint.x
            let controlStartPoint = CGPoint(x: endPoint.x - (endPoint.x - controlPoint.x)*2, y: endPoint.y - (endPoint.y - controlPoint.y)*2)
            let a = controlPoint.y/((controlPoint.x-controlStartPoint.x)*(controlPoint.x-endPoint.x))
            print(a)
            let y = a*(x-controlStartPoint.x)*(x-endPoint.x)
            let r = sqrt(x*x + y*y)
            print(CGPoint(x:x,y:y))
            let point = CGPoint(x: (r)*cos(theta), y: (r)*sin(theta))
            path.addLine(to: point)
            x += controlFactor / 5
        }
    }
    return path
}


// from https://oleb.net/blog/2016/08/swift-3-strings/
extension String {
    func wrapped(after: Int) -> [String] {
        var i = 0
        let lines = self.characters.split(omittingEmptySubsequences: false) { character in
            switch character {
            case "\n",
                 " " where i >= after:
                i = 0
                return true
            default:
                i += 1
                return false
            }
            }.map(String.init)
        return lines
    }
}

// adapted from https://github.com/benmorrow/Multiline-SpriteKit-Label/blob/master/MultilinedSKLabelNode/SKLabelNode%2BExtensions.swift
extension SKLabelNode {
    
    func multiline(length: Int) -> SKLabelNode? {
        guard let text = text else { return nil }
        
        let substrings = text.wrapped(after: length)
        
        return substrings.enumerated().reduce(SKLabelNode()) {
            let label = SKLabelNode(fontNamed: self.fontName)
            label.text = $1.element
            label.fontColor = self.fontColor
            label.fontSize = self.fontSize
            label.position = self.position
            label.horizontalAlignmentMode = self.horizontalAlignmentMode
            label.verticalAlignmentMode = self.verticalAlignmentMode
            
            let height = self.fontSize
            let y = (height / 2) + CGFloat($1.offset - substrings.count / 2) * height
            label.position = CGPoint(x: self.position.x, y: self.position.y - y)
            $0.addChild(label)
            return $0
        }
    }
}

func splitTextIntoFields(theText: String, firstLabel: SKLabelNode, secondLabel: SKLabelNode, maxInOneLine: Int) {
    
    if (theText == "") {
        
        return
    }
    
    var i:Int = 0
    
    var line1: String = ""
    var line2: String = ""
    
    var useLine2: Bool = false
    
    for letter in theText.characters {
        if (i > maxInOneLine && String(letter) == " ") {
            
            useLine2 = true
        }
        
        if (useLine2 == false) {
            
            line1 = line1 + String(letter)
        } else {
            
            line2 = line2 + String(letter)
        }
        
        i += 1
        
    }
    
    firstLabel.text = line1
    secondLabel.text = line2
}
    
extension SKSpriteNode {
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}
    
    
    
    
    



