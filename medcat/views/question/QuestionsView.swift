//
//  QuestionsView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct QuestionsView: View {
  @State var isFormVisible = false
  @State var isFiltersVisible = false
  
  @State private var sorting: Int = 0
  @State private var filter: Int = 0
  
  @EnvironmentObject private var sessionStore: SessionStore
  @ObservedObject private var store = QuestionStore.shared
  
  var filteredQuestions: [Question] {
    var questions = self.store.questions
    
    switch (self.filter) {
      case 1:
        questions = questions.filter { $0.answer != nil }

      case 2:
        questions = questions.filter { $0.uid == self.sessionStore.session?.uid }

      default: break;
    }
    
    switch (self.sorting) {
      case 1:
        questions = questions.sorted(by: { $0.likes > $1.likes })
      default: break
    }
    
    return questions
  }
  
  func toggleLike(_ id: String, isLiked: Bool, completion: ((Error?) -> ())?) {
    guard let uid = sessionStore.session?.uid else { return }
    
    if isLiked {
      store.like(id, uid: uid, completion: completion)
    } else {
      store.dislike(id, uid: uid, completion: completion)
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        if filteredQuestions.isEmpty {
          NoDataView(text: "No Questions")
        } else {
          List(filteredQuestions) { question in
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
      .navigationBarItems(
        leading: Button(action: {
          self.isFiltersVisible = !self.isFiltersVisible
        }) {
          Image(systemName: (self.sorting > 0 || self.filter > 0) ?  "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
            .resizable()
            .frame(width: 16, height: 16)
        }.popover(isPresented: $isFiltersVisible) {
          FiltersAndSortingView(filter: self.$filter, sorting: self.$sorting, isVisible: self.$isFiltersVisible)
        },
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
    }
  }
}

struct QuestionsView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionsView().environmentObject(SessionStore())
  }
}
