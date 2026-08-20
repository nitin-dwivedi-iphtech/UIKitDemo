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
    
    init(appState:AppState) {
        self.context = CoreDataManager.shared.context
        self.appState = appState
        fetchUser()
        fetchTodo()
    }
    
    func fetchTodo() {
        do {
            let request = Todo.fetchRequest()
            self.todo = try context?.fetch(request)
        } catch {
            print("error:- \(error)")
        }
    }
    
    func createTodo(desc: String) {
        guard let context = self.context else { return }
        let todo = Todo(context: context)
        todo.id = UUID().uuidString
        todo.desc = desc
        todo.status = StatusEnum.pending.rawValue
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
    
    private func fetchUser() {
        do {
            let request = Users.fetchRequest()
            self.appState.user = try context?.fetch(request).first
        } catch {
            print("error:- \(error)")
        }
    }
    
    func signOut() {
        appState.isLoggedIn = false
        appState.user = nil
    }
    
}
