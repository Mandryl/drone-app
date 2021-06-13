//
//  FPVViewController.swift
//  iOS-FPVDemo-Swift
//
import UIKit
import SwiftUI
import DJISDK
import DJIWidget

class CameraConformer: NSObject, DJICameraDelegate, ObservableObject {
  
  var isRecording : Bool!
  
  func fetchCamera() -> DJICamera? {
    guard let product = DJISDKManager.product() else {
      return nil
    }
    if product is DJIAircraft {
      return (product as! DJIAircraft).camera
    }
    if product is DJIHandheld {
      return (product as! DJIHandheld).camera
    }
    return nil
  }
  
  // MARK: DJICameraDelegate Method
  func camera(_ camera: DJICamera, didUpdate cameraState: DJICameraSystemState) {
  }
}
