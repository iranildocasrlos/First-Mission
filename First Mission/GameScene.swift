//
//  GameScene.swift
//  First Mission
//
//  Created by Iranildo C Silva on 16/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    var gameArea: CGRect
    
    
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
        let background  = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        //Adicionando o player
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
    }
    
    
    //Mark start new Level
    
    
    
    
    
    
// Mark add fire Gun
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let bulletSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    
    }
    
    
    //Mark Add inemy
    
    func spawnEnemy(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMinX(gameArea) )
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        
        let  startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.3)
        let  endPoint = CGPoint(x: randomXEnd, y: self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
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
        spawnEnemy()
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
