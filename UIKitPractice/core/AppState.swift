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
        $isLoggedIn
            .sink { UserDefaults.standard.set($0, forKey: "isLoggedIn") }
            .store(in: &cancellables)
    }
}
