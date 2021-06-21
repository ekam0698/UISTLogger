//
//  Swizzler.swift
//  Icarus
//
//  Created by sentieo on 11/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import Foundation
import UIKit

class Swizzler {
    static let shared = Swizzler()
    
    func swizzlingFunction() {
        UIViewController.swizzlingF()
        UIControl.swizzlingFunc()
//        UIAlertAction.swizzlingFunc()
//        UIView.swizzlingF()
//        UIGestureRecognizer.swizzlingF()
    }
}
