//
//  UIAlert+tracking.swift
//  Icarus
//
//  Created by sentieo on 18/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertAction{
    
    static func swizzlingFunc() {

            if self != UIAlertAction.self {
                return
            }
            let _: () = {
                
                //didDisappearMethod
                
                let originalSelector = #selector(UIAlertAction.init(title:style:handler:))
                let swizzledSelector = #selector(UIAlertAction.logInit(title:style:handler:))
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

    @objc func logInit(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        self.logInit(title: title, style: style, handler: handler)
        print("button added")

//            let viewControllerName = NSStringFromClass(type(of: self))
//        if #available(iOS 13.0, *) {
//            print( " \(viewControllerName) Function Called:- \(String(describing: self.largeContentTitle)),action - \(action) \n" , to: &Log.log)
//        } else {
//            print( " \(viewControllerName) Function Called:-, \(action) \n" , to: &Log.log)
//        }
        }

}
