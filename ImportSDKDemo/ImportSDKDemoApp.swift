//
//  ImportSDKDemoApp.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import SwiftUI
import Amplify
import AmplifyPlugins

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  public var productCommManager = ProductCommunicationService()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.productCommManager.registerWithProduct()
    
    do {
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.add(plugin: AWSS3StoragePlugin())
      try Amplify.configure()
      print("Amplify configured with storage plugin")
    } catch {
      print("Failed to initialize Amplify with \(error)")
    }
    
    return true
  }
}

@main
struct ImportSDKDemoApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) private var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView(productCommManager: appDelegate.productCommManager)
    }
    .onChange(of: scenePhase) { newScenePhase in
      switch newScenePhase {
      case .active:
        NSLog("active")
      case .background:
        NSLog("background")
      case .inactive:
        NSLog("inactive")
      @unknown default:
        NSLog("default")
      }
    }
  }
}
