//
//  SignInView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct SignInView: View {
  @State var email: String = ""
  @State var password: String = ""
  @State var error: String = ""
  @State var isLoading: Bool = false
  
  @EnvironmentObject var session: SessionStore
  
  func signIn() {
    isLoading = true
    error = ""
    
    session.signIn(email: email, password: password) { result, error in
      self.isLoading = false
      
      if let error = error {
        self.error = error.localizedDescription
      }
    }
  }
  
  func forgotPassword() {
    
  }
  
  var body: some View {
    ScrollView {
      VStack {
        Image("logo")
          .resizable()
          .scaledToFit()
          .frame(maxWidth: .infinity)
          .padding(.top, 50)
        
        //      Text("Please sign-in")
        //        .font(.title)
        //        .foregroundColor(.secondary)
        
        if error != "" {
          Text(error)
            .font(.body)
            .foregroundColor(.red)
            .padding(.vertical, 10)
        }
        
        VStack {
          HStack(spacing: 10.0) {
            Image(systemName: "envelope")
              .resizable()
              .foregroundColor(.gray)
              .scaledToFit()
              .frame(width: 12, height: 12)
            
            TextField("E-mail", text: $email)
              .textContentType(.emailAddress)
              .keyboardType(.emailAddress)
              .autocapitalization(.none)
              .font(.body)
          }
          .padding(10)
          Divider()
          
          HStack(spacing: 10.0) {
            Image(systemName: "lock.shield")
              .resizable()
              .foregroundColor(.gray)
              .scaledToFit()
              .frame(width: 12, height: 12)
            
            SecureField("Password", text: $password)
              .font(.body)
          }
          .padding(10)
          Divider()
        }.padding(.bottom, 15)
        
        VStack(spacing: 10) {
          Button(action: signIn) {
            HStack(spacing: 5) {
              if isLoading {
                ActivityIndicator()
              }
              
              Text("Sign in")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.white)
                .font(.body)
                .background(Color.blue)
                .cornerRadius(4)
            }
          }
          .disabled(isLoading)          
//          Button(action: forgotPassword) {
//            Text("Forgot password?")
//          }
//          .foregroundColor(.gray)
//          .disabled(isLoading)
        }
        
        Spacer()
      }
    }.padding(20)
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView().environmentObject(SessionStore())
  }
}
