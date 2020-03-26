//
//  AccountView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct AccountView: View {
  @EnvironmentObject var session: SessionStore
  
  var body: some View {
    NavigationView {
      VStack {
        Group {
          if session.session != nil {
            UserProfileView(user: session.session!)
          } else {
            EmptyView()
          }
        }
      }.navigationBarTitle("My account")
    }
  }
}

struct AccountView_Previews: PreviewProvider {
  static var previews: some View {
    AccountView().environmentObject(SessionStore())
  }
}
