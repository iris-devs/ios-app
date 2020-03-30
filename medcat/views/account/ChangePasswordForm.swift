//
//  ChangePasswordForm.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 28.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct ChangePasswordForm: View {
  @State private var error: Error? = nil
  @State private var isErrorVisible: Bool = false
  @ObservedObject private var passwordViewModel = PasswordViewModel()

  @Binding var isVisible: Bool
  @EnvironmentObject var session: SessionStore

  func save() {
    self.error = nil
    guard passwordViewModel.isValid else { return }
    
    session.changePassword(passwordViewModel.password) { error in
      if let error = error {
        self.isErrorVisible = true
        self.error = error
        return
      }

      self.isVisible = false
    }
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(
          header: Text("Enter your new password"),
          footer: Text(passwordViewModel.passwordMessage).foregroundColor(.red)
        ) {
          SecureField("New Password", text: $passwordViewModel.password)
          SecureField("Confirm Password", text: $passwordViewModel.passwordConfirm)
        }.alert(isPresented: $isErrorVisible) {
          Alert(title: Text(self.error?.localizedDescription ?? "Unknown error"))
        }
      }
      .navigationBarTitle("Change Password")
      .navigationBarItems(
        leading: Button("Cancel") { self.isVisible = false },
        trailing: Button("Save", action: self.save).disabled(!passwordViewModel.isValid)
      )
    }
  }
}

struct ChangePasswordForm_Previews: PreviewProvider {
  static var previews: some View {
    ChangePasswordForm(isVisible: .constant(true))
      .environmentObject(SessionStore())
  }
}
