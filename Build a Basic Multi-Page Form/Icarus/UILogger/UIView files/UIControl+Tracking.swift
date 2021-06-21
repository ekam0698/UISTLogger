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

    @objc func logSendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
            self.logSendAction(action, to: target, for: event)

            let viewControllerName = NSStringFromClass(type(of: self))
        if #available(iOS 13.0, *) {
            print( " \(viewControllerName) Name Called:- \(String(describing: self.largeContentTitle)),action - \(action) \n" , to: &Log.log)
        } else {
            print( " \(viewControllerName) Function Called:-, \(action) \n" , to: &Log.log)
        }
        }

}
// action adding to empty button for

class ClosureSleeve {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add (for controlEvents: UIControlEvents, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

