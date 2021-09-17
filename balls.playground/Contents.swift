import PlaygroundSupport
import UIKit

//ball.swift
protocol BallProtocol {
    init(color: UIColor, radius: Int, coordinates: (x: Int, y: Int))
}

public class Ball: UIView, BallProtocol {
    required public init(color: UIColor, radius: Int, coordinates: (x:Int, y: Int)) {
        // создание графического прямоугольника
        super.init(frame:
            CGRect(x: coordinates.x,
                   y: coordinates.y,
                   width: radius * 2,
                   height: radius * 2))
        // скругление углов
        self.layer.cornerRadius = self.bounds.width / 2.0
        // изменение цвета фона
        self.backgroundColor = color
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//end of ball.swift

//squarearena.swift
protocol SquareArenaProtocol {
    init(size: CGSize, color: UIColor)
    func setBalls(withColors: [UIColor], andRadius: Int)
}

class SquareArea: UIView, SquareArenaProtocol {
    private var balls: [Ball] = []
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    private var collisionBehavior: UICollisionBehavior
    
    required public init(size: CGSize, color: UIColor) {
        collisionBehavior = UICollisionBehavior(items: [])
        super.init(frame:
                    CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.backgroundColor = color
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        animator = UIDynamicAnimator(referenceView: self)
        animator?.addBehavior(collisionBehavior)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setBalls(withColors ballsColor: [UIColor], andRadius radius: Int) {
        for (index, oneBallColor) in ballsColor.enumerated() {
               // рассчитываем координаты левого верхнего угла шарика
               let coordinateX = 10 + (2 * radius) * index
               let coordinateY = 10 + (2 * radius) * index
               // создаем экземпляр сущности "Шарик"
               let ball = Ball(color: oneBallColor,
                               radius: radius,
                               coordinates: (x: coordinateX, y: coordinateY))
            self.addSubview(ball)
            self.balls.append(ball)
            collisionBehavior.addItem(ball)
        }
    }
    override public func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touches = touches.first {
            let touchLocation = touches.location(in: self)
            for ball in balls {
                if (ball.frame.contains(touchLocation)) {
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.9
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}


// end of squarearena.swift

let sizeOfArea = CGSize(width: 400, height: 400)
var area = SquareArea(size: sizeOfArea, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
PlaygroundPage.current.liveView = area

area.setBalls(withColors: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)], andRadius: 25)
