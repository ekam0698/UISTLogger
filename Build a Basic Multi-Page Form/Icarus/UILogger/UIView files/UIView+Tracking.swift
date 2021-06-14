//
//  UIView+Tracking.swift
//  Icarus
//
//  Created by sentieo on 11/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import UIKit

extension UIView{
    
    static func swizzlingF() {

            if self != UIView.self {
                return
            }
            let _: () = {
                //didMoveToSuperview
                var originalSelector = #selector(UIView.didMoveToSuperview)
                var swizzledSelector = #selector(UIView.logdidMoveToSuperview)
                
                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)
                
                //removeFromSuperview
                
                originalSelector = #selector(UIView.removeFromSuperview)
                swizzledSelector = #selector(UIView.logremoveFromSuperview)
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
    
    @objc func logdidMoveToSuperview() {
            self.logdidMoveToSuperview()

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "                          \(viewControllerName)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }
    @objc func logremoveFromSuperview() {
            self.logremoveFromSuperview()

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "                          \(viewControllerName)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }
}


//extension UIGestureRecognizer{
//    
//    static func swizzlingF() {
//
//            if self != UIGestureRecognizer.self {
//                return
//            }
//            let _: () = {
//                //didMoveToSuperview
//                let originalSelector = #selector(UIGestureRecognizer.init(target:action:))
//                let swizzledSelector = #selector(UIGestureRecognizer.logInit(target:action:))
//                
//                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)
//
//                
//            }()
//        }
//    
//    static func swizzle(className:AnyClass ,original : Selector , swizzled : Selector){
//        let originalSelector = original
//        let swizzledSelector = swizzled
//        
//        let originalMethod =
//            class_getInstanceMethod(self, originalSelector)
//        let swizzledMethod =
//            class_getInstanceMethod(self, swizzledSelector)
//        
//        let didAddMethod = class_addMethod(className, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
//
//        if (didAddMethod) {
//            class_replaceMethod(className,
//                                swizzledSelector,
//                                method_getImplementation(originalMethod!),
//                                method_getTypeEncoding(originalMethod!));
//        } else {
//            method_exchangeImplementations(originalMethod!, swizzledMethod!);
//        }
//        
//        
//    }
//    
//    @objc func logInit(target: Any?, action: Selector?){
//        self.logInit(target: target, action: action)
//        print(#file, #function, "\(self.classForCoder)", to: &logger)
//    }
//    
//    
//}
