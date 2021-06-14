//
//  UIControl+Tracking.swift
//  Icarus
//
//  Created by sentieo on 11/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import UIKit

extension UIControl{
    
    static func swizzlingFunc() {

            if self != UIControl.self {
                return
            }
            let _: () = {
                
                //didDisappearMethod
                
                let originalSelector = #selector(UIControl.sendAction(_:to:for:))
                let swizzledSelector = #selector(UIControl.logSendAction(_:to:for:))
                self.swizzle(className: self.classForCoder(), original: originalSelector, swizzled: swizzledSelector)

                
            }()
        }
    
//        static func swizzle(className:AnyClass ,original : Selector , swizzled : Selector){
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
    @objc func logSendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
            self.logSendAction(action, to: target, for: event)

            let viewControllerName = NSStringFromClass(type(of: self))
        print( "\(viewControllerName), \(action)", #function , to: &Log.log)
//            print("viewWillAppear: \(viewControllerName)")
        }

}


