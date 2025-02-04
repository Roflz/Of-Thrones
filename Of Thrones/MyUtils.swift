//
//  MyUtils.swift
//  ZombieConga
//
//  Created by Riley Mahn on 13/11/2017.
//  Copyright © 2017 Riley Mahn. All rights reserved.
//

import Foundation
import CoreGraphics


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



