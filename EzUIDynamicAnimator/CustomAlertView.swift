//
//  CustomAlertView.swift
//  EzUIDynamicAnimator
//
//  Created by iOS Student on 2/6/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {

    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)

        createOverlay()
        createAlert()
    }

    func createOverlay() {

        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }

    func createAlert() {

        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame: CGRect = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.white
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;


        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)

        button.addTarget(self, action: #selector(CustomAlertView.dismissAlert), for: UIControlEvents.touchUpInside)

        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Techmaster \n Xin Chao Cac Ban!"
        label.textAlignment = .center

        alertView.addSubview(label)
        alertView.addSubview(button)
        view.addSubview(alertView)
    }

    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        createGestureRecognizer()

        animator.removeAllBehaviors()

        // Animate in the overlay
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 1.0
        })

        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0

        let snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        animator.addBehavior(snapBehaviour)
    }

    func dismissAlert() {
        animator.removeAllBehaviors()

        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 0.0
            self.alertView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
        })

    }

    @IBAction func showAlertView(_ sender: UIButton) {
        showAlert()
    }

    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CustomAlertView.handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    func handlePan(_ sender: UIPanGestureRecognizer) {

        if (alertView != nil) {
            let panLocationInView = sender.location(in: view)
            let panLocationInAlertView = sender.location(in: alertView)

            if sender.state == UIGestureRecognizerState.began {
                animator.removeAllBehaviors()

                let offset = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY);
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)

                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.ended {
                animator.removeAllBehaviors()

                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
                animator.addBehavior(snapBehavior)

                if sender.translation(in: view).y > 100 {
                    dismissAlert()
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
