//
//  AppRouter.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 18/08/26.
//

import UIKit

enum AppRouter {
    enum Destination {
        case auth
        case main
    }
    
    static func setRootViewController(to destination: Destination, appState: AppState) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let storyboardName = (destination == .main) ? "Main" : "Auth"
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let targetVC = storyBoard.instantiateInitialViewController() else {
            return
        }

        let rootVC: UIViewController
        if let nav = targetVC as? UINavigationController {
            rootVC = nav.viewControllers.first ?? targetVC
        } else {
            rootVC = targetVC
        }

        if let authVC = rootVC as? AuthController {
            authVC.config(appState: appState)
        } else if let homeVC = rootVC as? HomeController {
            homeVC.config(appState: appState)
        }
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = targetVC
            })
    }
}
