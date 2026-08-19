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
