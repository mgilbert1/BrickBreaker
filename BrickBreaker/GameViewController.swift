//
//  GameViewController.swift
//  BrickBreaker
//
//  Created by Matthew Gilbert on 11/28/17.
//  Copyright © 2017 Matthew Gilbert. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate
{
    // Create the scene that will display the game
    var scene:GameScene!
    
    // Occurs when program is started
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new GameScene
        scene = GameScene(size: view.bounds.size)
        
        // Create a new view that contains a SpriteKit scene
        let skView = view as! SKView
        
        // How the view will be scaled on different screens
        // This is the default
        scene.scaleMode = .fill
        
        // Presents the scene
        skView.presentScene(scene)
    }
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // Change the x value of the paddle if the user drags the paddle or taps the screen
    @IBAction func didPan(_ sender: UIPanGestureRecognizer)
    {
        scene.setXPaddle(x: sender.location(in: self.view).x)
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer)
    {
        scene.setXPaddle(x: sender.location(in: self.view).x)
    }
}
