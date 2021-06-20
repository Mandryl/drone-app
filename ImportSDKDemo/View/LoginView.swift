//
//  LoginView.swift
//  ImportSDKDemo
//
//  Created by 仙北谷知将 on 2021/06/19.
//

import SwiftUI
import Amplify

struct LoginView: View {
  @Environment(\.presentationMode) var presentation
  
  @Binding var username: String
  
  @State private var password = ""
  @State private var needAlert = false
  @State private var alertMessage = ""
  
  private func onTapSignIn() {
    let _ = Amplify.Auth.signIn(username: username, password: password)
      .resultPublisher
      .sink {
        if case let .failure(authError) = $0 {
          alertMessage = "Sign in failed \(authError)"
          needAlert = true
          print(alertMessage)
        }
      }
      receiveValue: { _ in
        alertMessage = "Sign in succeeded"
        needAlert = true
        print(alertMessage)
      }
  }
  
  var body: some View {
    VStack {
      
      Spacer()
      
      TextField("Username", text: $username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      SecureField("Password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Spacer()
      
      Button(action: onTapSignIn) {
        Text("Sign in")
          .foregroundColor(Color.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(100)
      }
      
      Spacer()
    }
    .alert(isPresented: $needAlert) {
      Alert(
        title: Text("Sign in"),
        message: Text(alertMessage),
        dismissButton: .default(Text("OK"), action: {
          presentation.wrappedValue.dismiss()
        })
      )
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  
  @State static var username = ""
  
  static var previews: some View {
    LoginView(username: $username)
      .previewLayout(PreviewLayout.fixed(width: 844, height: 390))
  }
}
