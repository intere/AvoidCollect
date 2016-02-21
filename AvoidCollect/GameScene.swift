//
//  GameScene.swift
//  AvoidCollect
//
//  Created by Eric Internicola on 2/20/16.
//  Copyright (c) 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode?
    var squareCollect: SKSpriteNode?
    var circleAvoid: SKShapeNode?
    var stars: SKSpriteNode?
    var lblScore: SKLabelNode?
    var lblMain: SKLabelNode?
    
    let squareSpeed = 1.5
    let circleSpeed = 2.0
    let hudColor = UIColor.whiteColor()
    let backColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
    let circleColor = UIColor(red: 60/255, green: 120/255, blue: 50/255, alpha: 1)
    let squareColor = UIColor(red: 120/255, green: 200/255, blue: 100/255, alpha: 1)
    let starColor = UIColor(red: 170/255, green: 200/255, blue: 160/255, alpha: 1)
    let playerColor = UIColor.whiteColor()
    
    var isAlive = true
    var score = 0
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = backColor
        
        spawnPlayer()
        spawnSquareCollect()
        spawnCircleAvoid()
        spawnStars()
        spawnScoreLabel()
        spawnMainLabel()
        
        squareSpawnTimer()
        circleSpawnTimer()
        starsSpawnTimer()
    }
   
    override func update(currentTime: CFTimeInterval) {
        if let player = player, lblScore = lblScore where !isAlive {
            player.position.x = -200
            lblScore.position.x = CGRectGetMidX(frame)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let player = player, lblScore = lblScore where isAlive {
                player.position.x = location.x
                lblScore.position.x = location.x
            } else {
                player?.position.x = -200
            }
        }
    }
    
    // MARK: - Helper Method
    
    func spawnPlayer() {
        player = SKSpriteNode(color: playerColor, size: CGSize(width: 50, height: 50))
        if let player = player {
            player.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame)+player.size.height*2)
            player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.squareCollect | PhysicsCategory.circleAvoid
            player.physicsBody?.dynamic = false
            
            addChild(player)
        }
    }
    
    func spawnSquareCollect() {
        squareCollect = SKSpriteNode(color: squareColor, size: CGSize(width: 30, height: 30))
        if let squareCollect = squareCollect {
            squareCollect.position = CGPoint(x: Double(arc4random_uniform(UInt32(CGRectGetMaxX(frame)))), y: Double(CGRectGetMaxY(frame) + squareCollect.size.height * 2))
            squareCollect.physicsBody = SKPhysicsBody(rectangleOfSize: squareCollect.size)
            squareCollect.physicsBody?.affectedByGravity = false
            squareCollect.physicsBody?.categoryBitMask = PhysicsCategory.squareCollect
            squareCollect.physicsBody?.contactTestBitMask = PhysicsCategory.player
            squareCollect.physicsBody?.dynamic = true
            squareCollect.physicsBody?.allowsRotation = false
            
            let moveForward = SKAction.moveToY(-100, duration: squareSpeed)
            let destroy = SKAction.removeFromParent()
            squareCollect.runAction(SKAction.sequence([moveForward, destroy]))
            
            addChild(squareCollect)
        }
    }
    
    func spawnCircleAvoid() {
        let radius: CGFloat = 15
        circleAvoid = SKShapeNode(circleOfRadius: radius)
        if let circleAvoid = circleAvoid {
            circleAvoid.strokeColor = UIColor.clearColor()
            circleAvoid.fillColor = circleColor
            circleAvoid.position = CGPoint(x: Double(arc4random_uniform(UInt32(CGRectGetMaxX(frame)))), y: Double(CGRectGetMaxY(frame) + radius * 4))
            
            circleAvoid.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            circleAvoid.physicsBody?.affectedByGravity = false
            circleAvoid.physicsBody?.categoryBitMask = PhysicsCategory.circleAvoid
            circleAvoid.physicsBody?.contactTestBitMask = PhysicsCategory.player
            circleAvoid.physicsBody?.collisionBitMask = PhysicsCategory.player
            circleAvoid.physicsBody?.dynamic = true
            circleAvoid.physicsBody?.allowsRotation = false
            
            let moveForward = SKAction.moveToY(-100, duration: circleSpeed)
            let destroy = SKAction.removeFromParent()
            circleAvoid.runAction(SKAction.sequence([moveForward, destroy]))
            
            addChild(circleAvoid)
        }
    }
    
    func spawnStars() {
        let randomSize = CGFloat(arc4random_uniform(3))
        let randomSpeed = NSTimeInterval(arc4random_uniform(2) + 1)
        stars = SKSpriteNode(color: starColor, size: CGSize(width: randomSize, height: randomSize))
        if let stars = stars {
            stars.position = CGPoint(x: Double(arc4random_uniform(UInt32(CGRectGetMaxX(frame)))), y: Double(CGRectGetMaxY(frame) + randomSize*2))
            stars.zPosition = -1
            
            let moveForward = SKAction.moveToY(-100, duration: randomSpeed)
            let destroy = SKAction.removeFromParent()
            stars.runAction(SKAction.sequence([moveForward, destroy]))
            
            addChild(stars)
        }
    }
    
    func spawnScoreLabel() {
        lblScore = SKLabelNode(fontNamed: "Courier")
        if let lblScore = lblScore, player = player {
            lblScore.fontSize = 60
            lblScore.fontColor = hudColor
            lblScore.position = CGPoint(x: player.position.x, y: player.position.y - 80)
            lblScore.text = "\(score)"
            
            addChild(lblScore)
        }
    }
    
    func spawnMainLabel() {
        lblMain = SKLabelNode(fontNamed: "Courier")
        if let lblMain = lblMain {
            lblMain.fontSize = 80
            lblMain.fontColor = hudColor
            lblMain.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            lblMain.text = "Start!"
            
            lblMain.runAction(SKAction.sequence([SKAction.waitForDuration(3.0), SKAction.runBlock {
                lblMain.alpha = 0
            }]))
            
            addChild(lblMain)
        }
    }
    
    func spawnExplosion(circleAvoid: SKShapeNode) {
        if let explosionEmitterPath = NSBundle.mainBundle().pathForResource("particleExplosion", ofType: "sks"), explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmitterPath) as? SKEmitterNode {
            explosion.position = CGPoint(x: circleAvoid.position.x, y: circleAvoid.position.y)
            explosion.zPosition = 1
            explosion.targetNode = self
            
            runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
            addChild(explosion)
        } else {
            print("ERROR: Couldn't find explosion")
        }
    }
    
    func squareSpawnTimer() {
        let squareTimer = SKAction.waitForDuration(1)
        let spawn = SKAction.runBlock {
            self.spawnSquareCollect()
        }
        let sequence = SKAction.sequence([squareTimer, spawn])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    func circleSpawnTimer() {
        let circleTimer = SKAction.waitForDuration(0.5)
        let spawn = SKAction.runBlock {
            self.spawnCircleAvoid()
        }
        let sequence = SKAction.sequence([circleTimer, spawn])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    func starsSpawnTimer() {
        let starsTimer = SKAction.waitForDuration(0.05)
        let spawn = SKAction.runBlock {
            self.spawnStars()
        }
        let sequence = SKAction.sequence([starsTimer, spawn])
        runAction(SKAction.repeatActionForever(sequence))
    }
    
    func updateScore() {
        if let lblScore = lblScore {
            lblScore.text = "\(score)"
        }
    }
    
    func waitThenMoveToTitleScene() {
        let wait = SKAction.waitForDuration(2)
        let transition = SKAction.runBlock {
            if let view = self.view, scene = TitleScene(fileNamed: "TitleScene") {
                view.ignoresSiblingOrder = true
                scene.scaleMode = .AspectFill
                view.presentScene(scene)
            }
        }
        let sequence = SKAction.sequence([wait, transition])
        runAction(SKAction.repeatAction(sequence, count: 1))
    }
    
    // MARK: - SKPhysicsContactDelegate Methods
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // Player / Square Collect collision
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.squareCollect) || (firstBody.categoryBitMask == PhysicsCategory.squareCollect && secondBody.categoryBitMask == PhysicsCategory.player) {
            playerSquareCollision(firstBody.node as? SKSpriteNode , squareTemp: secondBody.node as? SKSpriteNode)
        } else if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.circleAvoid) || (firstBody.categoryBitMask == PhysicsCategory.circleAvoid && secondBody.categoryBitMask == PhysicsCategory.player) {

            if let circleAvoid = firstBody.node as? SKShapeNode, player = secondBody.node as? SKSpriteNode {
                spawnExplosion(circleAvoid)
                playerCircleCollision(player, circleTemp: circleAvoid)
            } else if let player = firstBody.node as? SKSpriteNode, circleAvoid = secondBody.node as? SKShapeNode {
                spawnExplosion(circleAvoid)
                playerCircleCollision(player, circleTemp: circleAvoid)

            }
        }
    }
    
    // MARK: Contact Handler Methods
    
    func playerSquareCollision(playerTemp: SKSpriteNode?, squareTemp: SKSpriteNode?) {
        if let _ = playerTemp, squareTemp = squareTemp {
            squareTemp.removeFromParent()
            score++
            updateScore()
        }
    }
    
    func playerCircleCollision(playerTemp: SKSpriteNode, circleTemp: SKShapeNode) {
        if let lblMain = lblMain {
            lblMain.alpha = 1
            lblMain.text = "Game Over"
            isAlive = false
            waitThenMoveToTitleScene()
        }
    }
    
    // MARK: - Structures
    
    struct PhysicsCategory {
        static let player: UInt32 = 1
        static let squareCollect: UInt32 = 2 << 0
        static let circleAvoid: UInt32 = 2 << 1
    }
}
