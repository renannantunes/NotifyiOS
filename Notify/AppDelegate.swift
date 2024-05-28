//
//  AppDelegate.swift
//  Notify
//
//  Created by Renann de Campos Antunes on 16/05/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var notificationRequest: UNNotificationRequest?
    let notificationIdentifierPrefix = "uniqueNotificationIdentifier"
    var notificationCount = 0
    let maxNotifications = 10
    let notificationInterval: TimeInterval = 3
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Configuração da janela para iOS 12 ou anterior
        if #available(iOS 13.0, *) {
            // A configuração será feita no SceneDelegate
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let rootViewController = ViewController()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Solicitar autorização para notificações
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Erro ao solicitar autorização para notificações: \(error)")
                return
            }
            
            guard granted else {
                print("Permissão para notificações não concedida")
                return
            }
            
            // Registrar para notificações remotas
            DispatchQueue.main.async {
                print("Permissão concedida")
                application.registerForRemoteNotifications()
            }
        }
        
        // Definir as ações e a categoria
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Aceitar", options: [.foreground])
        let rejectAction = UNNotificationAction(identifier: "REJECT_ACTION", title: "Recusar", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "VISITOR_REQUEST", actions: [acceptAction, rejectAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            
            print("Token: \(token)")
        }
    }
    
    // Implementar UNUserNotificationCenterDelegate para receber notificações
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Receber notificações
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Este método é chamado quando uma notificação é recebida
        print("Notificação recebida: \(userInfo)")
        
        // Processar os dados da notificação
        //        sendLocalNotification()
        // Chame essa função para iniciar a sequência de notificações repetitivas
        scheduleRepeatingNotifications()
        
        completionHandler(.newData)
    }
    
    // Processa resposta à notificação
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Parar o loop de notificações
        stopRepeatingNotifications()
        
        // Mandar pra página de autorização se o app estiver aberto
        let authView = AutorizationView()
        let rootViewController = ViewController()
        authView.modalPresentationStyle = .fullScreen
        rootViewController.present(authView, animated: true, completion: nil)
        
        // Direcionar a notificação para o SceneDelegate
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.handleNotificationResponse(response)
        }
        
        completionHandler()
    }
    
    
    func sendLocalNotification(withIdentifier identifier: String, after interval: TimeInterval, index i: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "Renann Antunes está querendo entrar"
        content.body = "Interaja com a notificação para Aceitar ou Recusar."
        //        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "out2.caf"))
        content.sound = .default
        content.categoryIdentifier = "VISITOR_REQUEST"
        
        // Add vibration pattern to notification
        content.userInfo = ["vibrationPattern": "long"]
        
        // Adicionando botões de texto diretamente no corpo da notificação
        content.userInfo = ["ACCEPT_ACTION": "ACCEPT_ACTION", "REJECT_ACTION": "REJECT_ACTION"]
        
        // Remove a notificação anterior com o mesmo identificador, se existir
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao adicionar notificação: \(error)")
            }
        }
    }
    
    
    
    
    func scheduleRepeatingNotifications() {
        stopRepeatingNotifications()
        for i in 1...maxNotifications {
            let identifier = "\(notificationIdentifierPrefix)_\(i)"
            sendLocalNotification(withIdentifier: identifier, after: TimeInterval(i) * notificationInterval, index: i)
        }
    }
    
    func stopRepeatingNotifications() {
        for i in 1...maxNotifications {
            let identifier = "\(notificationIdentifierPrefix)_\(i)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        }
    }
    
    
    
}

