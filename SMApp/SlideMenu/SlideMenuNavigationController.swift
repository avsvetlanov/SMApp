//
//  BaseNavigationController.swift
//  SMApp
//
//  Created by  Svetlanov on 17.08.16.
//  Copyright © 2016  Svetlanov. All rights reserved.
//

import UIKit

class SlideMenuNavigationController : UINavigationController, SlideMenuDelegate {
    
    let MENU_WIDTH : CGFloat = 250
    
    var slideMenuViewController : SlideMenuViewController?
    var menuLeftConstraint: NSLayoutConstraint?
    var maskLeftConstraint: NSLayoutConstraint?
    
    var maskView : UIView!
    
    func addSlideMenuToViewController(viewController: UIViewController) {
        self.slideMenuViewController = SlideMenuViewController(delegate: self)
        
        addLeftSlideMenuButton(viewController)
        
        addMenuToViewController(self)
        addMenuConstraintsToView(slideMenuViewController!.view, view: self.view)
        
        if #available(iOS 8.0, *) {
            self.maskView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            self.maskView.frame = CGRectZero
        } else {
            self.maskView = UIView(frame: CGRectZero)
            self.maskView.backgroundColor = UIColor.blackColor()
        }
        
        addMaskToViewController(self, belowSubview: slideMenuViewController!.view)
        addMaskConstraintsToView(maskView, view: self.view)
        addMaskGestureRecognizer()
    }
    
    func onSlideMenuButtonPressed(sender: UIButton){
        showMenu()
    }
    
    func didSelectMenuItem(number: Int) {
        hideMenu()
        
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewController.storyboardId) as? ViewController {
                viewController.number = number
                self.setViewControllers([viewController], animated: false)
        }
    }
    
    func showMenu() {
        guard slideMenuViewController != nil else {
            return
        }
        
        slideMenuViewController?.view.hidden = false
        menuLeftConstraint?.constant = 0
        maskLeftConstraint?.constant = 0
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.maskView.alpha = 0.5
            }, completion: { (completed) -> Void in
        })
    }
    
    func hideMenu() {
        guard slideMenuViewController != nil else {
            return
        }
        
        menuLeftConstraint?.constant = -slideMenuViewController!.view.bounds.size.width
        maskLeftConstraint?.constant = -slideMenuViewController!.view.bounds.size.width
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.maskView.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.slideMenuViewController?.view.hidden = true
        })
    }
    
    func tapGestureRecognized() {
        hideMenu()
    }
    
    
    
    
    
    
    
    
    private func addLeftSlideMenuButton(viewController: UIViewController) {
        let showMenuButton = UIButton(type: UIButtonType.System)
        showMenuButton.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        showMenuButton.frame = CGRectMake(0, 0, 30, 30)
        showMenuButton.addTarget(self, action: #selector(SlideMenuNavigationController.onSlideMenuButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let customBarItem = UIBarButtonItem(customView: showMenuButton)
        viewController.navigationItem.leftBarButtonItem = customBarItem
    }
    
    private func addMenuToViewController(viewController: UIViewController) {
        guard slideMenuViewController != nil else {
            return
        }
        
        slideMenuViewController!.didMoveToParentViewController(viewController)
        slideMenuViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(slideMenuViewController!.view)
    }
    
    private func addMaskToViewController(viewController: UIViewController, belowSubview: UIView) {
        maskView.alpha = 0.0
        maskView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.insertSubview(maskView, belowSubview: belowSubview)
    }
    
    private func addMaskGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SlideMenuNavigationController.tapGestureRecognized))
        self.maskView.addGestureRecognizer(tapGesture)
    }
    
    
    
    private func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 22), false, 0.0)
        
        UIColor.blackColor().setFill()
        UIBezierPath(rect: CGRectMake(0, 3, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 10, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 17, 30, 1)).fill()
        
        UIColor.whiteColor().setFill()
        UIBezierPath(rect: CGRectMake(0, 4, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 11,  30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 18, 30, 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage
    }
    
    private func addMenuConstraintsToView(menuView: UIView, view: UIView) {
        let topConstraint = NSLayoutConstraint(item: menuView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: menuView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: menuView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: MENU_WIDTH)
        
        menuLeftConstraint = NSLayoutConstraint(item: menuView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -widthConstraint.constant)
        
        view.addConstraints([topConstraint, menuLeftConstraint!, bottomConstraint, widthConstraint])
    }
    
    
    private func addMaskConstraintsToView(maskView: UIView, view: UIView) {
        let topConstraint = NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        maskLeftConstraint = NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -view.bounds.size.width)
        
        let rightConstraint = NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([topConstraint, bottomConstraint, maskLeftConstraint!, rightConstraint])
    }
    
    
    
}
