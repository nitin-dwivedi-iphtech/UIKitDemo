//
//  ProfileController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//

import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var appState: AppState!
    
    func config(appState: AppState) {
        self.appState = appState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUser()
    }
    
    private func displayUser() {
        guard let user = appState?.user else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
    
    @IBAction func logoutBtnTap(_ sender: Any) {
        appState?.isLoggedIn = false
        appState?.user = nil
        AppRouter.setRootViewController(to: .auth, appState: appState)
    }
}