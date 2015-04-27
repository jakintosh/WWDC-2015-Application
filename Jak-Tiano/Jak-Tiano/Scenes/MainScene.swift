//
//  MainScene.swift
//  Jak-Tiano
//
//  Created by Jak Tiano on 4/23/15.
//  Copyright (c) 2015 jaktiano. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene: NHCCamScene {
    
    // nodes
    let label: SKLabelNode = SKLabelNode()
    
    let portraitButton = PortraitButton(radius: 80)
    let backButton: BackButton = BackButton()
    var menuButtons: [MenuOptionButton] = [MenuOptionButton]()
    
    // MARK: - Scene transitions
    
    override func didMoveToView(view: SKView) {
        
        // set up scene
        anchorPoint = CGPointMake(0.5, 0.5) // centers the camera
        backgroundColor = SKColor(white: 0.5, alpha: 1.0)
        
        // set up nodes
        backButton.screenWidth = size.width
        backButton.completionHandler = {
            self.dismissSideMenu()
        }
        
        portraitButton.camCon = camCon
        portraitButton.unlockClosure = {
            self.dismissUnlockButton()
        }
        
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center
        label.text = "tap rapidly"
        label.fontSize = 16
        label.position = CGPointMake(0.0, -160)
        
        // add nodes to camera
        camCon.addCameraChild(portraitButton, withZ: 0)
        camCon.addCameraChild(label, withZ: -100)
        camCon.addHUDChild(backButton, withZ: 10)
    }
    
    override func willMoveFromView(view: SKView) {
        
    }
    
    
    // MARK: - Game loop
    
    override func update(currentTime: NSTimeInterval) {
        updateTime(currentTime)
        
        // update entities
        portraitButton.update(deltaTime)
        
        // update camera
        camCon.update(deltaTime)
    }
    
    override func didEvaluateActions() {
        
    }
    
    override func didSimulatePhysics() {
        
    }
    
    override func didApplyConstraints() {
        
    }
    
    override func didFinishUpdate() {
        
    }
    
    // MARK: - Logic
    
    func setUpMenuButtons() {
        let height = size.height/4
        let yOffset = height + height/2
        
        for i in 0..<4 {
            
            // determine direction
            var dir: MenuDirection = .Left
            if i%2 == 1 {
                dir = .Right
            }
            
            // create button
            let menuButton = MenuOptionButton(dir: dir, sceneWidth: size.width, sceneHeight: size.height)
            
            // determine position
            let y = yOffset - (height * CGFloat(i))
            if dir == .Left {
                menuButton.setButtonPosition(CGPointMake(-size.width, y))
            } else {
                menuButton.setButtonPosition(CGPointMake(size.width, y))
            }
            
            menuButton.presentClosure = { (dir: MenuDirection, name: String) in
                self.dismissMainMenu()
                self.presentSideMenu(dir, menuName: name)
            }
            
            camCon.addHUDChild(menuButton, withZ: 0)
            
            menuButtons.append(menuButton)
        }
        
        menuButtons[0].buttonName = "PROJECTS"
        menuButtons[1].buttonName = "EDUCATION"
        menuButtons[2].buttonName = "COMPANY"
        menuButtons[3].buttonName = "ABOUT ME"
    }
    
    func presentUnlockButton() {
        
    }
    
    func dismissUnlockButton() {
        // remove portrait from scene
        camCon.removeCameraChildren(label)
        camCon.removeCameraChildren(portraitButton)
        setUpMenuButtons()
        presentMainMenu()
    }
    
    func presentMainMenu() {
        var delay: NSTimeInterval = 0
        for button in menuButtons {
            button.present(delay)
            delay += 0.15
        }
    }
    
    func dismissMainMenu() {
        var delay: NSTimeInterval = 0
        for button in menuButtons {
            button.dismiss(delay)
            delay += 0.15
        }
    }
    
    func presentSideMenu(dir: MenuDirection, menuName: String) {
        for button in menuButtons {
            if button.wasSelected {
                button.select()
            }
        }
        backButton.present(dir)
    }
    
    func dismissSideMenu() {
        backButton.dismiss()
        for b in menuButtons {
            if b.wasSelected {
                b.reset()
            }
        }
        
        runAction(SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.runBlock({
            self.presentMainMenu()
        })]))
    }
    
    
    // MARK: - Touch events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touch in \(nodeAtPoint((touches.first as! UITouch).locationInNode(self)).name)")
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
    }
    
}