//
//  HUDProgressView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/19.
//

import SwiftUI

struct HUDProgressView: View {
  
  @State var animate = false
  
  var placeHolder: String
  
  var body: some View {
    VStack(spacing: 28) {
      Circle()
        .stroke(
          AngularGradient(
            gradient: .init(colors: [Color.primary, Color.primary.opacity(0)]),
            center: .center
          )
        )
        .frame(width: 80, height: 80)
        .rotationEffect(.init(degrees: animate ? 360: 0))
      
      Text(placeHolder)
        .fontWeight(.bold)
    }
    .padding(.vertical, 25)
    .padding(.vertical, 35)
    .background(BlurView())
    .cornerRadius(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear() {
      withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
        animate.toggle()
      }
    }
  }
}

struct BlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
  }
}

struct HUDProgressView_Previews: PreviewProvider {
  static var previews: some View {
    HUDProgressView(placeHolder: "Please wait...")
  }
}
