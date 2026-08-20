//
//  AddTodoController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//

import UIKit
import CoreData

class AddTodoController: UIViewController {
    
    @IBOutlet weak var descTextField: UITextField!
    
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var actionbutton: UIButton!
    
    private var viewModel: DashboardViewModel!
    var todoToEdit: Todo?
    var onSave: (() -> Void)?
    
    func config(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isEditing = populateFieldsIfEditing()
        handelHeadingText(isEditing: isEditing)
        configureAsSheet()
        styleTextField()
    }
    
    private func styleTextField() {
        descTextField.borderStyle = .none
        descTextField.layer.cornerRadius = 16
        descTextField.layer.borderWidth = 1
        descTextField.layer.borderColor = UIColor(named: "ThemeAccent")?.cgColor
        descTextField.backgroundColor = UIColor(named: "ThemeSurface")
        
        let leftPad = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        descTextField.leftView = leftPad
        descTextField.leftViewMode = .always
        
        let rightPad = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        descTextField.rightView = rightPad
        descTextField.rightViewMode = .always
    }
    
    private func configureAsSheet() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
        sheet.preferredCornerRadius = 24
    }
    
    @IBAction func saveTodoBtnTap(_ sender: Any) {
        guard let desc = descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !desc.isEmpty else {
            return
        }
        
        if let todo = todoToEdit {
            todo.desc = desc
            viewModel.saveTodo()
        } else {
            viewModel.createTodo(desc: desc)
        }
        onSave?()
        dismiss(animated: true)
    }
    
    private func handelHeadingText(isEditing:Bool) {
        if isEditing {
            headingLabel.text = "Edit Todo"
            subHeadingLabel.text = "Edit your task details below"
            actionbutton.setTitle("Edit Todo", for: .normal)
        } else {
            headingLabel.text = "Add Todo"
            subHeadingLabel.text = "Add your task details below"
            actionbutton.setTitle("Save Todo", for: .normal)
        }
    }
    
    private func populateFieldsIfEditing() -> Bool{
        guard let todo = todoToEdit else { return false}
        descTextField.text = todo.desc
        return true
    }
}
