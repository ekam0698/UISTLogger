//
//  UIViewController+Tracking.swift
//  Icarus
//
//  Created by sentieo on 11/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//


import UIKit

extension UIViewController{
    
    static func swizzlingF() {

            if self != UIViewController.self {
                return
            }
            let _: () = {
                //viewWillAppear
                var originalSelector = #selector(UIViewController.viewWillAppear(_:))
                var swizzledSelector = #selector(UIViewController.logViewWillAppear(animated:))
                
                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)
                //viewDidLoad
                
                originalSelector = #selector(UIViewController.viewDidLoad)
                swizzledSelector = #selector(UIViewController.logViewDidLoad)
                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)

                
                //didDisappearMethod
                
                originalSelector = #selector(UIViewController.viewDidDisappear(_:))
                swizzledSelector = #selector(UIViewController.logViewDidDisappear(animated:))
                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)

                
            }()
        }
    
    static func swizzle(className:AnyClass ,original : Selector , swizzled : Selector){
        let originalSelector = original
        let swizzledSelector = swizzled
        
        let originalMethod =
            class_getInstanceMethod(self, originalSelector)
        let swizzledMethod =
            class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(className, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        if (didAddMethod) {
            class_replaceMethod(className,
                                swizzledSelector,
                                method_getImplementation(originalMethod!),
                                method_getTypeEncoding(originalMethod!));
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
        
        
    }
    
    @objc func logViewWillAppear(animated: Bool) {
            self.logViewWillAppear(animated: animated)

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", "viewWillAppear \n" , to: &Log.log)
        }
    
    
    @objc func logViewDidLoad() {
            self.logViewDidLoad()
        self.checkButtonAction()
            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", "viewDidLoad \n" , to: &Log.log)

        }
    
    @objc func logViewDidDisappear(animated: Bool) {
            self.logViewDidDisappear(animated: animated)

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", "viewDidDissapear \n" , to: &Log.log)

        }
    
    
    
    //- Empty button action overide
    func checkButtonAction(){
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                if (btn.allTargets.isEmpty){
                    btn.add(for: .touchUpInside, {
                        // can add to present a alert view on button with no acction
                    })
                }
            }
        }

    }
    
}

