//
//  AnimacaoTransicaoPersonalizada.swift
//  Alura Viagens
//
//  Created by Alexandre Rasta Moura on 14/05/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class CustomAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK: -  Atributos
    private var duration: TimeInterval
    private var image: UIImage
    private var initialFrame:CGRect
    private var presentViewController:Bool
    init(duration:TimeInterval, image:UIImage, initialFrame:CGRect, presentViewController:Bool) {
        self.duration = duration
        self.image = image
        self.initialFrame = initialFrame
        self.presentViewController = presentViewController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let finalView = transitionContext.view(forKey: .to) else {return}
        guard let initialView = transitionContext.view(forKey: .from) else {return}
        
        let contextView = transitionContext.containerView
        
        if presentViewController {
            contextView.addSubview(finalView)
        }else{
            contextView.insertSubview(finalView, belowSubview: initialView)
        }
        
        let currentView = presentViewController ? finalView : initialView
        
        guard let imageView  = currentView.viewWithTag(1) as? UIImageView else{return}
        imageView.image = self.image
        
        let transitionFrame = presentViewController ? initialFrame : imageView.frame
        let transitionImageView = UIImageView(frame: transitionFrame)
        transitionImageView.image = self.image
        
        contextView.addSubview(transitionImageView)
        
        currentView.frame = presentViewController ? CGRect(x: initialView.frame.width, y: 0, width: finalView.frame.width, height: finalView.frame.height) : initialView.frame
        currentView.layoutIfNeeded()

        UIView.animate(withDuration: duration, animations: {
            currentView.frame = self.presentViewController ? initialView.frame : CGRect(x: initialView.frame.width, y: 0, width: finalView.frame.width, height: finalView.frame.height)
            transitionImageView.frame = self.presentViewController ? imageView.frame : self.initialFrame
        }) { (_ ) in
            transitionImageView.removeFromSuperview()
            finalView.viewWithTag(1)?.isHidden = false
            transitionContext.completeTransition(true)
        }
    }

}
