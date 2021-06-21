//
//  FloatingBtnControlViewController.swift
//  Icarus
//
//  Created by sentieo on 14/06/21.
//  Copyright © 2021 Bright Mediums. All rights reserved.
//

import UIKit

class FloatingBtnControlViewController: UIViewController {
    
    private(set) var button: UIButton!
    private(set) var textView: UITextView!
    private(set) var newView: UIView!
    private let window = FloatingButtonWindow()
    required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    init() {
            super.init(nibName: nil, bundle: nil)
        window.windowLevel = CGFloat.greatestFiniteMagnitude
        window.isHidden = false
            window.rootViewController = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChange(_:)),name: Notification.Name("newWrite"),object: nil)
            }
    override func loadView() {
            let view = UIView()
        let button = UIButton(type: .custom)
        button.setTitle("View Logs", for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: 10, y: 10), size: button.bounds.size)
        button.autoresizingMask = []
        button.tag = 101
//        view.addSubview(button)
        
        let textView = UITextView(frame: CGRect(x: button.frame.maxX, y: button.frame.maxY, width: (view.frame.maxX-button.frame.maxX), height: 200))
        textView.text = ""
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.black.cgColor
        
        var newView = UIView(frame: CGRect(x: 10, y: 10, width: textView.frame.width+button.frame.width, height: textView.frame.height+button.frame.height))
        newView.backgroundColor = .clear
        view.addSubview(newView)
        newView.addSubview(button)
        newView.addSubview(textView)
        self.view = view
        self.button = button
        self.textView = textView
        self.newView = newView
        window.view = newView
        window.button = button
        window.textView = textView
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
        button.addGestureRecognizer(panner)
           }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            snapButtonToSocket()
        }
    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
            var center = button.center
            center.x += offset.x
            center.y += offset.y
            button.center = center
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                       self.snapButtonToSocket()
                   }
               }
           }
    @objc func keyboardDidShow(note: NSNotification) {
            window.windowLevel = 0
        window.windowLevel = CGFloat.greatestFiniteMagnitude
        }
    
    @objc func textChange(_ notification: Notification){

        DispatchQueue.main.async {
            self.textView.text = Log.log.string
            self.textView.scrollToBottom()
        }
    }
    
    private func snapButtonToSocket() {
            var bestSocket = CGPoint.zero
        var bestIndex = 0
            var distanceToBestSocket = CGFloat.infinity
            let center = button.center
        for (index,socket) in sockets.enumerated() {
                let distance = hypot(center.x - socket.x, center.y - socket.y)
                if distance < distanceToBestSocket {
                    distanceToBestSocket = distance
                    bestSocket = socket
                    bestIndex = index
                }
            }
        let buttonSize = button.bounds.size
        switch bestIndex {
        case 0:
            self.textView.frame = CGRect(x:bestSocket.x+buttonSize.width/2, y: bestSocket.y + buttonSize.height/2, width: 250, height: 200)
            
            self.newView.frame = CGRect(x:10, y: 10, width: textView.frame.width+button.frame.width, height: textView.frame.height+button.frame.height)
        case 1:
            self.textView.frame = CGRect(x: bestSocket.x+buttonSize.width/2, y: bestSocket.y - buttonSize.height/2, width: 250, height: -200)
            
            self.newView.frame = CGRect(x:self.view.frame.minX, y: self.view.frame.maxY, width: (textView.frame.width+button.frame.width), height: -(textView.frame.height+button.frame.height))
        case 2:
            self.textView.frame = CGRect(x: bestSocket.x-buttonSize.width/2, y: bestSocket.y + buttonSize.height/2, width: -250, height: 200)
            self.newView.frame = CGRect(x:self.view.frame.maxX, y: self.view.frame.minY, width: -(textView.frame.width+button.frame.width), height: (textView.frame.height+button.frame.height))
        case 3:
            self.textView.frame = CGRect(x: bestSocket.x-buttonSize.width/2, y: bestSocket.y - buttonSize.height/2, width: -250, height: -200)
            self.newView.frame = CGRect(x:self.view.frame.maxX, y: self.view.frame.maxY, width: -(textView.frame.width+button.frame.width), height: -(textView.frame.height+button.frame.height))
        case 4:
            self.textView.frame = CGRect(x: bestSocket.x-buttonSize.width, y: bestSocket.y + buttonSize.height/2, width: 300, height: 200)
            self.newView.frame = CGRect(x:self.view.frame.midX-self.newView.frame.width/2, y: self.view.frame.midY-self.newView.frame.height/2, width: (textView.frame.width+button.frame.width), height: (textView.frame.height+button.frame.height))
            
        default:
            print("Error")
        }
            button.center = bestSocket
        }
    private var sockets: [CGPoint] {
            let buttonSize = button.bounds.size
            let rect = newView.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
            let sockets: [CGPoint] = [
                CGPoint(x: rect.minX, y: rect.minY+20),
                CGPoint(x: rect.minX, y: rect.maxY-20),
                CGPoint(x: rect.maxX, y: rect.minY+20),
                CGPoint(x: rect.maxX, y: rect.maxY-20),
                CGPoint(x: rect.midX, y: rect.midY)
            ]
            return sockets
        }

    }

private class FloatingButtonWindow: UIWindow {
    enum tappedView {
        case TextViews
        case Buttons
    }
    var tappedItem:tappedView?
    var view:UIView?

    var button: UIButton?
    var textView:UITextView?
    

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard let view = view else { return false }
        let viewPoint = convert(point, to: view)
        return view.point(inside: viewPoint, with: event)
        
        }

    }






extension UITextView {
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
    }
}
