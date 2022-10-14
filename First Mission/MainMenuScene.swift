//
//  MainMenuScene.swift
//  First Mission
//
//  Created by Iranildo C Silva on 14/10/22.
//

import Foundation

import SpriteKit

class MainManuScene: SKScene{
    let startGame = SKLabelNode(fontNamed: "THEBOLDFONT")
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
       
        
        
        let player = SKSpriteNode(imageNamed: "playerShip")
        player.setScale(1)
        player.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        player.zPosition = 1
        self.addChild(player)
        
        
        var meteorFrames = [SKTexture]()
        
        let gameBy = SKLabelNode(fontNamed: "THEBOLDFONT")
        gameBy.text = "Local Oeste Software House"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.595)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode(fontNamed: "THEBOLDFONT")
        gameName1.text = "FIRST"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "THEBOLDFONT")
        gameName2.text = "MISSION"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        
        startGame.text = "START GAME"
        startGame.name = "startButton"
        startGame.fontSize = 120
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        self.addChild(startGame)
        
        
        meteorObject()
        
    }
    
    
  
    
    func meteorObject(){
        
       
        
        let  startPoint = CGPoint(x: self.size.width - 2, y: self.size.height * 1.3)
        let  endPoint = CGPoint(x: self.size.width/2, y: self.size.height * 0.0)
        
        
        let meteorSpriteNode = SKSpriteNode(imageNamed: "tile000")
        var meteorFrames = [SKTexture]()
        
        
        let textureAtlasMeteor =  SKTextureAtlas(named: "Meteor Frames")
        
        
        
        meteorSpriteNode.setScale(1)
        meteorSpriteNode.position = startPoint
        meteorSpriteNode.name = "Meteor"
        meteorSpriteNode.zPosition = 2
        meteorSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: meteorSpriteNode.size)
        meteorSpriteNode.physicsBody!.affectedByGravity = false
       
        self.addChild(meteorSpriteNode)
        
        let moveMeteor = SKAction.move(to: endPoint, duration: 3.0)
        let deleteMeteor = SKAction.removeFromParent()
        let meteorSeguence = SKAction.sequence([moveMeteor, deleteMeteor])
        meteorSpriteNode.run(meteorSeguence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        
        for index in 0..<textureAtlasMeteor.textureNames.count{
            let textureNamesMet = "tile00" + String(index)
            meteorFrames.append(textureAtlasMeteor.textureNamed(textureNamesMet))
        }
        
        
        let amountToRoutate = atan2(dy, dx)
        meteorSpriteNode.zRotation = amountToRoutate
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = nodes(at: pointOfTouch)
            
            
            if startGame.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode =  self.scaleMode
                let myTrasition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTrasition)
            }
            
        }
    }
    
    
    
    
}
