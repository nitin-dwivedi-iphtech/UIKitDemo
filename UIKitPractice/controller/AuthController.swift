//
//  AuthController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 18/08/26.
//
import UIKit

class AuthController:UIViewController {
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func loginButtonTap(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let pass = passTextField.text ?? ""
        if email.isEmpty && pass.isEmpty{
            // do alert task
        }
        
        AppRouter.setRootViewController(to: .main)
        
    }
}
