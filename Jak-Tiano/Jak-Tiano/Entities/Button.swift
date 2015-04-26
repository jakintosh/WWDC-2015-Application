//
//  NHCSButton.swift
//  wwShootProto
//
//  Created by Jak Tiano on 10/20/14.
//  Copyright (c) 2014 not a hipster coffee shop. All rights reserved.
//

import Foundation
import SpriteKit

class Button : NHCNode {
    
    // MARK: - Properties
    var activated: Bool = true
    var selected: Bool = false
    
    // MARK: - Initializers
    override init() {
        super.init()
        
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("shouldn't use init(coder:)")
    }
    
    // MARK: - Methods
    func activate() {
        activated = true
    }
    
    func deactivate() {
        activated = false
    }
    
    func completionAction() {
        // fill in in subclasses
        println("completion")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if activated {
            selected = true
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if activated {
            var touch: UITouch = touches.first as! UITouch
            var location: CGPoint = touch.locationInNode(self)
            
            if containsPoint(location) {
                selected = true
            } else {
                selected = false
            }
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if activated {
            var touch: UITouch = touches.first as! UITouch
            var location: CGPoint = touch.locationInNode(scene!)
            
            if containsPoint(location) {
                completionAction()
            }
            
            selected = false
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        if activated {
            selected = false
        }
    }
}