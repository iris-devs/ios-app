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
  @ObservedObject private var passwordViewModel = PasswordViewModel()

  @Binding var isVisible: Bool
  @EnvironmentObject var session: SessionStore

  func save() {
    guard passwordViewModel.isValid else { return }
    
    print("Test")
    self.isVisible = false
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Enter your new password"), footer: Text(passwordViewModel.passwordMessage).foregroundColor(.red)) {
          SecureField("New Password", text: $passwordViewModel.password)
          SecureField("Confirm Password", text: $passwordViewModel.passwordConfirm)
        }
      }
      .navigationBarTitle("Change Password")
      .navigationBarItems(
        leading: Button("Cancel") { self.isVisible = false },
        trailing: Button("Save", action: self.save)
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
