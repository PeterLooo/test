//
//  GroupSlideInTransition.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupSlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()
    private var fromVC : UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView
        fromVC = fromViewController
        let finalWidth = toViewController.view.bounds.width * 0.68
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchView))
        dimmingView.addGestureRecognizer(ges)
        dimmingView.isUserInteractionEnabled = true

        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    
    @objc func onTouchView() {
        fromVC?.dismiss(animated: true, completion: nil)
    }

}
