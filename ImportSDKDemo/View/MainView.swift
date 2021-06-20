//
//  MainView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/14.
//

import SwiftUI
import DJIUXSDKBeta

struct MainView: View {
  @State var isOpendMedia = false
  var region: String
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        
        DefaultLayoutView()
        
        NavigationLink(destination: MediaView(region: region)) {
          Text("Media")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(100)
        }
        .position(CGPoint(x: geometry.size.width * 3 / 4, y: geometry.size.height - 30))
      }
    }
    .navigationBarTitle("")
    .navigationBarHidden(true)
    .navigationBarBackButtonHidden(true)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(region: "Japan")
      .previewLayout(PreviewLayout.fixed(width: 844, height: 390))
  }
}
