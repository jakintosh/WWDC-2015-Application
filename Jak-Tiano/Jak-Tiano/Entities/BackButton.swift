//
//  BackButton.swift
//  Jak-Tiano
//
//  Created by Jak Tiano on 4/26/15.
//  Copyright (c) 2015 jaktiano. All rights reserved.
//

import Foundation
import SpriteKit

class BackButton : Button {
    
    // MARK: - Properties
    var screenWidth: CGFloat?
    var isPresented: Bool = false
    var currentDirection: MenuDirection?
    var completionHandler: (()->Void)?
    
    // MARK: - Nodes
    let backSprite = SKSpriteNode(imageNamed: "back")
    
    override init() {
        super.init()
        
        name = "back"
        position = CGPointMake(9999, 9999)
        
        addChild(backSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("shouldn't use init(coder:)")
    }
    
    override func completionAction() {
        if let u_completion = completionHandler {
            u_completion()
        }
    }
    
    func present(dir: MenuDirection) {
        if !isPresented {
            isPresented = true
            currentDirection = dir
            
            var targetXpos: CGFloat = 0
            switch (currentDirection!)
            {
            case .Left:
                position.x = screenWidth!/2 + backSprite.size.width/2
                targetXpos = screenWidth!/2
            case .Right:
                position.x = -screenWidth!/2 - backSprite.size.width/2
                targetXpos = -screenWidth!/2
            }
            position.y = -180
            
            let moveAction = SKAction.moveToX(targetXpos, duration: 0.33)
            moveAction.timingMode = .EaseOut
            
            runAction(SKAction.sequence([SKAction.waitForDuration(1.5), moveAction]))
        }
    }
    
    func dismiss() {
        if isPresented {
            isPresented = false
            
            var targetXpos: CGFloat = 0
            switch (currentDirection!)
            {
            case .Left:
                targetXpos = screenWidth!/2 + backSprite.size.width/2
            case .Right:
                targetXpos = -screenWidth!/2 - backSprite.size.width/2
            }
            
            let moveAction = SKAction.moveToX(targetXpos, duration: 0.33)
            moveAction.timingMode = .EaseIn
            
            runAction(moveAction)
        }
    }
    
}