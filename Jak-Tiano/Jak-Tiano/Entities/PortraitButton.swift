//
//  PortraitButton.swift
//  Jak-Tiano
//
//  Created by Jak Tiano on 4/25/15.
//  Copyright (c) 2015 jaktiano. All rights reserved.
//

import Foundation
import SpriteKit

class PortraitButton: Button {
    
    // MARK: - Property Declarations
    let radius: CGFloat
    let progressRadius: CGFloat
    let unlockProgressDrainTime: CGFloat = 10.0
    
    var camCon: CameraController?
    var fillPath: UIBezierPath  = UIBezierPath()
    var unlocked: Bool = false {
        didSet {
            if unlocked {
                unlock()
            }
        }
    }
    var unlockProgress: CGFloat = 0 {
        didSet {
            // variable self-clamps on update
            Utilities2D.clamp(&unlockProgress, min: 0.0, max: 1.0)
            if unlockProgress >= 1.0 {
                unlocked = true
            }
            updateProgressNode();
        }
    }
    var unlockClosure: (() -> Void)?
    
    let playCrunchSoundAction = SKAction.playSoundFileNamed("crunch.wav", waitForCompletion: false)
    var pulseForeverAction: SKAction?
    var explodeAction: SKAction?
    
    
    // MARK: - Node Declarations
    let cropNode: SKCropNode        = SKCropNode()
    let maskNode: SKShapeNode       = SKShapeNode()
    let contentNode: SKNode         = SKNode()
    let progressNode: SKNode        = SKNode()
    let progressMeter: SKShapeNode  = SKShapeNode()
    
    // MARK: - Initializers
    init (radius: CGFloat) {
        
        // set internal properties
        self.radius = radius
        self.progressRadius = radius * 1.075 // buffer
        
        super.init()
        
        // set up pulse action
        createPulseAction()
        createExplodeAction()
        
        // set up nodes
        createMaskNode()
        createContentNode()
        createProgressNode()
        
        // set up node hierarchy
        cropNode.addChild(contentNode)
        cropNode.maskNode = maskNode
        addChild(cropNode)
        addChild(progressNode)
    }

    required init? (coder aDecoder: NSCoder) {
        fatalError("shouldn't use init with coder")
    }
    
    // MARK: - Superclass overrides
    
    override func completionAction () {
        if !unlocked {
            // increase progress
            unlockProgress += 0.125
            
            // play sound
            runAction(playCrunchSoundAction)
            
            // shake screen
            if let cam = camCon {
                cam.shake(5, duration: 0.25)
            }
        }
    }
    
    // MARK: - Function
    
    func createMaskNode () {
        // guys really, SKShapeNode is garbage
        maskNode.path = CGPathCreateWithEllipseInRect(CGRect(x: -radius/2, y: -radius/2, width: radius, height: radius), nil)
        maskNode.lineWidth = radius
        maskNode.runAction(pulseForeverAction)
    }
    
    func createContentNode () {
        // set up portrait node
        let diameter = radius * 2
        let paddedDiameter = diameter * 1.3
        let portraitNode = SKSpriteNode(texture: SKTexture(imageNamed: "jak"),
                                        color: SKColor.whiteColor(),
                                        size: CGSizeMake(diameter, diameter))
        portraitNode.anchorPoint = CGPointMake(0.5, 0.5)
        
        contentNode.addChild(portraitNode)
    }
    
    func createProgressNode () {
        // set up a background
        let staticMeterBackground = SKShapeNode(ellipseOfSize: CGSizeMake(progressRadius * 2.0, progressRadius * 2.0))
        staticMeterBackground.strokeColor = SKColor(white: 0.15, alpha: 1.0)
        staticMeterBackground.lineWidth = 0.25
//        staticMeterBackground.antialiased = false
        staticMeterBackground.zPosition = -1
        
        // set up the meter
        progressMeter.lineWidth = 1.5
        progressMeter.strokeColor = SKColor(white: 0.85, alpha: 1.0)
//        progressMeter.antialiased = false
        
        // sub node parent heirarchy
        progressNode.addChild(staticMeterBackground)
        progressNode.addChild(progressMeter)
        
        // run pulse, but give it a little lag ;)
        progressNode.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), pulseForeverAction!]))
    }
    
    func createPulseAction () {
        // set up pulse action
        let pulseOutAction = SKAction.scaleTo(1.0, duration: 3.0)
        let pulseInAction = SKAction.scaleTo(0.925, duration: 3.0)
        pulseOutAction.timingMode = .EaseInEaseOut
        pulseInAction.timingMode = .EaseInEaseOut
        
        let pulseAction = SKAction.sequence([pulseInAction, pulseOutAction])
        pulseForeverAction = SKAction.repeatActionForever(pulseAction)
    }
    
    func createExplodeAction () {
        let explodeActionDuration = 0.33
        
        // set up explode action
        let explodeOutAction = SKAction.scaleTo(8.0, duration: explodeActionDuration)
        let fadeOutAction = SKAction.fadeAlphaTo(0.0, duration: explodeActionDuration)
        let playSoundAction = SKAction.playSoundFileNamed("zoom.wav", waitForCompletion: false)
        explodeOutAction.timingMode = .EaseOut
        
        explodeAction = SKAction.group([explodeOutAction, fadeOutAction, playSoundAction])
    }
    
    // MARK: - Entity Logic
    
    func update (dt: NSTimeInterval) {
        if !unlocked {
            unlockProgress -= CGFloat(dt) / unlockProgressDrainTime
        }
    }
    
    func updateProgressNode () {
        
        // draw a partial circle
        var mod: CGFloat = unlockProgress
        mod *= 2.0 * CGFloat(M_PI)
        mod = CGFloat(M_PI)/2.0 - mod
        fillPath.removeAllPoints()
        fillPath.addArcWithCenter(  CGPointMake(0.0, 0.0),
            radius: progressRadius,
            startAngle: CGFloat(M_PI/2.0),
            endAngle: CGFloat(mod),
            clockwise: false )
        progressMeter.path = nil
        progressMeter.path = fillPath.CGPath
    }
    
    func unlock () {
        // run explode animations
        progressNode.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), explodeAction!]))
        cropNode.runAction(SKAction.sequence([SKAction.waitForDuration(1.5), explodeAction!]))
        
        // wait a bit and run the unlock closure
        runAction(SKAction.sequence([SKAction.waitForDuration(2.5), SKAction.runBlock({
            if let u_unlockClosure = self.unlockClosure {
                u_unlockClosure()
            }
        })]))
    }
}