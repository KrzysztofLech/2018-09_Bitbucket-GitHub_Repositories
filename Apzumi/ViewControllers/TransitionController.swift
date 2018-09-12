//
//  TransitionController.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 12.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.5
    
    fileprivate var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            
            toView.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                fromView.transform = CGAffineTransform(translationX: -containerView.frame.width * 0.4, y: 0)
                fromView.alpha = 0.4
                
                toView.transform = CGAffineTransform.identity
                
            }, completion: { (_) in
                fromView.transform = CGAffineTransform.identity
                fromView.alpha = 1.0
                transitionContext.completeTransition(true)
            })
            
        } else {
            
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            
            toView.alpha = 0.4
            
            UIView.animate(withDuration: duration*0.4, delay: 0, options: .curveEaseOut, animations: {
                fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            UIView.animate(withDuration: duration*0.6, delay: duration*0.4, options: .curveEaseOut, animations: {
                fromView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
                toView.alpha = 1.0
                
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}

extension TransitionController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
