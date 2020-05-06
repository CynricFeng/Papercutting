import Foundation
import SpriteKit
import AppKit

public class WelcomeScene: SKScene {
    
    private let scissors        = SKLabelNode(text: "✂️")
    private let topScreen       = SKSpriteNode(imageNamed: "bgu.jpg", normalMapped: false)
    private let buttomScreen    = SKSpriteNode(imageNamed: "bgd.jpg", normalMapped: false)
    private let cutIntro        = SKLabelNode(text: "Pick up the scissors. Cut along the dotted line.")
    
    private let startInfo       = SKLabelNode(text: "ENJOY   THE PAPER CUTTING ART")
    
    public let nextScene        = PaperCutScene()
    public var compareImageName = ""
    
    private var drag            = false
    private var scissorsFixes   = false
    
    public override func didMove(to view: SKView) {
        // set the basic area size and position
        self.backgroundColor = #colorLiteral(red: 0.8305695653, green: 0.5260531902, blue: 0.5703055263, alpha: 1)
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        self.view?.layer?.cornerRadius = 5
        loadTheNodes()
    }
    
    public func loadTheNodes() {
        
        startInfo.position = CGPoint(x: UIConfig.backgroundSize.width / 2, y: UIConfig.backgroundSize.height / 5)
        startInfo.numberOfLines = 3
        startInfo.preferredMaxLayoutWidth = CGFloat(UIConfig.backgroundSize.width * 3 / 4)
        startInfo.numberOfLines = 3
        startInfo.fontSize = 70
        startInfo.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        startInfo.name = "startInfo"
        startInfo.fontName = "Helvetica Neue Bold Italic"
        
        addChild(startInfo)
        
        topScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 3 / 4)
        topScreen.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height / 2))
        topScreen.name = "topScreen"
        addChild(topScreen)
        
        buttomScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 4)
        buttomScreen.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height / 2))
        buttomScreen.name = "buttomScrenn"
        addChild(buttomScreen)
        
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0), .fadeOut(withDuration: 2.0)])
        cutIntro.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 8)
        cutIntro.fontSize = CGFloat(20)
        cutIntro.fontColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        cutIntro.name = "cutIntro"
        cutIntro.fontName = "Futura Medium Italic"
        cutIntro.run(.repeatForever(fadeInOut))
        addChild(cutIntro)
        
        scissors.position = CGPoint(x: UIConfig.backgroundSize.width / 2, y: UIConfig.backgroundSize.height * 1 / 4)
        scissors.fontSize = 50
        scissors.zRotation = .pi / 2
        scissors.name = "scissors"
        addChild(scissors)
        
        
    }
    
    private func disLoadNodes() {
        scissors.isHidden = true
        cutIntro.isHidden = true
        
        nextScene.compareImageName = compareImageName
        
        let view = self.view
        
        let waitTime = SKAction.wait(forDuration: 5)
        let nextAction = SKAction.run {
            self.removeAllChildren()
            view?.presentScene(self.nextScene)
        }
        self.run(SKAction.sequence([waitTime, nextAction]))
    }
    

    public override func mouseDown(with event: NSEvent) {
        if abs(event.location(in: self).x - scissors.position.x) < 30,
            abs(event.location(in: self).y - scissors.position.y) < 45 {
            drag = true
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        if scissorsFixes == true {
            scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
        }
        drag = false
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard drag else {
            return
        }
        
        let position = event.location(in: self)
        
        if scissorsFixes == false {
            let position = event.location(in: self)
            scissors.position = CGPoint(x: position.x, y:  position.y)
            
            if abs(position.y - UIConfig.backgroundSize.height / 2) < 30 {
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissorsFixes = true
                drag = false
            }
        }
        else {
            scissors.position = CGPoint(x: position.x, y: UIConfig.backgroundSize.height / 2)
            
            if abs(position.x - UIConfig.backgroundSize.width) < 20 {
                let topVector = CGVector(dx: 0, dy: CGFloat(100000))
                let buttomVector = CGVector(dx: 0, dy: CGFloat(-100000))
                
                topScreen.physicsBody = SKPhysicsBody(rectangleOf: self.topScreen.frame.size)
                topScreen.physicsBody?.isDynamic = true
                topScreen.physicsBody?.affectedByGravity = false
                topScreen.physicsBody?.applyForce(topVector, at: CGPoint(x: topScreen.frame.size.width, y: UIConfig.backgroundSize.height / 2))
                
                buttomScreen.physicsBody = SKPhysicsBody(rectangleOf: self.buttomScreen.frame.size)
                buttomScreen.physicsBody?.isDynamic = true
                buttomScreen.physicsBody?.affectedByGravity = false
                buttomScreen.physicsBody?.applyForce(buttomVector, at: CGPoint(x: buttomScreen.frame.size.width, y: UIConfig.backgroundSize.height / 2))
                
                self.disLoadNodes()
            }
        }
        
    }
}
