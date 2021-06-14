//
//  SignupStep1ViewController.swift
//  Icarus
//
//  Created by Joshua Stephenson on 6/3/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class SignupStep1ViewController: UIViewController {

    @IBOutlet weak var nameFieldLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var textView: UITextView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User()
//        NotificationCenter.default.addObserver(
//          self,
//          selector: #selector(textChange),
//            name: Notification.Name("newWrite"),
//          object: nil)
//        Log.log.delete()
        Log.log.writeToTextView(sender: self.textView)
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        Log.log.writeToTextView(sender: self.textView)
//    }
//    @objc func textChange(){
//        DispatchQueue.main.async {
//            Log.log.writeToTextView(sender: self.textView)
//        }
        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.user?.name = nameField.text
        let step2VC = segue.destination as! SignupStep2ViewController
        step2VC.user = self.user
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let name = nameField.text, name.count >= 2 {
            return true
        }
        let alertController = UIAlertController(title: "Wait a Minute!", message: "Please enter at least 2 characters for name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
