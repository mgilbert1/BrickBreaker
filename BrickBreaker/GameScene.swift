//
//  GameScene.swift
//  BrickBreaker
//
//  Created by Matthew Gilbert on 11/28/17.
//  Copyright © 2017 Matthew Gilbert. All rights reserved.
//

// Library that provides access to SKSpriteNodes and the physics engine
import SpriteKit

// The paddle node
let paddle = SKSpriteNode(imageNamed: "the paddle")

// Converts direction into the proper orientation and to radians so that sin and cos evaluate correctly
prefix func ~ (right: Double) -> Double
{
    let radians = (90 - right) * Double.pi / 180.0
    return radians
}

// From tutorial: https://www.raywenderlich.com/145318/spritekit-swift-3-tutorial-beginners
// Allows CGPoints to be added together
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

// Physics Categories of all the objects
struct PhysicsCategory
{
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Ball     : UInt32 = 0b1
    static let Brick    : UInt32 = 0b10
    static let Paddle   : UInt32 = 0b100
    static let EdgeS    : UInt32 = 0b1000
    static let EdgeT    : UInt32 = 0b10000
    static let EdgeB    : UInt32 = 0b100000
    static let Edge     : UInt32 = 0b111000
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Direction of the ball
    // 0 is up, 90 right, 180 down, 270 left
    var ball_direction = 0.0
    
    // Level: determines how often bricks are added
    var level = 0
    
    // Speed of the ball (lower is faster)
    var ball_time = 15.0
    
    // User's current score
    var score = 0
    
    // Size of the objects
    var ball_size = CGSize()
    var brick_size = CGSize()
    var paddle_size = CGSize()
    
    // Array of all the bricks onscreen
    var bricks: [SKSpriteNode] = []
    
    // Number of bricks in each row
    let bricks_per_row = 7
    
    // True if a new row of bricks should be added, false otherwise
    var time_to_add_bricks = false
    
    // Initialize the objects (besides the paddle)
    let ball = SKSpriteNode(imageNamed: "ball")
    let edge_left = SKSpriteNode(imageNamed: "edge")
    let edge_right = SKSpriteNode(imageNamed: "edge")
    let edge_top = SKSpriteNode(imageNamed: "edge")
    let edge_bottom: SKSpriteNode = SKSpriteNode(imageNamed: "edge")
    
    // Initialize the score, level, and game over labels
    let score_label = SKLabelNode(fontNamed: "Menlo-Bold")
    let level_label = SKLabelNode(fontNamed: "Menlo-Bold")
    let game_over = SKLabelNode(fontNamed: "GillSans-UltraBold")
    
    // True if the game is over, false otherwise
    var game_is_over = false
    
    // Called as soon as scene is presented by a view
    override func didMove(to view: SKView)
    {
        // Reset variables
        level = 0
        ball_time = 15.0
        score = 0
        
        // Set up background
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.scale(to: size)
        addChild(background)
        
        // Set up physics
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        // Set up bricks
        let brick_width = (Double)(size.width - 15) / (Double)(bricks_per_row + 2) // = 40
        let brick_height = (Double)(size.height - 7) / 33.0 // = 20
        brick_size = CGSize(width: brick_width, height: brick_height)
        
        // Set up paddle
        paddle.position = CGPoint(x: size.width / 2.0, y: size.height / 3.0)
        let paddle_width = (Double)(size.width) / 6.0
        let paddle_height = (Double)(size.height) / 50.0
        paddle_size = CGSize(width: paddle_width, height: paddle_height)
        paddle.scale(to: paddle_size)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddle.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(paddle)
        
        // Set up edges of the playable area
        var edge_position = CGPoint(x: -1, y: size.height / 2.0)
        var edge_size = CGSize(width: 1, height: size.height)
        
        edge_left.position = edge_position
        edge_left.scale(to: edge_size)
        edge_left.physicsBody = SKPhysicsBody(rectangleOf: edge_size)
        edge_left.physicsBody?.isDynamic = false
        edge_left.physicsBody?.categoryBitMask = PhysicsCategory.EdgeS
        edge_left.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        edge_left.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        edge_position = CGPoint(x: size.width + 1, y: size.height / 2.0)
        
        edge_right.position = edge_position
        edge_right.scale(to: edge_size)
        edge_right.physicsBody = SKPhysicsBody(rectangleOf: edge_size)
        edge_right.physicsBody?.isDynamic = false
        edge_right.physicsBody?.categoryBitMask = PhysicsCategory.EdgeS
        edge_right.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        edge_right.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        edge_position = CGPoint(x: size.width / 2.0, y: size.height - 3 * CGFloat(brick_height) / 2.0)
        edge_size = CGSize(width: size.width, height: 3 * CGFloat(brick_height))
        
        edge_top.position = edge_position
        edge_top.scale(to: edge_size)
        edge_top.physicsBody = SKPhysicsBody(rectangleOf: edge_size)
        edge_top.physicsBody?.isDynamic = false
        edge_top.physicsBody?.categoryBitMask = PhysicsCategory.EdgeT
        edge_top.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        edge_top.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        edge_position = CGPoint(x: size.width / 2.0, y: size.height / 6.0 - CGFloat(brick_height))
        edge_size = CGSize(width: size.width, height: size.height / 3.0)

        edge_bottom.position = edge_position
        edge_bottom.scale(to: edge_size)
        edge_bottom.physicsBody = SKPhysicsBody(rectangleOf: edge_size)
        edge_bottom.physicsBody?.isDynamic = false
        edge_bottom.physicsBody?.categoryBitMask = PhysicsCategory.EdgeB
        edge_bottom.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        edge_bottom.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(edge_left)
        addChild(edge_right)
        addChild(edge_top)
        addChild(edge_bottom)
       
        // Set up ball
        ball.position = CGPoint(x: size.width * 0.5, y: size.height / 3.0 + (CGFloat)(paddle_height))
        let ball_diameter = (Double)(size.width) / 30.0
        ball_size = CGSize(width: ball_diameter, height: ball_diameter)
        ball.scale(to: ball_size)
       
        ball.physicsBody = SKPhysicsBody(circleOfRadius: (CGFloat)(ball_diameter / 2.0))
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Brick + PhysicsCategory.Paddle + PhysicsCategory.Edge
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(ball)
        
        // Set up labels
        level_label.text = "Level: \(level)"
        level_label.fontSize = 20
        level_label.fontColor = SKColor.black
        level_label.horizontalAlignmentMode = .left
        level_label.position = CGPoint(x: size.width - 125, y: size.height - edge_top.size.height * 2.0 / 3.0)
        addChild(level_label)
        
        score_label.text = "Score: \(score)"
        score_label.fontSize = 20
        score_label.fontColor = SKColor.black
        score_label.horizontalAlignmentMode = .left
        score_label.position = CGPoint(x: 25, y: size.height - edge_top.size.height * 2.0 / 3.0)
        addChild(score_label)
        
        game_over.text = "GAME OVER"
        game_over.fontSize = 50
        game_over.fontColor = SKColor.white
        game_over.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        // Add four rows of bricks to start
        for _ in 0...5
        {
            addRowOfBricks()
        }
        
        // Choose a random starting direction from 355 (aka -5) to 5
        ball_direction = (Double)(arc4random_uniform(200)) / 10.0 - 5
        
        // Move the paddle back to the middle
        paddle.run(SKAction.move(to: CGPoint(x: size.width / 2.0, y: size.height / 3.0), duration: 0))
        
        // Increase level, and update the level label and ball speed every 30 seconds
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({ () in self.level += 1; self.level_label.text = "Level: \(self.level)"; self.ball_time -= 1; self.ball_time = max(self.ball_time, 7) }),
                SKAction.wait(forDuration: 30.0)
                ])
        ))
        
        // Add a new row of bricks at increasingly small time intervals
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({ () in self.time_to_add_bricks = true}),
                SKAction.wait(forDuration: (Double)(max((20 - level) / 3, 2)))
                ])
        ))
        
        // Start the inital motion of the ball
        moveBall()
    }
    
    // Add a new row of bricks
    // If the bricks come too close to the paddle, end the game
    func addRowOfBricks()
    {
        // Move the existing bricks down one spot
        var bricks_too_low = false
        for brick in bricks
        {
            brick.removeFromParent()

            brick.position.y -= brick.size.height + 3
            //print(level)
            
           // let brick2 = brick
            //brick2.position.y -= brick.size.height - 3
            addChild(brick)
            
            if brick.position.y < paddle.position.y + brick.size.height
            {
                bricks_too_low = true
            }
        }
        
        // Add a new row of bricks
        for i in 0...bricks_per_row - 1
        {
            // Random number generator to determine if a brick should be added
            // As level increases, more bricks are added
            if arc4random_uniform(30) > (UInt32)(ball_time)
            {
                let brick = SKSpriteNode(imageNamed: "brick")
                let x = 37 + (brick_size.width + 3) * CGFloat((Double)(i) + 0.5)
                let y = size.height - (brick_size.height + 3) * 4.0
                brick.position = CGPoint(x: x, y: y);
                brick.scale(to: brick_size)
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.categoryBitMask = PhysicsCategory.Brick
                brick.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
                brick.physicsBody?.usesPreciseCollisionDetection = true
                brick.physicsBody?.collisionBitMask = PhysicsCategory.None
                addChild(brick)
                bricks.append(brick)
            }
        }
        
        if bricks_too_low
        {
            endGame()
        }
    }
    
    // Move the paddle side-to-side
    func setXPaddle(x: CGFloat)
    {
        if !game_is_over
        {
            paddle.run(SKAction.moveTo(x: x, duration: 0))
        }
    }
    
    // Move the ball according to ball_direction
    func moveBall()
    {
        if !game_is_over
        {
            let move_by = CGFloat(2000)
            let destination = ball.position + CGPoint(x: move_by * CGFloat(cos(~ball_direction)), y: move_by * CGFloat(sin(~ball_direction)))
            ball.run(SKAction.move(to: destination, duration: ball_time))
        }
    }
    
    // If contact occurs between any PhysicsBody's
    // Should only be called if the ball made contact with something
    // The ball can make contact with: 1) a single brick; 2) 2+ bricks; 3) an edge; 4) the paddle; 5) 2 edges; or 6) the paddle and an edge 
    func didBegin(_ contact: SKPhysicsContact)
    {
        // Stop the movement of the ball
        ball.removeAllActions()
        
        // Ensure the direction is between 0 and 360
        fixDirection()
        
        // The PhysicsBody that the ball made contact with
        var otherPB: SKPhysicsBody
        if contact.bodyA.categoryBitMask == PhysicsCategory.Ball
        {
            otherPB = contact.bodyB
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Ball
        {
            otherPB = contact.bodyA
        }
        else
        {
            // Only occurs two bodies, neither of which is the ball, have made contact, which should be impossible
            fatalError("Something has gone terribly wrong")
        }
        
        // If the ball made contact with a brick
        if otherPB.categoryBitMask == PhysicsCategory.Brick
        {
          //  print("\tbrick   \(String(describing: ball.physicsBody?.allContactedBodies().count))")
            
            // If the ball hit two bricks
            if ball.physicsBody?.allContactedBodies().count != 1
            {
                ballHitManyBricks()
            }
            // If the ball hit one brick
            else
            {
                ballHitOneBrick(brick: (otherPB.node as? SKSpriteNode)!)
            }
        }
            
        // If the ball hit the paddle
        else if otherPB.categoryBitMask == PhysicsCategory.Paddle
        {
           // print("\tpaddle")
            ballHitPaddle()
        }
            
        // If the ball hit an edge
        else
        {
           // print("\tedge")
            ballHitEdge(edge: otherPB)
        }
        
        // If the direction of the ball is too flat, change it slightly
        // Otherwise the ball would move back to the paddle too slowly
        if (ball_direction < 90 && ball_direction > 75) || (ball_direction < 270 && ball_direction > 255)
        {
            ball_direction -= 15
        }
        else if (ball_direction >= 90 && ball_direction < 105) || (ball_direction >= 270 && ball_direction < 285)
        {
            ball_direction += 15
        }
        
        // Move the ball in the newly calculated direction
        moveBall()
    }
    
    // If the ball made contact with only one brick and nothing else
    func ballHitOneBrick(brick: SKSpriteNode)
    {
        // The coordinates of the ball and the brick
        let ball_x = ball.position.x
        let ball_y = ball.position.y
        let brick_x = brick.position.x
        let brick_y = brick.position.y
        
        // True if the ball hit the top or bottom of a brick, false otherwise
        var hit_top_or_bottom = false
        
        // True if the ball hit the side of a brick, false otherwise
        var hit_side = false
        
        // Check if the ball hit the top or bottom of the brick
        if ball_x + ball.size.height / 4.0 > brick_x - brick_size.width / 2.0 && ball_x - ball.size.height / 4.0 < brick_x + brick_size.width / 2.0
        {
            // Check if the ball_direction and the y position of the ball are correct for it to be possible that the ball is hitting the bottom of the brick
            if (ball_y < brick_y - brick_size.height * 3.0 / 8.0 && (ball_direction < 90 || ball_direction > 270)) || (ball_y > brick_y + brick_size.height * 3.0 / 8.0 && ball_direction > 90 && ball_direction < 270)
            {
                hit_top_or_bottom = true
            }
        }
        
        // Check if the ball hit the side of the brick
        if ball_y + ball.size.height / 4.0 > brick_y - brick_size.height / 2.0 && ball_y - ball.size.height / 4.0 < brick_y + brick_size.height / 2.0
        {
            // Check if the ball_direction and the x position of the ball are correct for it to be possible that the ball is hitting the bottom of the brick
            if (ball_x < brick_x - brick_size.width * 3.0 / 8.0 && ball_direction < 180 && ball_direction > 0) || (ball_x > brick_x + brick_size.width * 3.0 / 8.0 && ball_direction < 360 && ball_direction > 180)
            {
                hit_side = true
            }
        }
        
        // If the ball hit the side and the top or bottom or neither, the ball must have hit the corner
        if hit_side == hit_top_or_bottom
        {
            // Check which corner the ball made contact with
            // Also check if the ball_direction implies that the ball actually did hit the side or bottom
            
            if ball_x < brick_x && ball_y > brick_y
            {
                if ball_direction <= 45
                {
                    ball_direction = 360 - ball_direction
                }
                else if ball_direction >= 225
                {
                    ball_direction = 180 - ball_direction
                }
                else
                {
                    ball_direction = 90 - ball_direction
                }
            }
            else if ball_x > brick_x && ball_y < brick_y
            {
                if ball_direction <= 225 && ball_direction > 180
                {
                   // print("\tbside")
                    ball_direction = 360 - ball_direction
                }
                else if ball_direction >= 45 && ball_direction < 90
                {
                    //print("\ttb")
                    ball_direction = 180 - ball_direction
                }
                else
                {
                    ball_direction = 90 - ball_direction
                }
            }
            else if ball_x > brick_x && ball_y > brick_y
            {
                if ball_direction <= 135 && ball_direction > 90
                {
                   // print("\ttb")
                    ball_direction = 180 - ball_direction
                }
                else if ball_direction >= 315 // && ball_direction < 360
                {
                   // print("\tbside")
                    ball_direction = 360 - ball_direction
                }
                else
                {
                    ball_direction = 270 - ball_direction
                }
            }
            else // if ball_x < brick_x && ball_y < brick_y
            {
                if ball_direction <= 315 && ball_direction > 270
                {
                    //print("\ttb")
                    ball_direction = 180 - ball_direction
                }
                else if ball_direction >= 135 && ball_direction < 180
                {
                    //print("\tbside")
                    ball_direction = 360 - ball_direction
                }
                else
                {
                    ball_direction = 270 - ball_direction
                }
            }
        }
            
        // If the ball hit the top or bottom
        else if hit_top_or_bottom
        {
            ball_direction = 180 - ball_direction
        }
            
        // If the ball hit a side
        else
        {
            ball_direction = 360 - ball_direction
        }

        // Increase the score
        score += level * 100
        self.score_label.text = "Score: \(score)"
        
        // Remove the brick hit by the ball
        bricks.remove(at: bricks.index(of: brick)!)
        brick.removeFromParent()
    }
    
    // If the ball hit multiple bricks at one time
    func ballHitManyBricks()
    {
        // Assemble a list of all the bricks the ball has made contact with, and the average coordinate of the bricks
        var bodies: [SKPhysicsBody] = []
        var avg_x = 0.0
        var avg_y = 0.0
        for body in (ball.physicsBody?.allContactedBodies())!
        {
            bodies.append(body)
            avg_x += (Double)((body.node?.position.x)!)
            avg_y += (Double)((body.node?.position.y)!)
        }
        avg_x /= (Double)(bodies.count)
        avg_y /= (Double)(bodies.count)
        
        if bodies.count > 0
        {
            // If all the bricks have the same x value, treat the ball as if it hit the top or bottom of a brick
            if (Double)((bodies[0].node?.position.x)!) == avg_x
            {
                ball_direction = 360 - ball_direction
            }
            // If all the bricks have the same y value, treat the ball as if it hit the side of a brick
            else if (Double)((bodies[0].node?.position.y)!) == avg_y
            {
                ball_direction = 180 - ball_direction
            }
            // Otherwise the ball must have hit in the corner of two bricks
            else
            {
                ball_direction = (Double)((Int)(ball_direction) / 90 * 90 + 225)
            }
            
            // Remove all the bricks that the ball made contact with and update the score
            for body in bodies
            {
                self.score_label.text = "Score: \(score)"
                score += level * 100
                bricks.remove(at: bricks.index(of: body.node as! SKSpriteNode)!)
                body.node?.removeFromParent()
            }
        }
    }
    
    // If the ball hit the paddle
    func ballHitPaddle()
    {
        // Add bricks only when the ball has made contact with the paddle to avoid any awkward collisions that would occur otherwise
        if time_to_add_bricks
        {
            addRowOfBricks()
            time_to_add_bricks = false
        }

        // If the ball is not below the paddle
        if ball.position.y - ball.size.height / 4.0 > paddle.position.y
        {
            ball_direction = (Double)((ball.position.x - paddle.position.x) / paddle_size.width * 100)
            
            // If the ball also hit an edge
            if ball.physicsBody?.allContactedBodies().count != 1
            {
                // If the ball is about to go off the screen, change the direction back onto the screen
                if (ball.position.x > size.width / 2.0 && ball_direction < 180 && ball_direction > 0) || ( ball.position.x < size.width / 2.0 && ball_direction < 360 && ball_direction > 180)
                {
                        ball_direction = 360 - ball_direction
                }
            }
        }
    }
    
    // If the ball made contact with an edge
    func ballHitEdge(edge: SKPhysicsBody)
    {
        // If the ball hit the bottom edge, end the game
        if (ball.physicsBody?.allContactedBodies().contains(edge_bottom.physicsBody!))!
        {
            endGame()
        }
            
        // If the ball hit multiple edges and it is above the paddle, it must have hit one of the two top corners
        // Set the direction to the correct 45 degree angle for each case
        else if ball.physicsBody?.allContactedBodies().count != 1 && ball.position.y > size.height / 2.0
        {
            if ball.position.x > size.width / 2.0
            {
                ball_direction = 225
            }
            else
            {
                ball_direction = 135
            }
        }
        
        // If the ball hit just one edge
        else
        {
            // If the ball hit a side edge
            if edge.categoryBitMask == PhysicsCategory.EdgeS
            {
                ball_direction = 360 - ball_direction
            }
            // If the ball hit the top edge
            else
            {
                ball_direction = 180 - ball_direction
            }
        }
    }
    
    // End the current game
    func endGame()
    {
        game_is_over = true

        // Stop the motion of the ball
        ball.removeAllActions()
        
        // I had some errors with game_over specifically, so I added this special case to remove it before I add it again
        if game_over.parent != nil
        {
            game_over.removeFromParent()
        }
        addChild(game_over)
        
        // Display game over, then display the score
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run({
                self.bricks.removeAll()
                self.removeAllChildren()
                let reveal = SKTransition.crossFade(withDuration: 0.6)
                let gameOverScene = GameOverScene(size: self.size, score: self.score)
                self.view?.presentScene(gameOverScene, transition: reveal)
                })
        ]))
        game_is_over = false
    }
    
    // Ensure the direction of the ball is in between 0 and 360
    func fixDirection()
    {
        while ball_direction >= 360
        {
            ball_direction -= 360
        }
        while ball_direction < 0
        {
            ball_direction += 360
        }
    }
}
