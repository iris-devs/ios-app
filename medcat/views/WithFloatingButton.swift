//
//  WithFloatingButton.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 24.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct WithFloatingButton<ChildView: View>: View {
  @State var isVisible: Bool = false
  
  let childView: ChildView
  init(_ childView: () -> (ChildView)) {
    self.childView = childView()
  }
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        ZStack(alignment: .topLeading) {
          childView
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
        NavigationLink(destination: QuestionFormView(isVisible: $isVisible), isActive: $isVisible) {
          EmptyView()
        }
        
//        HStack {
//          Button(action: {
//            self.isVisible = true
//          }) {
//            HStack {
//              Image(systemName: "message.fill")
//                .resizable()
//                .frame(width: 24, height: 24)
//                .foregroundColor(.white)
//                .padding(20)
//            }
//            .frame(width: 48, height: 48)
//            .background(Color.blue)
//            .clipShape(Circle())
//            .shadow(radius: 5)
//          }
//        }
//        .padding(20)
      }
      .navigationBarItems(trailing: Button(action: {
        self.isVisible = true
      }) {
        HStack {
          Image(systemName: "message.fill")
          .resizable()
          .frame(width: 16, height: 16)
          Text("Ask question")
        }
      })
    }
  }
}

struct WithFloatingButton_Previews: PreviewProvider {
  static var previews: some View {
    WithFloatingButton {
      Text("Hello, world!")
    }
  }
}
