//
//  GameScene.swift
//  week_five_game
//
//  Created by Alireza Moghaddam on 2019-05-30.
//  Copyright © 2019 Alireza. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreData


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var user = User()
    var currentUser = ""
    
    let none      : UInt32 = 0
    let all       : UInt32 = UInt32.max
    let playerCategory    : UInt32 = 0b1       // 1
    let ballsCategory      : UInt32 = 0b10
    
    var scoreLabel : SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var iterator = 1
    var livesLabel : SKLabelNode!
    var lives: Int = 3
    
    var back: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var gameOver: Bool = false
    
    var previousPan:CGPoint = CGPoint.zero
    var panXDiff: CGFloat?
    var panYDiff: CGFloat?
    
    let player = SKSpriteNode(imageNamed: "frame-1")
    
    var timer: Timer?
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background.jpeg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.setScale(1.1)
        addChild(background)
        
        currentUser = self.userData?.value(forKey: "currentUser") as! String
        print("currentUser is :\(currentUser)")
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addScore), userInfo: nil, repeats: true)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) /* #000000 */
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        addChild(scoreLabel)
        
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.text = "❤️❤️❤️"
        livesLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) /* #000000 */
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.position = CGPoint(x: size.width * 0.4, y: size.height * 0.9)
        addChild(livesLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) /* #000000 */
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameOverLabel.setScale(2)
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        back = SKLabelNode(fontNamed: "Chalkduster")
        back.name = "back"
        back.text = "Back"
        back.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) /* #000000 */
        back.horizontalAlignmentMode = .center
        back.position = CGPoint(x: size.width * 0.5, y: size.height * 0.4)
        back.setScale(2)
        back.isHidden = true
        addChild(back)
        
        
        // 2
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = ballsCategory
        player.physicsBody?.collisionBitMask = none
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.setScale(0.5)
        // 4
        addChild(player)
        
        let panRec = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        panRec.minimumNumberOfTouches = 1
        self.view!.addGestureRecognizer(panRec)
        
       run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBall),SKAction.wait(forDuration: 1.0)])))
       run(SKAction.repeatForever(SKAction.sequence([SKAction.run(animatePlayer),SKAction.wait(forDuration: 0.5)])))
    }
    //player animation while running
    func animatePlayer(){
        //To animate the images
        player.texture = SKTexture(imageNamed: "frame-\(iterator).png")
        iterator += 1
        if (iterator == 5){
            iterator = 1
        }
    }
  //ball to player collision handling
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        let player1 = firstBody.node as! SKSpriteNode
        let ball = secondBody.node as! SKSpriteNode
        ballDidCollideWithPlayer(ball: ball, player: player1)
        
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    //removes a node
    func remove(node: SKSpriteNode) {
        node.removeFromParent()
    }
    //random number helper function
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    //random number helper function
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    //adds balls using the random number helper functions for ball spawn
    func addBall() {
        // Create sprite
        let ball = SKSpriteNode(imageNamed: "ball.png")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) // 1
        ball.physicsBody?.isDynamic = true // 2
        ball.physicsBody?.categoryBitMask = ballsCategory  // 3
        ball.physicsBody?.contactTestBitMask = playerCategory  // 4
        ball.physicsBody?.collisionBitMask = none // 5
        ball.setScale(0.3)
        
        // Determine where to spawn the ball along the Y axis
        let actualX = random(min: 50, max: size.width - 50)
        
        // Position the ball slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        ball.position = CGPoint(x: actualX , y: size.height + 50)
        
        // Add the ball to the scene
        addChild(ball)
        
        // Determine speed of the ball
        let actualDuration = random(min: CGFloat(7.0), max: CGFloat(8.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -size.height/2.5),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ball.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    //player movement follows finger while panning
    @objc func panned(sender:UIPanGestureRecognizer) {
        var touchLocation:CGPoint = sender.location(in: self.view!)
        
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        if (sender.state == .changed) {
            
            //panning is occuring
            if ( previousPan != CGPoint.zero) {
        
                //if previousPan has been set, this can run
                panXDiff = touchLocation.x - previousPan.x
                panYDiff = touchLocation.y - previousPan.y
                
                //replace node below with the name of the sprite you want to move
                player.position = CGPoint( x: player.position.x + panXDiff!, y: player.position.y + panYDiff! )
                
            }
            //save the location to previousPan to be used the next frame of panning
            previousPan = touchLocation
            }
            else  if (sender.state == .ended ) {
            
                //panning ended, so reset previousPan to 0,0
                previousPan = CGPoint.zero
            
            }
    }
    //removes lives when ball nad player colide, removes ball from scene, saves score when dead
    func ballDidCollideWithPlayer(ball: SKSpriteNode, player: SKSpriteNode) {
        print(lives)
        if(lives == 3){
            lives = lives - 1;
            print(lives)
            livesLabel.text = "❤️❤️"
        }
        else if(lives == 2){
            lives = lives - 1;
            livesLabel.text = "❤️"
        }
        else if(lives == 1 || lives == 0 ){
            lives = lives - 1;
            livesLabel.text = ""
        
            //game over, show hidden menu and terminate actions and timers
            timer?.invalidate()
            timer = nil
            self.removeAllActions()
            gameOverLabel.isHidden = false
            back.isHidden = false
            
            //save user high score
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", currentUser)
            
            do {
                let user1 = try PersistenceServce.context.fetch(fetchRequest)
                self.user = user1[0]
                if(self.user.score < score){
                    self.user.setValue(Int32(score),forKey: "score")
                    PersistenceServce.saveContext()
                }
                else{
                    print("Not high score")
                }
                
            } catch {}
            
        }
        
        ball.removeFromParent()
    }
    
    @objc func addScore(){
        score = score + 1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "back" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "VC")
                
                vc.view.frame = (self.view?.frame)!
                
                vc.view.layoutIfNeeded()
                
                
                
                UIView.transition(with: self.view!, duration: 0.3, options: .transitionFlipFromRight, animations:
                    
                    {
                        
                        self.view?.window?.rootViewController = vc
                        
                }, completion: { completed in
                    
                    
                    
                })
            
                
            }
        }
    }
    

}
