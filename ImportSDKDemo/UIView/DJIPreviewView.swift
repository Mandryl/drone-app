//
//  DJIPreviewView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import SwiftUI
import DJISDK
import DJIWidget

struct DJIPreviewView: UIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  let fpvView = UIView()
  
  func makeUIView(context: Context) -> UIView {
    return fpvView
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}
