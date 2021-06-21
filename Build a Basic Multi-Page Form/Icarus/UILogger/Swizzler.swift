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
    var floatingButtonController: FloatingBtnControlViewController?
    
    func swizzlingFunction() {
        UIViewController.swizzlingF()
        UIControl.swizzlingFunc()
//        UIAlertAction.swizzlingFunc()
//        UIView.swizzlingF()
//        UIGestureRecognizer.swizzlingF()
    }
    func configureFloating(){
        floatingButtonController = FloatingBtnControlViewController()
        floatingButtonController?.button.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
        floatingButtonController?.resetBtn.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

    }
    @objc func floatingButtonWasTapped() {
        if  floatingButtonController?.textView.isHidden == true {
            floatingButtonController?.textView.isHidden = false
            floatingButtonController?.resetBtn.isHidden = false
        }else{
            floatingButtonController?.textView.isHidden = true
            floatingButtonController?.resetBtn.isHidden = true
        }
    }
    
    @objc func resetTapped(){
        DispatchQueue.main.async {
            Log.log.string = ""
        self.floatingButtonController?.textView.text = ""
            
        }
        
    }
    
    func config(){
        configureFloating()
        swizzlingFunction()
    }
}
