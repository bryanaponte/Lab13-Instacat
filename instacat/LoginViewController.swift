//
//  LoginViewController.swift
//  instacat
//
//  Created by mbtec22 on 11/19/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
    @IBAction func loginClickButton(_ sender: Any) {
        print("Login button clicked")
        
        if(usernameTextField.text != "" && passwordTextField.text != "") {
            Auth.auth().signIn(withEmail: usernameTextField.text!,password: passwordTextField.text!){
                (user, error) in
                
                if(user != nil){
                    print("user authentication")
                    self.presentingViewController?.dismiss(animated: true, completion: nil);
                }else{
                    print("there was an error")
                    self.errorLabel.isHidden = false
                }
            }
        }else{
            print("there was an error")
            self.errorLabel.isHidden = false
        }
    }

    

}
