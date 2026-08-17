//
//  ViewController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 17/08/26.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton(type: .system)
    let label = UILabel()
    let uiStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        setupStackView()
    }
    
    private func setupStackView() {
        setupLabel()
        setupButton()
        
        uiStack.axis = .vertical
        uiStack.spacing = 20
        uiStack.alignment = .center
        uiStack.distribution = .fill
        
        view.addSubview(uiStack)
        uiStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLabel() {
        label.text = "Welcome Bros!!"
        let boldFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: boldFont)
        uiStack.addArrangedSubview(label)
    }
    
    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Click me"
        button.configuration = config
        uiStack.addArrangedSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
