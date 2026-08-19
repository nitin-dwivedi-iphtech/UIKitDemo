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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTodoBtnTap(_ sender: Any) {
        guard let desc = descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !desc.isEmpty else {
            return
        }
        let todo = Todo(context: CoreDataManager.shared.context)
        todo.id = UUID().uuidString
        todo.desc = desc
        todo.status = "pending"
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
}