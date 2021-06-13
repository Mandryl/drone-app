//
//  CameraView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import SwiftUI
import DJISDK
import DJIWidget

struct CameraView: View {
  @StateObject var managerConformer = DJISDKManagerConformer()
  @StateObject var videoConformer = DJIVideoFeedConformer()
  let preview = DJIPreviewView()
  
  func setupVideoPreviewer() {
    DJIVideoPreviewer.instance().setView(self.preview.fpvView)
    let product = DJISDKManager.product();
    
    //Use "SecondaryVideoFeed" if the DJI Product is A3, N3, Matrice 600, or Matrice 600 Pro, otherwise, use "primaryVideoFeed".
    if ((product?.model == DJIAircraftModelNameA3)
          || (product?.model == DJIAircraftModelNameN3)
          || (product?.model == DJIAircraftModelNameMatrice600)
          || (product?.model == DJIAircraftModelNameMatrice600Pro)) {
      DJISDKManager.videoFeeder()?.secondaryVideoFeed.add(self.videoConformer, with: nil)
    } else {
      DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self.videoConformer, with: nil)
    }
    DJIVideoPreviewer.instance().start()
  }
  
  func resetVideoPreview() {
    DJIVideoPreviewer.instance().unSetView()
    let product = DJISDKManager.product();
    
    //Use "SecondaryVideoFeed" if the DJI Product is A3, N3, Matrice 600, or Matrice 600 Pro, otherwise, use "primaryVideoFeed".
    if ((product?.model == DJIAircraftModelNameA3)
          || (product?.model == DJIAircraftModelNameN3)
          || (product?.model == DJIAircraftModelNameMatrice600)
          || (product?.model == DJIAircraftModelNameMatrice600Pro)) {
      DJISDKManager.videoFeeder()?.secondaryVideoFeed.remove(self.videoConformer)
    } else {
      DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self.videoConformer)
    }
  }
  
  func onAppear() {
    DJISDKManager.registerApp(with: self.managerConformer)
    self.managerConformer.$isConnected.sink {isConnected in
      if isConnected {
        setupVideoPreviewer()
      } else {
        resetVideoPreview()
      }
    }
  }
  
  func onTapCapture() {
    guard let camera = fetchCamera() else {
      return
    }
    
    camera.setMode(DJICameraMode.shootPhoto) { error in
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        camera.startShootPhoto { error in
          if let _ = error {
            NSLog("Shoot Photo Error: ", String(describing: error))
          }
        }
      }
    }
  }
  
  var body: some View {
    VStack {
      preview
      
      Spacer()
      
      Button(action: self.onTapCapture) {
        Text("Capture")
          .foregroundColor(Color.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(100)
      }
    }
    .onAppear(perform: self.onAppear)
  }
}

struct CameraView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CameraView()
    }
  }
}
