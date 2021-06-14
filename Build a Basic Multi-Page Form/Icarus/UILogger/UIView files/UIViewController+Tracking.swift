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
    
//    open override class func initialize() {
//            // make sure this isn't a subclass
//            guard self === UIViewController.self else { return }
//            swizzling(self)
//        }
    
    @objc func logViewWillAppear(animated: Bool) {
            self.logViewWillAppear(animated: animated)

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }
    
    
    @objc func logViewDidLoad() {
            self.logViewDidLoad()

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }
    
    @objc func logViewDidDisappear(animated: Bool) {
            self.logViewDidDisappear(animated: animated)

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }
    
//    @objc func logPresent(_ viewControllerToPresent: UIViewController, animated : Bool, completion: (() -> Void)? = nil) {
//            self.logPresent(viewControllerToPresent, animated: animated, completion: completion)
//
//            let viewControllerName = NSStringFromClass(type(of: self))
//        print( "\(viewControllerName)", #function , to: &logger)
////            print("viewWillAppear: \(viewControllerName)")
//        }
    
}


//class UIControlTracking: UIControl {
//
//    override func viewDidLoad(){
//
//    }
//
//}

