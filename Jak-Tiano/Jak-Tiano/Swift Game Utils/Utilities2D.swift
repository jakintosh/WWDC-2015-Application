//
//  2DUtilities.swift
//
//  Created by Jak Tiano on 10/5/14.
//  Copyright (c) 2014 not a hipster coffee shop. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - Custom Nodes
class NHCNode : SKNode {
    func getScenePosition() -> CGPoint {
        return scene!.childNodeWithName("/CamCon/Zoom_Node/Root_Node")!.convertPoint(position, fromNode: self)
    }
}
class NHCScene : SKScene {
    // time keeping
    var lastTime: NSTimeInterval = 0
    var deltaTime: NSTimeInterval = 0
    
    func updateTime(currentTime: NSTimeInterval) {
        deltaTime = currentTime - lastTime
        Utilities2D.clamp(&deltaTime, min: 0.0, max: 1.0)
        lastTime = currentTime
    }
}
class NHCCamScene: NHCScene {
    var camCon = CameraController()
    
    override init(size: CGSize) {
        super.init(size: size)
        addChild(camCon)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should never be called")
    }
}

// MARK: - Reusable Classes
class GameTimer {
    var timeRemaining: CFTimeInterval
    var timerDuration: CFTimeInterval
    init(time: CFTimeInterval) {
        timerDuration = time
        timeRemaining = time
    }
    func update(dt: CFTimeInterval) -> Bool {
        timeRemaining -= dt
        if timeRemaining < 0.0 {
            timeRemaining = timerDuration
            return true
        }
        return false
    }
}


// MARK: - GUI Stuff
class NHC_GUI {

    class BarMeter : NHCNode {
        
        // properties
        private var width: CGFloat
        private var height: CGFloat
        var color: SKColor = SKColor.greenColor() {
            didSet {
                self.fill.fillColor = self.color
            }
        }
        var labelText: String? {
            didSet {
                if let text = self.labelText {
                    label.text = text
                }
            }
        }
        var percent: Float {
            didSet {
                Utilities2D.clamp(&self.percent, min: 0.0, max: 1.0)
                fill.path = CGPathCreateWithRect(CGRect(x: -self.width/2.0, y: -self.height/2.0, width: self.width * CGFloat(percent), height: self.height), nil)
            }
        }
        
        // components
        let outline: SKShapeNode = SKShapeNode()
        let fill: SKShapeNode = SKShapeNode()
        let label: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue")
        
        
        init(w: CGFloat, h: CGFloat, labelText: String? = nil) {
            self.width = w
            self.height = h
            self.labelText = labelText
            self.percent = 0.0
            
            super.init()
            
            outline.path = CGPathCreateWithRect(CGRect(x: -w/2.0, y: -h/2.0, width: w, height: h), nil)
            outline.strokeColor = SKColor.whiteColor()
            outline.fillColor = SKColor.blackColor()
            outline.lineWidth = 1.0
            addChild(outline)
            
            fill.strokeColor = SKColor.clearColor()
            fill.fillColor = SKColor.greenColor()
            fill.lineWidth = 1.0
            addChild(fill)
            
            label.fontSize = 12
            label.verticalAlignmentMode = .Top
            label.horizontalAlignmentMode = .Center
            if let text = self.labelText { label.text = text } else { label.text = "" }
            label.position = CGPoint(x: 0.0, y: -(self.height/2.0) - 4)
            addChild(label)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) should never be called")
        }
    }
}

// MARK: - 2D Math Utilities
struct Utilities2D {
    
    // MARK: - Numbers
    static func clamp(inout number: Double, min: Double, max: Double) {
        if number > max { number = max }
        else if number < min { number = min }
    }
    static func clamp(inout number: Float, min: Float, max: Float) {
        if number > max { number = max }
        else if number < min { number = min }
    }
    static func clamp(inout number: CGFloat, min: CGFloat, max: CGFloat) {
        if number > max { number = max }
        else if number < min { number = min }
    }
    static func clamp(inout number: Int, min: Int, max: Int) {
        if number > max { number = max }
        else if number < min { number = min }
    }
    static func lerpFrom(n1: CGFloat, toNum n2: CGFloat, atPosition val: CGFloat) -> CGFloat {
        return ( n1 + ( ( n2 - n1 ) * val) )
    }
    
    // MARK: - Points
    static func lerpFromPoint(p1: CGPoint, toPoint p2: CGPoint, atPosition val: CGFloat) -> CGPoint {
        return CGPointMake( p1.x + ((p2.x - p1.x) * val), p1.y + ((p2.y - p1.y) * val) );
    }
    static func addPoint( p1: CGPoint, toPoint p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x + p2.x, p1.y + p2.y);
    }
    static func subPoint( p1: CGPoint, fromPoint p2: CGPoint) -> CGPoint {
        return CGPointMake(p2.x - p1.x, p2.y - p1.y);
    }
    static func multiplyPoint( p1: CGPoint, byPoint p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x * p2.x, p1.y * p2.y);
    }
    static func dividePoint( p1: CGPoint, byPoint p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x / p2.x, p1.y / p2.y);
    }
    static func multiplyPoint( p: CGPoint, byNumber n: CGFloat) -> CGPoint {
        return CGPointMake(p.x * n, p.y * n);
    }
    static func dividePoint( p: CGPoint, byNumber n: CGFloat) -> CGPoint {
        return CGPointMake(p.x / n, p.y / n);
    }
    static func distanceSquaredFromPoint(p1: CGPoint, toPoint p2: CGPoint) -> CGFloat {
        return ((p2.x - p1.x) * (p2.x - p1.x)) + ((p2.y - p1.y) * (p2.y - p1.y))
    }
    static func distanceFromPoint(p1: CGPoint, toPoint p2: CGPoint) -> CGFloat {
        return sqrt(distanceSquaredFromPoint(p1, toPoint: p2))
    }
    static func logPoint(point: CGPoint) {
        println("{\(point.x), \(point.y)}")
    }
}