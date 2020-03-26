//
//  QuestionRowView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct QuestionRowView: View {
  var question: Question
  
  init(_ question: Question) {
    self.question = question
  }
  
  var body: some View {
    VStack {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 10) {
          Text(question.title)
            .font(.headline)
          
          Text(question.body)
            .font(.subheadline)
            .lineLimit(5)
          
          if question.createdAt != nil {
            HStack {
              Text(Formatter.date.string(from: question.createdAt!))
                .font(.caption)
                .foregroundColor(.secondary)
              
              //            Spacer()
              //            if message.author != nil {
              //              Text(message.author!)
              //                .font(.caption)
              //                .foregroundColor(.secondary)
              //            }
            }
          }
        }
        
        Spacer()
        LikesView(likes: question.likes)
      }
      .padding(.vertical, 5)
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
"""
    ))
  }
}
