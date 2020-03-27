//
//  UserProfileView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SDWebImage
import SDWebImageSwiftUI

struct UserProfileView: View {
  @EnvironmentObject var session: SessionStore
  
  func signOut() {
    session.signOut()
  }

  var user: User
  
  var body: some View {
    ScrollView(.vertical) {
      VStack {
        VStack(alignment: .center, spacing: 20) {
          WebImage(url: user.photoUrl)
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.progress)
            .animation(.easeInOut(duration: 0.5))
            .transition(.fade)
            .scaledToFill()
            .frame(width: 128, height: 128, alignment: .center)
            .cornerRadius(64)
          
          Text(user.displayName ?? user.email!)
            .font(.title)
            .padding(.bottom, 15)
          Divider()
        }

        VStack(alignment: .leading, spacing: 0) {
          UserProfileSectionView(title: "E-Mail", text: user.email!)
          if user.org != nil {
            UserProfileSectionView(title: "Organisation", text: user.org!)
          }
          if user.state != nil {
            UserProfileSectionView(title: "State", text: user.state!)
          }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        
        HStack(spacing: 0) {
          Spacer()
          Button(action: signOut) {
            Text("Sign Out")
              .foregroundColor(.gray)
              .padding(10)
          }
          .border(Color.gray, width: 2)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
      }.padding(20)
    }.navigationBarTitle("My Account")
  }
}

struct UserProfileView_Previews: PreviewProvider {
  static var previews: some View {
    UserProfileView(user: User(
      uid: "test",
      email: "vitali.stsepaniuk@coliquio.de",
      displayName: "Vitali Stsepaniuk"
    )).environmentObject(SessionStore())
  }
}
