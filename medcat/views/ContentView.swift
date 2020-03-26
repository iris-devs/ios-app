//
//  ContentView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var session: SessionStore  
  @State private var selection = 0
  
  func getUser() {
    session.listen()
  }
  
  var body: some View {
    Group {
      if session.session != nil {
        TabView(selection: $selection) {
          WithFloatingButton {
            MessagesView()
          }
          .tabItem {
            VStack {
              Image(systemName: "bolt.circle.fill")
              Text("News")
            }
          }
          .tag(0)
          WithFloatingButton {
            QuestionsView()
          }
          .tabItem {
            VStack {
              Image(systemName: "questionmark.circle.fill")
              Text("Questions")
            }
          }
          .tag(1)
          AccountView()
            .tabItem {
              VStack {
                Image(systemName: "person.circle.fill")
                Text("Account")
              }
          }
          .tag(2)
        }
      } else {
        SignInView()
      }
    }.onAppear(perform: getUser)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(SessionStore())
  }
}
