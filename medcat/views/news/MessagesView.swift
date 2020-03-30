//
//  MessagesView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct MessagesView: View {
  @ObservedObject private var dataStore = DataStore<Message>()
  @EnvironmentObject private var sessionStore: SessionStore
  
  @State var isFormVisible = false
  var messages: [Message] {
    dataStore.items.sorted(by: { $0.createdAt > $1.createdAt })
  }
  
  init() {
    UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
  }
  
  var body: some View {
    NavigationView {
      Group {
        if messages.isEmpty {
          NoDataView(text: "No News", imageName: "bolt.slash.fill")
        } else {
          NewsListView(news: messages)
        }
      }
      .navigationBarTitle("News", displayMode: .large)
      .navigationBarItems(
        trailing: Button(action: {
          self.isFormVisible = true
        }) {
          HStack {
            Image(systemName: "message.fill")
              .resizable()
              .frame(width: 16, height: 16)
            Text("Ask Question")
          }
        }.sheet(isPresented: $isFormVisible) {
          QuestionFormView(isVisible: self.$isFormVisible)
            .environmentObject(self.sessionStore)
        }
      )
    }.onAppear {
      self.dataStore.subscribe(self.sessionStore.session)
    }
  }
}

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView()
  }
}
