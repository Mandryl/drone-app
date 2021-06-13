//
//  ViewController.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import DJISDK
import DJIWidget

class DJISDKConformer: NSObject, DJIVideoFeedListener, DJISDKManagerDelegate, ObservableObject {
  @Published private(set) var isConnected: Bool = false

  // MARK: DJISDKManagerDelegate Methods
  func productConnected(_ product: DJIBaseProduct?) {
    NSLog("Product Connected")
    self.isConnected = true
  }
  
  func productDisconnected() {
    NSLog("Product Disconnected")
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
  
  // MARK: DJIVideoFeedListener
  func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
    let videoData = videoData as NSData
    let videoBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: videoData.length)
    videoData.getBytes(videoBuffer, length: videoData.length)
    DJIVideoPreviewer.instance().push(videoBuffer, length: Int32(videoData.length))
  }
}
