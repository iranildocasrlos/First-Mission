//
//  GameScene.swift
//  First Mission
//
//  Created by Iranildo C Silva on 16/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    var gameArea: CGRect
    
    
    struct PhysiscsCategories{
        static let Nome: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let Emeny : UInt32 = 0b100 //4
        
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random( min min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playAbleWidth = size.height / maxAspectRatio
        let margin = (size.width - playAbleWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playAbleWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    
    
    // Mark move player add background
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        
        let background  = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        //Adicionando o player
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysiscsCategories.Player
        player.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        player.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(player)
        
        
        startNewlevel()
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
                var body1 = SKPhysicsBody()
                var body2 = SKPhysicsBody()
        
                if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
                    body1 = contact.bodyA
                    body2 = contact.bodyB
                }else{
                    body1 = contact.bodyB
                    body2 = contact.bodyA
                }
        
                if body1.categoryBitMask == PhysiscsCategories.Player && body2.categoryBitMask == PhysiscsCategories.Emeny{
                    //if player has hit the enemy
        
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                }
                if body1.categoryBitMask == PhysiscsCategories.Bullet && body2.categoryBitMask == PhysiscsCategories.Emeny{
                    //if bullet has hit the enemy
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
        
        
                }
        
    }
    
    
//    func didBeginContatct(contact: SKPhysicsContact){
//
//        var body1 = SKPhysicsBody()
//        var body2 = SKPhysicsBody()
//
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
//            body1 = contact.bodyA
//            body2 = contact.bodyB
//        }else{
//            body1 = contact.bodyB
//            body2 = contact.bodyA
//        }
//
//        if body1.categoryBitMask == PhysiscsCategories.Player && body2.categoryBitMask == PhysiscsCategories.Emeny{
//            //if player has hit the enemy
//
//            body1.node?.removeFromParent()
//            body2.node?.removeFromParent()
//        }
//        if body1.categoryBitMask == PhysiscsCategories.Bullet && body2.categoryBitMask == PhysiscsCategories.Emeny{
//            //if bullet has hit the enemy
//            body1.node?.removeFromParent()
//            body2.node?.removeFromParent()
//
//
//        }
//
//
//    }
    
    
    
    //Mark start new Level
    func startNewlevel(){
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
        
        
        
        
    }
    
    
    
    
    
// Mark add fire Gun
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysiscsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        bullet.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(bullet)
        
        let bulletSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    
    }
    
    
    //Mark Add inemy
    
    func spawnEnemy(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        
        let  startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.3)
        let  endPoint = CGPoint(x: randomXEnd, y: self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysiscsCategories.Emeny
        enemy.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        enemy.physicsBody!.contactTestBitMask = PhysiscsCategories.Player | PhysiscsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnenmy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enenySeguence = SKAction.sequence([moveEnenmy, deleteEnemy])
        enemy.run(enenySeguence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRoutate = atan2(dy, dx)
        enemy.zRotation = amountToRoutate
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
        
        
    }
    
    //Mark get Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedUpDown = pointOfTouch.y - previousPointOfTouch.y
            
            player.position.x += amountDragged
            player.position.y += amountDraggedUpDown
            
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2{
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
            
            if player.position.y > CGRectGetMaxY(gameArea) - player.size.height/2{
                player.position.y = CGRectGetMaxY(gameArea) - player.size.height/2
            }
            
            if player.position.y < CGRectGetMinY(gameArea) + player.size.height/2{
                player.position.y = CGRectGetMinY(gameArea) + player.size.height/2
            }
            
            
            
        }
    }
    
    
    
}
