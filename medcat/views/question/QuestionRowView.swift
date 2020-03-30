//
//  QuestionRowView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX
import FirebaseCrashlytics

typealias ToggleLikeFunc = (String, Bool, ((Error?) -> ())?) -> Void

struct QuestionRowView: View {
  var question: Question
  var isLiked: Bool

  @EnvironmentObject private var sessionStore: SessionStore

  @State private var isAnswerVisible = false
  @State private var isSending = false
  
  private var likesStore = DataStore<Like>(true)
  
  
  init(_ question: Question, likes: [Like] = []) {
    self.question = question
    self.isLiked = likes.contains(where: { $0.id == question.id })
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 10) {
          Text(question.title)
            .font(.headline)
          
          Text(question.body)
            .font(.subheadline)
          
          if question.createdAt != nil {
            HStack {
              Text(Formatter.date.string(from: question.createdAt!))
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }

        Spacer()

        if isSending {
          ActivityIndicator()
            .padding(.top, 18)
            .padding(.trailing, 8)
        } else {
          LikesView(likes: question.likes, isLiked: isLiked, onLike: { isLiked in
            self.isSending = true
            
            if isLiked {
              self.likesStore.set(Like(self.question.id), user: self.sessionStore.session!) { error in
                self.isSending = false
                if let error = error {
                  print("Like error: \(error.localizedDescription)")
                  Crashlytics.crashlytics().record(error: error)
                }
              }
            } else {
              self.likesStore.delete(Like(self.question.id), from: self.sessionStore.session!) { error in
                self.isSending = false
                if let error = error {
                  print("Dislike error: \(error.localizedDescription)")
                  Crashlytics.crashlytics().record(error: error)
                }
              }
            }
          })
        }
      }
      .padding(.vertical, 5)
      if question.answer != nil {
        VStack(alignment: .leading, spacing: 10) {
          AuthorDateRow(author: question.answer!.author, date: question.answer!.createdAt)
          Divider()
          Text(question.answer!.body)
            .font(.subheadline)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .cornerRadius(10)
        .background(Color.yellow.opacity(0.1))
      }
      
      Spacer()
    }
  }
}

struct QuestionRowView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionRowView(Question(
      id: "",
      uid: "",
      title: "Question #1",
      body: """
Question multiline
body ...
""",
      answer: Answer(
        author: "coliquio GmbH",
        body: "Answer text",
        createdAt: Date()
      )
    ))
  }
}
