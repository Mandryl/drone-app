//
//  DJIVideoFeedConformer.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import DJISDK
import DJIWidget

class DJIVideoFeedConformer: NSObject, DJIVideoFeedListener, ObservableObject {
  // MARK: DJIVideoFeedListener
  func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {
    let videoData = videoData as NSData
    let videoBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: videoData.length)
    videoData.getBytes(videoBuffer, length: videoData.length)
    DJIVideoPreviewer.instance().push(videoBuffer, length: Int32(videoData.length))
  }
}
