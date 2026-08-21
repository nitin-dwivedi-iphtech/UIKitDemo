//
//  DashboardViewModel.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//

import Combine
import CoreData

class DashboardViewModel: ObservableObject {
    private var context:NSManagedObjectContext?
    private var appState:AppState
    @Published var todo:[Todo]? = nil
    @Published var selectedCategory: TodoSections = .all
    
    init(appState:AppState) {
        self.context = CoreDataManager.shared.context
        self.appState = appState
        fetchTodo()
    }
    
    func fetchTodo() {
        guard let user = appState.user else { return }
        do {
            let request = Todo.fetchRequest()
            var predicates:[NSPredicate] = []
            let userFilterPredicate = NSPredicate(format: "user_id == %@",user.id!)
            if selectedCategory != .all {
                let categoryPredicate = NSPredicate(format: "category == %@", selectedCategory.rawValue)
                predicates.append(categoryPredicate)
            }
            predicates.append(userFilterPredicate)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            self.todo = try context?.fetch(request)
        } catch {
            print("error:- \(error)")
        }
    }
    
    func selectCategory(_ category: TodoSections) {
        selectedCategory = category
        fetchTodo()
    }
    
    func createTodo(desc: String, category: TodoSections = .all) {
        guard let context = self.context else { return }
        let todo = Todo(context: context)
        todo.id = UUID().uuidString
        todo.desc = desc
        todo.status = StatusEnum.pending.rawValue
        todo.category = category.rawValue
        todo.user_id = appState.user?.id
        context.saveData()
    }
    
    func saveTodo() {
        context?.saveData()
    }
    
    func toggleStatus(for todo: Todo) {
        let isCompleted = StatusEnum.from(todo.status) == .completed
        todo.status = isCompleted ? StatusEnum.pending.rawValue : StatusEnum.completed.rawValue
        context?.saveData()
    }
    
    func deleteTodo(at index: Int) {
        guard let context, let todo = todo?[index] else { return }
        context.delete(todo)
        context.saveData()
        self.todo?.remove(at: index)
    }
        
    func signOut() {
        appState.isLoggedIn = false
        appState.user = nil
    }
    
}
