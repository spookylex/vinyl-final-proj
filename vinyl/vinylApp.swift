//
//  vinylApp.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/9/22.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct vinylApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var dataManager = DataManager()
      
    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let contextHolder = ContextHolder(context)


            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(contextHolder)
//            ContentView()
//
        }
        
    }
}
