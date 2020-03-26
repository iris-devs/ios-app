//
//  MessagesView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct MessagesView: View {
  @ObservedObject private var store = MessageStore()

  init() {
    UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    self.store.load()
  }
  
  var body: some View {
    Group {
      if store.messages.isEmpty {
        NoDataView(text: "No news", imageName: "bolt.slash.fill")
      } else {
        NewsListView(news: store.messages.sorted(by: { $0.createdAt > $1.createdAt }))
      }
    }
  }
}

struct MessagesView_Previews: PreviewProvider {
  static var previews: some View {
    MessagesView()
  }
}
