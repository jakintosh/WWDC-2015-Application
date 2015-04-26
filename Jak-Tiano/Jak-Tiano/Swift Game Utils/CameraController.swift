//
//  Camera.swift
//  wwShootProto
//
//  Created by Jak Tiano on 10/5/14.
//  Copyright (c) 2014 not a hipster coffee shop. All rights reserved.
//

import Foundation
import SpriteKit

class CameraController : SKNode, UIGestureRecognizerDelegate {
    
    // camera properties
    var camera: CGPoint = CGPointZero   // starts at (0,0)
    var lastPoint: CGPoint = CGPointZero
    var camScale: CGFloat = 1.0         // standard zoom as default
    var lerpSpeed: CGFloat = 0.1        // 0 - doesn't move, 1 - locked to target
    
    // screen shake
    var shakeIntensity: CGFloat = 0.0         // max number of points to move
    var shakeDuration: NSTimeInterval = 0.0
    var shakeRemaining: NSTimeInterval = 0.0
    var isShaking: Bool = false
    
    // camera components
    let zoomNode: SKNode = SKNode()
    let rootNode: SKNode = SKNode()
    let hudNode: SKNode = SKNode()
    
    // other
    var debugMode: Bool = false
    
    private var pinchGestureRecognizer: UIPinchGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    // MARK: - CameraController
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.name = "CamCon"
        zoomNode.name = "Zoom_Node"
        rootNode.name = "Root_Node"
        hudNode.name  = "HUD_Node"
        
        zoomNode.zPosition = 0.0
        rootNode.zPosition = 0.0
        hudNode.zPosition = 1000.0
        
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer?.maximumNumberOfTouches = 1
        
        addChild(hudNode)
        addChild(zoomNode)
        zoomNode.addChild(rootNode)
    }
    
    func update(dt: NSTimeInterval) {
        
        // find camera position for this frame
        rootNode.position = Utilities2D.lerpFromPoint(lastPoint, toPoint: CGPointMake(-camera.x, -camera.y), atPosition: lerpSpeed)
        
        // set this position as last point
        lastPoint = rootNode.position
        
        // find shake offset
        if isShaking {
            shakeRemaining -= dt
            if shakeRemaining <= 0 {
                isShaking = false
                shakeRemaining = 0.0
                shakeDuration = 0.0
                shakeIntensity = 0.0
            } else {
                let direction: CGFloat = (CGFloat(arc4random_uniform(100)) / 100.0) * 6.283
                let magnitude: CGFloat = (CGFloat(arc4random_uniform(100)) / 100.0) * shakeIntensity * CGFloat(shakeRemaining/shakeDuration)
                let xDelta = cos(direction) * magnitude
                let yDelta = sin(direction) * magnitude
                
                rootNode.position = Utilities2D.addPoint(CGPoint(x: xDelta, y: yDelta), toPoint: rootNode.position)
            }
        }
        
        // apply zoom and rotation
        let newScale = Utilities2D.lerpFrom(zoomNode.xScale, toNum: camScale, atPosition: lerpSpeed)
        zoomNode.xScale = newScale
        zoomNode.yScale = newScale
    }
    
    func shake(intensity: CGFloat, duration: NSTimeInterval) {
        if intensity > 0.0 {
            isShaking = true
            if intensity > shakeIntensity {
                shakeIntensity = intensity      // if the new intensity is stronger, overwrite
            } else if shakeIntensity > 0.0 {
                shakeIntensity += intensity/2.0 // if it's already shaking stronger, just add a little bit more
            }
            if duration > shakeRemaining {
                shakeDuration = duration      // if the new duration is longer, overwrite
                shakeRemaining = duration
            } else if shakeRemaining > 0.0 {
                shakeDuration += duration/2.0 // if it's already shaking longer, just add a little bit more
                shakeRemaining += duration/2.0
            }
        }
    }
    
    func addCameraChild(inNode: SKNode, withZ z: Float) {
        rootNode.addChild(inNode)
        inNode.zPosition = CGFloat(z)
    }
    
    func addHUDChild(inNode: SKNode, withZ z: Float) {
        hudNode.addChild(inNode)
        inNode.zPosition = CGFloat(z)
    }
    
    func removeCameraChildren(nodes: SKNode...) {
        rootNode.removeChildrenInArray(nodes)
    }
    
    func removeHUDChildren(nodes: SKNode...) {
        hudNode.removeChildrenInArray(nodes)
    }
    
    func convertScenePointToCamera(point: CGPoint) -> CGPoint {
        return Utilities2D.subPoint(rootNode.position, fromPoint: point)
    }

//    MARK: - Getters/Setters
    
    func setCameraStartingPosition(position: CGPoint) {
        setCameraPosition(position)
        rootNode.position = CGPointMake(-position.x, -position.y)
    }
    
    func setCameraStartingPosition(#x: CGFloat, y: CGFloat) {
        setCameraStartingPosition(CGPoint(x: x, y: y))
    }
    
    func setCameraPosition(target: CGPoint) {
        camera = target
    }
    
    func setCameraPosition(#x: CGFloat, y: CGFloat) {
        setCameraPosition(CGPoint(x: x, y: y))
    }
    
    override func setScale(scale: CGFloat) {
        camScale = scale
    }
    
    func setRotiation(rotation: CGFloat) {
        zoomNode.zRotation = rotation
    }
    
    func getScale() -> CGFloat {
        return camScale
    }
    
    func getRootScale() -> CGFloat {
        return zoomNode.xScale
    }
    
    func enableDebug() {
        debugMode = true
        pinchGestureRecognizer?.enabled = true
        panGestureRecognizer?.enabled = true
    }
    
    func disableDebug() {
        debugMode = false
        pinchGestureRecognizer?.enabled = false
        panGestureRecognizer?.enabled = false
    }
    
//    MARK: - Gesture Recognizers
    
    func connectGestureRecognizers(view: SKView) {
        if let pinch = pinchGestureRecognizer {
            view.addGestureRecognizer(pinch)
        }
        if let pan = panGestureRecognizer {
            view.addGestureRecognizer(pan)
        }
    }
    
    func disconnectGestureRecognizers(view: SKView) {
        if let pinch = pinchGestureRecognizer {
            view.removeGestureRecognizer(pinch)
        }
        if let pan = panGestureRecognizer {
            view.removeGestureRecognizer(pan)
        }
    }
    
    func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        if debugMode {
            if gestureRecognizer.state == .Began {
                gestureRecognizer.scale = getScale()
            }
            setScale( gestureRecognizer.scale )
        }
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if debugMode {
            if gestureRecognizer.state == .Changed {
                var translation: CGPoint = gestureRecognizer.translationInView(gestureRecognizer.view!)
                translation = CGPointMake(translation.x, -translation.y)
                camera = CGPointMake(camera.x - translation.x, camera.y - translation.y)
                gestureRecognizer.setTranslation(CGPointZero, inView:gestureRecognizer.view)
            }
        }
    }
    
}
