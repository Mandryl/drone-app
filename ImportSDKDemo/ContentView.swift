//
//  ContentView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import SwiftUI
import DJISDK

struct ContentView: View {
  @State var isActive = false
  
  func onTapNext() {
    isActive = true
  }
  
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: CameraView(), isActive: $isActive) {
          EmptyView()
        }
        
        Text("Drone App")
        
        Spacer()
        
        Button(action: onTapNext, label: {
          Text("Next")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(100)
        })
        .frame(width: 300, height: 300, alignment: .center)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
