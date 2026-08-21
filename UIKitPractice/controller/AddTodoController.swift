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
    
    
    @IBOutlet weak var categoryPicker: UIButton!
    
    private var viewModel: DashboardViewModel!
    var todoToEdit: Todo?
    var onSave: (() -> Void)?
    
    private var selectedCategory: TodoSections = .work
    
    func config(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isEditing = populateFieldsIfEditing()
        handelHeadingText(isEditing: isEditing)
        configureAsSheet()
        styleTextField()
        setupCategoryPicker()
    }
    
    // MARK: Category Picker
    
    func setupCategoryPicker() {
        let actions = TodoSections.allCases
                .filter { $0 != .all }
                .map { section in
                    UIAction(
                        title: section.rawValue.capitalized,
                        state: section == selectedCategory ? .on : .off
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.selectedCategory = section
                        self.updateCategoryPickerButtonTitle()
                        self.setupCategoryPicker()
                    }
                }
        
        categoryPicker.menu = UIMenu(title: "Select Category", children: actions)
        categoryPicker.showsMenuAsPrimaryAction = true
        updateCategoryPickerButtonTitle()
    }
    
    private func updateCategoryPickerButtonTitle() {
        categoryPicker.setTitle(selectedCategory.rawValue.capitalized, for: .normal)
    }
    
    // MARK: Styling
    
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
    
    // MARK: Actions
    
    @IBAction func saveTodoBtnTap(_ sender: Any) {
        guard let desc = descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !desc.isEmpty else {
            return
        }
        
        if let todo = todoToEdit {
            todo.desc = desc
            todo.category = selectedCategory.rawValue
            viewModel.saveTodo()
        } else {
            viewModel.createTodo(desc: desc, category: selectedCategory)
        }
        onSave?()
        dismiss(animated: true)
    }
    
    // MARK: Helpers
    
    private func handelHeadingText(isEditing: Bool) {
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
    
    private func populateFieldsIfEditing() -> Bool {
        guard let todo = todoToEdit else { return false }
        descTextField.text = todo.desc
        
        if let savedCategoryString = todo.category,
           let categoryEnum = TodoSections(rawValue: savedCategoryString) {
            selectedCategory = categoryEnum
        }
        
        return true
    }
}
