//
//  ContentView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/13.
//

import SwiftUI
import DJISDK
import Combine
import Amplify

struct ContentView: View {
  @StateObject var productCommManager: ProductCommunicationService
  
  @State var shouldLaunch = false
  @State var shouldSignIn = false
  @State var isSigned = false
  @State var username = ""
  @State var region = ""
  
  func onTapLaunch() {
    shouldLaunch.toggle()
  }
  
  func onTapSignIn() {
    shouldSignIn.toggle()
  }
  
  func onAppear() {
    if let user = Amplify.Auth.getCurrentUser() {
      isSigned = true
      username = user.username
    }
  }
  
  var body: some View {
    NavigationView {
      NavigationLink(destination: MainView(region: region), isActive: $shouldLaunch) {
        EmptyView()
      }

      VStack {
        Spacer()
        
        Text("Drone App")
          .font(.title)
          .padding()
        
        if isSigned {
          Text("Signed in Username: \(username)")
            .foregroundColor(.green)
        } else {
          Text("Not signed in Username: N/A")
            .foregroundColor(.red)
        }
        
        if productCommManager.registered {
          Text("Registered")
            .foregroundColor(.green)
        } else {
          Text("Unregistered")
            .foregroundColor(.red)
        }
        
        if productCommManager.connected {
          Text("Connected")
            .foregroundColor(.green)
        } else {
          Text("Disconnected")
            .foregroundColor(.red)
        }
        
        TextField("Region", text: $region)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 240)
          .padding()
        
        Spacer()
        
        HStack {
          Button(action: onTapSignIn) {
            Text("Sign in")
              .foregroundColor(Color.white)
              .padding()
              .background(Color.blue)
              .cornerRadius(100)
          }
          
          Button(action: onTapLaunch) {
            Text("Launch")
              .foregroundColor(Color.white)
              .padding()
              .background(Color.blue)
              .cornerRadius(100)
          }
          .disabled(!productCommManager.registered || !productCommManager.connected)
        }
        
        Spacer()
      }
      .onAppear(perform: onAppear)
      .navigationBarTitle("")
      .navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
      .sheet(isPresented: $shouldSignIn) {
        LoginView(username: $username)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(productCommManager: ProductCommunicationService())
      .previewLayout(PreviewLayout.fixed(width: 844, height: 390))
  }
}
