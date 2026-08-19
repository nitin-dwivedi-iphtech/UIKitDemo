//
//  AuthController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 18/08/26.
//
import UIKit
import Combine

class AuthController:UIViewController {
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginBackButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var createPassTextField: UITextField!
    @IBOutlet weak var createEmailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var viewModel:AuthViewModel!
    private var appState:AppState!
    private var cancellable = Set<AnyCancellable>()
    
    func config(appState:AppState) {
        self.viewModel = AuthViewModel(appState: appState)
        self.appState = appState
    }
    
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createVC = segue.destination as? AuthController {
            createVC.config(appState: appState)
        }
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let pass = passTextField.text ?? ""
        if email.isEmpty && pass.isEmpty{
            // do alert task
            return 
        }
        if viewModel.login(email: email, pass: pass) {
            AppRouter.setRootViewController(to: .main, appState: appState)
        }
    }
    
    @IBAction func loginBackButtonTap(_ sender: Any) {
        if let navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func createAccountBtnTap(_ sender: Any) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
              let email = createEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
              let pass = createPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !pass.isEmpty else { return }
        
        viewModel.createUser(name: name, email:  email, pass: pass)
        
        AppRouter.setRootViewController(to: .main, appState: appState)
    }
}
