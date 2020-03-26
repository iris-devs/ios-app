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
  
  func toggleLike(_ id: String, isLiked: Bool, completion: ((Error?) -> ())?) {
    guard let uid = sessionStore.session?.uid else { return }
    
    if isLiked {
      store.like(id, uid: uid, completion: completion)
    } else {
      store.dislike(id, uid: uid, completion: completion)
    }
  }
  
  var body: some View {
    Group {
      if store.questions.isEmpty {
        NoDataView(text: "No questions")
      } else {
        List(store.questions) { question in
          QuestionRowView(
            question,
            likes: self.store.likes,
            toogleLikeFunc: self.toggleLike
          )
        }
      }
    }
    .onAppear(perform: {
      self.store.listen()
      if let uid = self.sessionStore.session?.uid {
        self.store.reloadLikes(uid)
      }
    })
      .navigationBarTitle("Questions")
  }
}

struct QuestionsView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionsView().environmentObject(SessionStore())
  }
}
