//
//  TitleScene.swift
//  AvoidCollect
//
//  Created by Eric Internicola on 2/20/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit
import SpriteKit

class TitleScene: SKScene {
    
    var btnPlay: UIButton?
    var gameTitle: SKLabelNode?
    
    let hudTextColor = UIColor.whiteColor()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        
        setupText()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    // MARK: - Helper Methods
    
    func setupText() {
        gameTitle = SKLabelNode(fontNamed: "Courier")
        if let gameTitle = gameTitle {
            gameTitle.fontSize = 40
            gameTitle.fontColor = hudTextColor
            gameTitle.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            gameTitle.text = "Avoid / Collect"
            
            addChild(gameTitle)
        }
        
        if let view = view {
            btnPlay = UIButton(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 100))
            if let btnPlay = btnPlay {
                btnPlay.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 100)
                btnPlay.titleLabel?.font = UIFont(name: "Courier", size: 100)
                btnPlay.setTitle("Play", forState: .Normal)
                btnPlay.setTitleColor(hudTextColor, forState: .Normal)
                btnPlay.addTarget(self, action: Selector("playTheGame"), forControlEvents: .TouchUpInside)
                view.addSubview(btnPlay)
            }
        }
    }
    
    func playTheGame() {
        if let view = view, btnPlay = btnPlay, gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .AspectFill
            btnPlay.removeFromSuperview()
            view.presentScene(gameScene, transition: SKTransition.fadeWithDuration(1))
            view.ignoresSiblingOrder = true
        }
    }
}
