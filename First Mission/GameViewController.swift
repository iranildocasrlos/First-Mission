//
//  GameViewController.swift
//  First Mission
//
//  Created by Iranildo C Silva on 16/09/22.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var soundTema = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "soundSpace", ofType: "mp3")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        
        do {
            soundTema = try AVAudioPlayer(contentsOf: audioNSURL as URL)
        }catch{
            return print("Cannot Find The Audio")
        }
        
        soundTema.numberOfLoops = -1
        soundTema.play()
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
           
            let scene = MainManuScene(size: CGSize(width: 1536, height: 2048))
            
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
         
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
