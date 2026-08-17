//
//  HomeViewController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 17/08/26.
//
import UIKit

class HomeViewController: UIViewController {
    
    let label = UILabel()
    let textField = UITextField()
    let button = UIButton(type: .system)
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        label.text = "Home"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        
        textField.placeholder = "Enter text..."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = .black
        
        var config = UIButton.Configuration.filled()
        config.title = "Submit"
        button.configuration = config
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 260),
            
            textField.heightAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    @objc private func didTapSubmit() {
        navigationController?.popViewController(animated: true)
    }
}
