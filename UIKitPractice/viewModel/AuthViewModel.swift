//
//  AuthViewModel.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//
import Combine
import CoreData

class AuthViewModel: ObservableObject {
    @Published var error: String?
    private var context:NSManagedObjectContext?
    private var appState:AppState
    
    init(appState: AppState) {
        self.context = CoreDataManager.shared.context
        self.appState = appState
    }
    
    func login(email:String, pass:String)  -> Bool{
        let request = Users.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", argumentArray: [email,pass])
        if let result = try? context?.fetch(request), let user = result.first {
            appState.isLoggedIn = true
            appState.user = user
            return true
        } else {
            print("boom!, user not found code phat gaya!!!")
            return false
        }
    }
    
    func createUser(name:String, email:String, pass:String) {
        guard let context else { return }
        let user = Users(context: context)
        user.id = UUID().uuidString
        user.name = name
        user.email = email
        user.password = pass
        context.saveData()
        appState.isLoggedIn = true
        appState.user = user
    }
}
