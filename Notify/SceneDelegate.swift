//
//  SceneDelegate.swift
//  Notify
//
//  Created by Renann de Campos Antunes on 16/05/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var notificationResponse: UNNotificationResponse?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        // Handle notification response if app is launched by a notification
        if let notificationResponse = connectionOptions.notificationResponse {
            print("AQUI \(notificationResponse)")
            handleNotificationResponse(notificationResponse)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // Handle notification response when app comes to foreground
        if let notificationResponse = notificationResponse {
            handleNotificationResponse(notificationResponse)
            self.notificationResponse = nil
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func handleNotificationResponse(_ response: UNNotificationResponse) {
        // Process notification response
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            print("Aceitou")
        case "REJECT_ACTION":
            print("Recusou")
        default:
            guard let navigationController = window?.rootViewController as? UINavigationController else {
                   return
               }

               let authorizationViewController = AutorizationView()
               authorizationViewController.modalPresentationStyle = .fullScreen
               navigationController.present(authorizationViewController, animated: true, completion: nil)
            
        }
    }
}

