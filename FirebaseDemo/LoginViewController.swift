//
//  LoginViewController.swift
//  FirebaseDemo
//
//  Created by DucHa on 9/21/16.
//  Copyright © 2016 DucHa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollContainer: UIScrollView!

    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if !self.navigationController!.viewControllers.last!.isKind(of: LoginViewController.self) {
                return
            }
            if let _ = user  {
                self.performSegue(withIdentifier: "showGroceryList", sender: nil)
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(noti: NSNotification) {
        let keyboardRect = (noti.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardRect!.size.height
        if let _ = activeTextField {
            let yOffset = keyboardHeight -  (view.frame.size.height - scrollContainer.frame.size.height - scrollContainer.frame.origin.y)
            if yOffset > 0 {
                scrollContainer.contentInset = UIEdgeInsetsMake(0, 0, yOffset, 0)
            }
        }
    }
    
    func keyboardWillHide(noti: NSNotification) {
        scrollContainer.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction func loginDidPush(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
