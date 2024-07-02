//
//  LoginViewController.swift
//  ChatApp
//
//  Created by hverda on 25/06/2024.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextFieldLabel: UITextField!
    
    @IBOutlet weak var passwordTextFieldLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextFieldLabel.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextFieldLabel.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextFieldLabel.text, let password = passwordTextFieldLabel.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
}
