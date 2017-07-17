//
//  CompletionView.swift
//  ProfileCompletionView
//
//  Created by 李玲 on 7/16/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import CoreMotion

class CircularView: UIView {
    var targetNum = 10

    private lazy var motionManager = CMMotionManager()
    fileprivate var drops:[Drop] = [Drop]()
    private var animator:UIDynamicAnimator!
    private var gravity = UIGravityBehavior()
    private var boundary = Boundary()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.width/2
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        boundary.frame = bounds
        var i = 0
        while i < targetNum {
            drops.append(createDrop())
            i += 1
        }
    }
    
    func add(){
        animate(false)
    }
    
    func start(){
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, err) in
            let rotation = atan2(motion!.gravity.x, motion!.gravity.y) - (Double.pi/2)
            guard abs(rotation) > 0.7 else { return }
            self.gravity.setAngle(CGFloat(rotation), magnitude: 0.1)
        }
        drops.forEach({$0.isHidden = false})
        animate(true)
    }
    
    private func animate(_ firstTime:Bool) {
        if !firstTime {
            let drop = createDrop()
            drop.isHidden = false
            drops.append(drop)
        }
        animator = UIDynamicAnimator(referenceView: self)
        gravity = UIGravityBehavior(items: drops)
        gravity.magnitude = 1
        
        let cb = UICollisionBehavior(items: drops)
        let path = UIBezierPath(ovalIn: boundary.frame)
        cb.addBoundary(withIdentifier: "Circular" as NSCopying, for: path)
        
        let bounce = UIDynamicItemBehavior(items: drops)
        bounce.elasticity = 0.8
        
        animator?.addBehavior(gravity)
        animator?.addBehavior(cb)
        animator?.addBehavior(bounce)
    }
    
    private func createDrop()->Drop{
        let frame = CGRect(x: bounds.width/2-12, y: 0, width: 24, height: 24)
        let drop = Drop(frame: frame)
        drop.isHidden = true
        drop.backgroundColor = UIColor(colorLiteralRed: Float(arc4random_uniform(240) + 5)/255.0,
                                       green: Float(arc4random_uniform(140) + 105)/255.0,
                                       blue: Float(arc4random_uniform(240) + 5)/255.0,
                                       alpha: 1)
        self.addSubview(drop)
        return drop
    }
    
}

fileprivate class Drop: UIView {
    
    private init(){
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Create an cicular boundry
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}

fileprivate class Boundary: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: 1, dy: 1))
        path.lineWidth = bounds.width/2
        UIColor.lightGray.setStroke()
        UIColor.blue.setFill()
        path.stroke()
        path.fill()
    }
}
