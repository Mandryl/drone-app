//
//  DefaultLayoutViewController.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import SwiftUI
import DJIUXSDK

struct DefaultLayoutView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> DUXDefaultLayoutViewController {
    return DUXDefaultLayoutViewController()
  }
  
  func updateUIViewController(_ uiViewController: DUXDefaultLayoutViewController, context: Context) {
  }
}
