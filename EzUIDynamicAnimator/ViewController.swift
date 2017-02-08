//
//  ViewController.swift
//  EzUIDynamicAnimator
//
//  Created by iOS Student on 2/3/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    var ball = UIImageView()
    var animator = UIDynamicAnimator()
    var attachmentBehavior: UIAttachmentBehavior!
    var pushBehavior : UIPushBehavior!
    var gravityBehavior: UIGravityBehavior!
    @IBOutlet weak var brickV1: UIView!
    @IBOutlet weak var brickV2: UIView!
    @IBOutlet weak var brickV3: UIView!
    @IBOutlet weak var brickV4: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ball = UIImageView(frame: CGRect(x: 200, y: 500, width: 40, height: 40))
        self.ball.image = UIImage(named:"ball.png")
        self.view.addSubview(self.ball)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)

        //self.gravityBehavior = UIGravityBehavior(items: [self.ball])
        //gravityBehavior.angle = -2
        //gravityBehavior.magnitude = 0
        //gravityBehavior.gravityDirection = CGVector(dx: -0.5, dy: 1)
        //animator.addBehavior(gravityBehavior)

        //collision
        let collisionBehavior = UICollisionBehavior(items: [self.ball,self.brickV1,self.brickV2,self.brickV3,self.brickV4])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)

        //attach
        attachmentBehavior = UIAttachmentBehavior(item: self.ball, attachedToAnchor: self.ball.center)

        //push
        self.pushBehavior = UIPushBehavior(items: [self.ball], mode: UIPushBehaviorMode.continuous)
        //self.animator.addBehavior(self.pushBehavior)

        //UIdynamicItemBehavior
        let ballProperty = UIDynamicItemBehavior(items: [self.ball])
        ballProperty.elasticity = 0.5
        ballProperty.angularVelocity(for: self.ball)
        self.animator.addBehavior(ballProperty)


        //Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view.addGestureRecognizer(panGesture)
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print("began:\(behavior.boundaryIdentifiers)")
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("ended:\(identifier)")
    }

    func handlePan(gesture: UIPanGestureRecognizer){

        let p = gesture.location(in: self.view)
        let o = self.ball.center

        if gesture.state == UIGestureRecognizerState.began {
            attachmentBehavior.anchorPoint = gesture.location(in: self.view)
            attachmentBehavior.damping = 500.0
            animator.addBehavior(attachmentBehavior)
        }
        else if gesture.state == UIGestureRecognizerState.changed {
            attachmentBehavior.anchorPoint = gesture.location(in: self.view)
        }
        else if gesture.state == UIGestureRecognizerState.ended {
            //release attachment to push
            animator.removeBehavior(attachmentBehavior)

            //push
            let distance = sqrtf(powf(Float(p.x) - Float(o.x), 2.0) + powf(Float(p.y) - Float(o.y), 2.0))
            let angle = atan2(p.y - o.y, -(p.x - o.x))
            pushBehavior.magnitude = CGFloat(distance/100.0) + 5
            pushBehavior.angle = -angle
            animator.addBehavior(pushBehavior)
        }
    }
}

