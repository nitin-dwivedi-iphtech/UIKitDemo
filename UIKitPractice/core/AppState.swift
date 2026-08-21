//
//  Untitled.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//
import Combine
import CoreData

class AppState : ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var user: Users?
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn, let userId = UserDefaults.standard.string(forKey: "userId") {
            let context = CoreDataManager.shared.context
            let request = Users.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", userId)
            self.user = try? context.fetch(request).first
        }
        
        $isLoggedIn
            .sink { UserDefaults.standard.set($0, forKey: "isLoggedIn") }
            .store(in: &cancellables)
        
        $user
            .sink { user in
                if let id = user?.id {
                    UserDefaults.standard.set(id, forKey: "userId")
                } else {
                    UserDefaults.standard.removeObject(forKey: "userId")
                }
            }
            .store(in: &cancellables)
    }
}
