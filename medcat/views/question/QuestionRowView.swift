//
//  QuestionRowView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

typealias ToggleLikeFunc = (String, Bool, ((Error?) -> ())?) -> Void

struct QuestionRowView: View {
  var question: Question
  var isLiked: Bool
  var toggleLike: ToggleLikeFunc?

  @State private var isAnswerVisible = false
  @State private var isSending = false
  
  init(_ question: Question, likes: [String] = [], toogleLikeFunc: ToggleLikeFunc? = nil) {
    self.question = question
    self.isLiked = likes.contains(question.id)
    self.toggleLike = toogleLikeFunc
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
            self.toggleLike?(self.question.id, isLiked) { error in
              if let error = error {
                print("Error: \(error)")
              }
              self.isSending = false
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
      category: "coffee_break",
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
