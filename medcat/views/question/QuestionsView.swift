//
//  QuestionsView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

enum QuestionStateSet: CaseIterable {
  case all
  case answered
  case my

  var asString: String {
    switch self {
      case .all:
        return "All"
      case .my:
        return "My"
      case .answered:
        return "Answered"
    }
  }
}

struct QuestionsView: View {
  @State private var currentQuestionStateSet: QuestionStateSet = .all
  
  @EnvironmentObject private var sessionStore: SessionStore
  @ObservedObject private var store = QuestionStore.shared
  
  var body: some View {
    Group {
      if store.questions.isEmpty {
        NoDataView(text: "No questions")
      } else {
        List(store.questions) { question in
          QuestionRowView(question)
        }
      }
    }
    .onAppear(perform: {
      self.store.listen()
    })
    .navigationBarTitle("Questions")
  }
}

struct QuestionsView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionsView().environmentObject(SessionStore())
  }
}
