//
//  AccountButton.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 28.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct AccountButton: View {
  typealias AccountButtonAction = () -> ()

  var title: String
  var action: AccountButtonAction
  
  init(_ title: String, _ action: @escaping AccountButtonAction) {
    self.title = title
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .foregroundColor(.gray)
        .padding(10)
    }
    .border(Color.gray, width: 2)
  }
}

struct AccountButton_Previews: PreviewProvider {
  static var previews: some View {
    AccountButton("Change password") {
      print("Clicked")
    }
  }
}
