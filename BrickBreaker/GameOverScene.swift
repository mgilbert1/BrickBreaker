//
//  GameOverScene.swift
//  BrickBreaker
//
//  Created by Matthew Gilbert on 12/6/17.
//  Copyright © 2017 Matthew Gilbert. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene
{
    // Initialization of the scene
    init(size: CGSize, score: Int)
    {
        super.init(size: size)
        
        // Set up the background
        backgroundColor = SKColor.white
        
        // Set up the message label
        let label1 = SKLabelNode(fontNamed: "Menlo-Bold")
        label1.text = "Your score is: "
        label1.fontSize = 30
        label1.fontColor = SKColor.black
        label1.position = CGPoint(x: size.width/2, y: size.height/2 + label1.frame.height / 2.0 + 20)
        addChild(label1)
        
        // Set up the score label
        let label2 = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        label2.text = "\(score)"
        label2.fontSize = 70
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - label1.frame.height / 2.0 - 10)
        addChild(label2)
        
        // Display the message and the score, then display the GameScene again
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let reveal = SKTransition.crossFade(withDuration: 0.6)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // Required initializer
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
