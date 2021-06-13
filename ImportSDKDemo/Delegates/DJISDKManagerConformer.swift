//
//  DJISDKManagerConformer.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import DJISDK

class DJISDKManagerConformer: NSObject, DJISDKManagerDelegate, ObservableObject {
  @Published private(set) var isConnected = false
  
  // MARK: DJISDKManagerDelegate Methods
  func productConnected(_ product: DJIBaseProduct?) {
    NSLog("Product Connected")
    self.isConnected = true
  }
  
  func productDisconnected() {
    NSLog("Product Disconnected")
    self.isConnected = false
  }
  
  func appRegisteredWithError(_ error: Error?) {
    var message = "Register App Successed!"
    if (error != nil) {
      message = "Register app failed! Please enter your app key and check the network."
    }
    
    NSLog(message)
  }
  
  func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
    print("Downloading database: \(progress.completedUnitCount) / \(progress.totalUnitCount)")
  }
}
