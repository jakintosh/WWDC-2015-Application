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
    let portraitButton = PortraitButton(radius: 80)
    
    var menuButtons: [MenuOptionButton] = [MenuOptionButton]()
    
    // MARK: - Scene transitions
    
    override func didMoveToView(view: SKView) {
        
        // set up scene
        anchorPoint = CGPointMake(0.5, 0.5) // centers the camera
        backgroundColor = SKColor(white: 0.5, alpha: 1.0)
        
        // set up nodes
        portraitButton.camCon = camCon
        portraitButton.unlockClosure = {
            self.dismissUnlockButton()
        }
        
        // add nodes to camera
        camCon.addCameraChild(portraitButton, withZ: 0)
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
    }
    
    func dismissSideMenu() {
        
    }
    
    
    // MARK: - Touch events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
    }
    
}