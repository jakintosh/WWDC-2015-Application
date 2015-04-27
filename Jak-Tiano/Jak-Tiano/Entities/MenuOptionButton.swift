//
//  MenuOptionButton.swift
//  Jak-Tiano
//
//  Created by Jak Tiano on 4/26/15.
//  Copyright (c) 2015 jaktiano. All rights reserved.
//

import Foundation
import SpriteKit

enum MenuDirection {
    case Left, Right
}

class MenuOptionButton: Button {
    
    // MARK: - Properties
    let direction: MenuDirection
    let offScreenAnchor: CGFloat
    
    var wasSelected: Bool = false
    var presentClosure: ((dir: MenuDirection, name: String) -> Void)?
    var buttonName: String? {
        didSet {
            if let text = buttonName {
                labelNode.text = text
                self.name = text
                menuContents.texture = SKTexture(imageNamed: text)
            }
        }
    }
    
    // MARK: - Nodes
    let labelNode: SKLabelNode = SKLabelNode()
    let background: SKSpriteNode
    let menuNode: SKSpriteNode
    let menuContents: SKSpriteNode = SKSpriteNode(imageNamed: "COMPANY")
    
    init (dir: MenuDirection, sceneWidth: CGFloat, sceneHeight: CGFloat) {
        
        direction = dir
        
        // setup the size
        let width = sceneWidth
        let height = sceneHeight / 4
        background  = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(width, height))
        
        menuNode = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(sceneWidth, sceneHeight))
        
        // set the anchor point off screen
        switch (direction)
        {
        case .Left:
            offScreenAnchor = -sceneWidth
        case .Right:
            offScreenAnchor = sceneWidth
        }
        
        // init superclass
        super.init()
        
        switch (direction)
        {
        case .Left:
            menuNode.color = SKColor(white: 0.85, alpha: 1.0)
            menuNode.position = CGPointMake(-sceneWidth, 0.0)
            background.color = SKColor(white: 0.85, alpha: 1.0)
            labelNode.fontColor = SKColor(white: 0.15, alpha: 1.0)
            labelNode.position = CGPointMake(50, 0)
            
        case .Right:
            menuNode.color = SKColor(white: 0.15, alpha: 1.0)
            menuNode.position = CGPointMake(sceneWidth, 0.0)
            background.color = SKColor(white: 0.15, alpha: 1.0)
            labelNode.fontColor = SKColor(white: 0.85, alpha: 1.0)
            labelNode.position = CGPointMake(-50, 0)
        }
        
        background.anchorPoint = CGPointMake(0.5, 0.5)
        
        labelNode.verticalAlignmentMode = .Center
        labelNode.fontSize  = 28
        labelNode.zPosition = 1
        
        menuNode.addChild(menuContents)
        addChild(menuNode)
        addChild(background)
        addChild(labelNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("shouldn't use init(coder:)")
    }
    
    override func completionAction() {
        if activated {
            if let u_present = presentClosure {
                wasSelected = true
                u_present(dir: self.direction, name: self.buttonName!)
            }
        }
    }
    
    func setButtonPosition(pos: CGPoint) {
        position = pos
        menuNode.position.y = -pos.y
    }
    
    func present(delay: NSTimeInterval) {
        
        activated = true
        
        var xDelta: CGFloat = 0
        if direction == .Left { xDelta = -60 }
        else                  { xDelta =  60 }
        
        let move = SKAction.moveToX(xDelta, duration: 0.5)
        move.timingMode = .EaseOut
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(delay),move]))
    }
    
    func dismiss(delay: NSTimeInterval) {
        if !wasSelected {
            
            activated = false
            let move = SKAction.moveToX(offScreenAnchor, duration: 0.33)
            move.timingMode = .EaseOut
            
            self.runAction(SKAction.sequence([SKAction.waitForDuration(delay),move]))
        }
    }
    
    func reset() {
        wasSelected = false
        var xDelta: CGFloat = 0
        if direction == .Left { xDelta = -60 }
        else                  { xDelta =  60 }
        let move = SKAction.moveToX(xDelta, duration: 0.5)
        move.timingMode = .EaseOut
        self.runAction(move)
    }
    
    func select() {
        
        let move = SKAction.moveToX(-offScreenAnchor, duration: 0.5)
        move.timingMode = .EaseOut
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(1.0),move]))
    }
    
}
