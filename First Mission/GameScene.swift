//
//  GameScene.swift
//  First Mission
//
//  Created by Iranildo C Silva on 16/09/22.
//

import SpriteKit
import GameplayKit
var gameScore = 0


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var  scoreLabel = SKLabelNode(fontNamed: "THEBOLDFONT")
    var  gameOverLabel = SKLabelNode(fontNamed: "THEBOLDFONT")
    var levelGame = 0
    var loseLife = false
    var enemyPosition: CGPoint = CGPoint(x: 0, y:  1.3)
    var lifesNumber = 3
    let lifesLabel = SKLabelNode(fontNamed:"THEBOLDFONT")
    let tapToStartLabel = SKLabelNode(fontNamed: "THEBOLDFONT")
    let player = SKSpriteNode(imageNamed: "playerShip")
    var levelDuration = TimeInterval()
    //let enemy = SKSpriteNode(imageNamed: "enemyShip")
    let explosionSound = SKAction.playSoundFileNamed("explosionSound.mp3", waitForCompletion: false)
   // let SoundSpace = SKAction.playSoundFileNamed("soundSpace.mp3", waitForCompletion: false)
    var gameArea: CGRect
    var meteorFrames = [SKTexture]()
    var background  = SKSpriteNode(imageNamed: "background")
    let predios2 = SKSpriteNode(imageNamed: "predios2")
    let predios1 = SKSpriteNode(imageNamed: "predios1")
    let predios3 = SKSpriteNode(imageNamed: "predios3")
    
    
    struct PhysiscsCategories{
        static let Nome: UInt32 = 0
        static let Predios1: UInt32 = 0b11//3
        static let Predios2: UInt32 = 0b101//5
        static let Predios3: UInt32 = 0b110//6
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let BulletEnemy: UInt32 = 0b100 //4
        static let Emeny : UInt32 = 0b111 //7
        static let Meteor : UInt32 = 0b111//7
        static let NaveEstrelar : UInt32 = 0b111//7
        
    }
    
    
    enum gameState{
        case preGame // antes de começar o jogo
        case inGame // Durante a partida
        case afterGame //Depois de finalizado o jogo
    }
    
    
    var currentGameState = gameState.preGame
    
    
    
  
    
    
    
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
        
        gameScore = 0 
        
        self.physicsWorld.contactDelegate = self
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
//        moveBackground()
        
        //Adicionando o player
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysiscsCategories.Player
        player.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        player.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(player)
        
        
        //Configuração dos prédios
        predios2.setScale(1)
        predios2.position = CGPoint(x: self.size.width / 2 , y: self.size.height * 0.1)
        predios2.zPosition = 2
        predios2.physicsBody = SKPhysicsBody(rectangleOf: (predios2.size))
        predios2.physicsBody!.affectedByGravity = false
        predios2.physicsBody!.categoryBitMask = PhysiscsCategories.Predios2
        predios2.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
       // predios2.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(predios2)
        
        predios1.setScale(1)
        predios1.position = CGPoint(x: self.size.width / 4 , y: self.size.height * 0.1)
        predios1.zPosition = 2
        predios1.physicsBody = SKPhysicsBody(rectangleOf: (predios1.size))
        predios1.physicsBody!.affectedByGravity = false
        predios1.physicsBody!.categoryBitMask = PhysiscsCategories.Predios1
        predios1.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
       // predios1.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(predios1)
        
        
        predios3.setScale(1)
        predios3.position = CGPoint(x: self.size.width * 0.75 , y: self.size.height * 0.1)
        predios3.zPosition = 2
        predios3.physicsBody = SKPhysicsBody(rectangleOf: (predios3.size))
        predios3.physicsBody!.affectedByGravity = false
        predios3.physicsBody!.categoryBitMask = PhysiscsCategories.Predios3
        predios3.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
       // predios3.physicsBody!.contactTestBitMask = PhysiscsCategories.Emeny
        self.addChild(predios3)
        
        
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 120
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameOverLabel.position = CGPoint(x: self.size.width , y: self.size.height / 2)
        gameOverLabel.zPosition = 100
        self.addChild(gameOverLabel)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.22, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        lifesLabel.text = "Lives: 3"
        lifesLabel.fontSize = 70
        lifesLabel.fontColor = SKColor.white
        lifesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        lifesLabel.position = CGPoint(x: self.size.width*0.78, y: self.size.height + lifesLabel.frame.size.height)
        lifesLabel.zPosition = 100
        self.addChild(lifesLabel)
        
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        lifesLabel.run(moveOnToScreenAction)
        
        
        tapToStartLabel.text = "Tap To Start"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.zPosition = 1
        self.addChild(tapToStartLabel)
        
        
//        let fadeInAction = SKAction.fadeOut(withDuration: 0.3)
//        tapToStartLabel.run(fadeInAction)
//
        
        
        startNewlevel()
        
    }
    
    
    
    /// MARK TO Start Game
    func startGame(){
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.3, duration: 0.5)
        let startlevelAction = SKAction.run(startNewlevel)
        let startGameSeguence = SKAction.sequence([moveShipOnToScreenAction, startlevelAction])
        player.run(startGameSeguence)
        
    }
    
    
    //Mark start new Level
    func startNewlevel(){
        
        levelGame += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        
        
        
        switch levelGame {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        
        let spawn = SKAction.run(spawnEnemy)
        let meteor = SKAction.run(meteorObject)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        var spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        var spawnForever = SKAction.repeatForever(spawnSequence)
        
        if currentGameState == gameState.inGame{
            self.run(spawnForever, withKey: "spawningEnemies")
        }
    
    }
    
    
    
    
    func loseALife(){
        print(lifesNumber)
        lifesNumber -=   1
        lifesLabel.text = "Lives: \(lifesNumber)"
        
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSeguence = SKAction.sequence([scaleUp, scaleDown])
        lifesLabel.run(scaleSeguence)
        
        if lifesNumber == 0{
            runGameOver()
        }
        
        
    }
    
    
    
    //Finish Game
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        gameOverLabel.position = CGPoint(x: self.size.width * 0.30, y: self.size.height / 2)
        
        self.enumerateChildNodes(withName: "Bullet" ){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "MisselEnemy1" ){
            missel, stop in
            missel.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy" ){
            enemy, stop in
            enemy.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Meteor" ){
            meteor, stop in
            meteor.removeAllActions()
        }
        self.enumerateChildNodes(withName: "NaveEstrelar" ){
            estrelar, stop in
            estrelar.removeAllActions()
        }
        
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSeguence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneAction)
        
        
    }
    
    
    func changeScene(){
        
        let sceneToMove = GameOverScene(size: self.size)
        sceneToMove.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMove, transition: myTransition)
        
    }
    
    
   //Pontuação @@@@@@@@@@@@@@@@@@
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore >= 5 {
            
            fireBulletEnemy(spawnPosition: position)

        }
        
        if gameScore >= 25 {
            fireBulletEnemy(spawnPosition: position)
        }
        
        
        if gameScore >= 10 && gameScore <= 17 {
            meteorObject()
        }
        if gameScore >= 25 && gameScore <= 35 {
            spawnNaveEstrela()
        }
        
        if gameScore >= 50 && gameScore <= 56 {
            meteorObject()
        }
        
        if gameScore >= 80 && gameScore <= 85 {
            meteorObject()
        }
        
        if gameScore >= 90 && gameScore <= 95 {
            spawnNaveEstrela()
        }

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
        
        
        
        print("Categoria  => \(body1.categoryBitMask)")
        
        
        // Player
                if body1.categoryBitMask == PhysiscsCategories.Player && body2.categoryBitMask == PhysiscsCategories.Emeny{
                    //if player has hit the enemy
                    
                    if body1.node != nil{
                        spawnExplosion(spawnPosition: body1.node!.position, how: "player")
                        
                        
                        
                    }
                   
                    
                
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                    
                    
                }
        
        // Prédios 1
        
        if body1.categoryBitMask == PhysiscsCategories.Predios1 && body2.categoryBitMask == PhysiscsCategories.Emeny{
            //if player has hit the enemy
           
            
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position, how: "predio1")
                
                
                
            }
           
            
        
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
        
        //Prédios 2
        
        if body1.categoryBitMask == PhysiscsCategories.Predios2 && body2.categoryBitMask == PhysiscsCategories.Emeny{
            //if player has hit the enemy
            
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position, how: "predio2")
                
                
                
            }
           
            
        
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
        
        //Predios 3
        
        if body1.categoryBitMask == PhysiscsCategories.Predios3 && body2.categoryBitMask == PhysiscsCategories.Emeny{
            //if player has hit the enemy
            
            
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position, how: "predio3")
                
                
                
            }
           
            
        
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
        
        
        
        
        
        
        if body1.categoryBitMask == PhysiscsCategories.Bullet && body2.categoryBitMask == PhysiscsCategories.Emeny {
            //&& (body2.node?.position.y)! < self.size.height
            
                    //if bullet has hit the enemy
            
            addScore()
            
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position,how: "enemy" )
            }
            
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
        
        
                }
        
    }
    
    
    
    
    
    func spawnExplosion(spawnPosition: CGPoint, how: String){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
       
        
        if how == "player"{
            let explosioSeguence = SKAction.sequence([explosionSound, scaleIn,fadeOut, delete,loseALifeAction])
            explosion.run(explosioSeguence)
            loseLife = true
        }
        else if how == "predio1"{
            let explosioSeguence = SKAction.sequence([explosionSound, scaleIn,fadeOut, delete,loseALifeAction])
            explosion.run(explosioSeguence)
            
        }
        else if how == "predio2"{
            let explosioSeguence = SKAction.sequence([explosionSound, scaleIn,fadeOut, delete,loseALifeAction])
            explosion.run(explosioSeguence)
            
        }
        else if how == "predio3"{
            let explosioSeguence = SKAction.sequence([explosionSound, scaleIn,fadeOut, delete,loseALifeAction])
            explosion.run(explosioSeguence)
            
        }
    
        
        else{
            let explosioSeguence = SKAction.sequence([explosionSound, scaleIn,fadeOut, delete])
            explosion.run(explosioSeguence)
        }
       
        
    }
    
    
// Mark add fire Gun
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.name = "Bullet"
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
        
        if currentGameState == gameState.inGame{
            bullet.run(bulletSequence)
        }
    
    }
    
    //Missel do Inimigo
    func fireBulletEnemy(spawnPosition: CGPoint){
        let bullet = SKSpriteNode(imageNamed: "misselEnemy1")
        bullet.setScale(1)
        bullet.name = "MisselEnemy1"
        bullet.position = spawnPosition
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysiscsCategories.BulletEnemy
        bullet.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        bullet.physicsBody!.contactTestBitMask = PhysiscsCategories.Player
        self.addChild(bullet)

        let bulletSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet, deleteBullet])
        
        if currentGameState == gameState.inGame{
            bullet.run(bulletSequence)
        }
       

    }

    
    
    
    
    
    //Mark Add inemy
    
    func spawnEnemy(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        
        let  startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.3)
        let  endPoint = CGPoint(x: randomXEnd, y: self.size.height * 0.0)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        position = startPoint
        enemy.setScale(1)
        enemy.name = "Enemy"
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysiscsCategories.Emeny
        enemy.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        enemy.physicsBody!.contactTestBitMask = PhysiscsCategories.Player | PhysiscsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnenmy = SKAction.move(to: endPoint, duration: 2.3)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enenySeguence = SKAction.sequence([moveEnenmy, deleteEnemy])
        
        if currentGameState == gameState.inGame{
            enemy.run(enenySeguence)
        }
       
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRoutate = atan2(dy, dx)
        enemy.zRotation = amountToRoutate
        
        
    }
    
    
    func spawnNaveEstrela(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        let naveEstrelar = SKSpriteNode(imageNamed: "nave_estrelar")
        let  startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.5)
        let  endPoint = CGPoint(x: randomXEnd, y: self.size.height * 0.0)
        
      
        naveEstrelar.setScale(1)
        naveEstrelar.name = "NaveEstrelar"
        naveEstrelar.position = startPoint
        naveEstrelar.zPosition = 2
        naveEstrelar.physicsBody = SKPhysicsBody(rectangleOf: naveEstrelar.size)
        naveEstrelar.physicsBody!.affectedByGravity = false
        naveEstrelar.physicsBody!.categoryBitMask = PhysiscsCategories.NaveEstrelar
        naveEstrelar.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        naveEstrelar.physicsBody!.contactTestBitMask = PhysiscsCategories.Player | PhysiscsCategories.Bullet
        self.addChild(naveEstrelar)
        
        let moveEnenmy = SKAction.move(to: endPoint, duration: 3.8)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enenySeguence = SKAction.sequence([moveEnenmy, deleteEnemy])
        
        if currentGameState == gameState.inGame{
            naveEstrelar.run(enenySeguence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRoutate = atan2(dy, dx)
        naveEstrelar.zRotation = amountToRoutate
        
        
    }
    
    
    
    
    
    func meteorObject(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea) )
        
        let  startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.3)
        let  endPoint = CGPoint(x: randomXEnd, y: self.size.height * 0.0)
        
        
        let meteorSpriteNode = SKSpriteNode(imageNamed: "tile000")
        var meteorFrames = [SKTexture]()
        
        
        let textureAtlasMeteor =  SKTextureAtlas(named: "Meteor Frames")
        
        
        
        meteorSpriteNode.setScale(1)
        meteorSpriteNode.position = startPoint
        meteorSpriteNode.name = "Meteor"
        meteorSpriteNode.zPosition = 2
        meteorSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: meteorSpriteNode.size)
        meteorSpriteNode.physicsBody!.affectedByGravity = false
        meteorSpriteNode.physicsBody!.categoryBitMask = PhysiscsCategories.Meteor
        meteorSpriteNode.physicsBody!.collisionBitMask = PhysiscsCategories.Nome
        meteorSpriteNode.physicsBody!.contactTestBitMask = PhysiscsCategories.Player | PhysiscsCategories.Bullet
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
        
        
      
        if currentGameState == gameState.inGame{
            meteorSpriteNode.run(SKAction.repeatForever(SKAction.animate(with: meteorFrames, timePerFrame: 0.1)))
        }
        
    }
    
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            startGame()
        }
        
       else if currentGameState == gameState.inGame{
           if !loseLife{
               fireBullet()
           }
           
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //Mark get Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedUpDown = pointOfTouch.y - previousPointOfTouch.y
            
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
                player.position.y += amountDraggedUpDown
            }
           
            
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
