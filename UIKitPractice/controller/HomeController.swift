//
//  HomeViewController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 17/08/26.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var backButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconTapped(_:)))
        backButtonImage.addGestureRecognizer(tap)
    }
    
    @objc private func iconTapped(_ sender: UITapGestureRecognizer) {
        AppRouter.setRootViewController(to: .auth)
    }
}
