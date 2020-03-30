//
//  Question.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 30.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Question: ConvertableModel {
  static var collectionName = "questions"
  
  var id: String
  var uid: String
  var title: String
  var body: String
  var likes: Int = 0
  var createdAt: Date?
  var answer: Answer?
  var author: String?
  
  init(_ snapshot: QueryDocumentSnapshot) {
    self.id = snapshot.documentID
    self.uid = snapshot.get("uid") as? String ?? ""
    self.title = snapshot.get("title") as? String ?? ""
    self.body = snapshot.get("body") as? String ?? ""
    self.likes = snapshot.get("likes") as? Int ?? 0
    self.createdAt = (snapshot.get("createdAt") as? Timestamp)?.dateValue()
    self.author = snapshot.get("authorName") as? String

    var answer: Answer? = nil
    
    if let comment = snapshot.get("comment") as? Dictionary<String, Any> {
      if let body = comment["body"] as? String, let authorName = comment["authorName"] as? String {
        answer = Answer(
          author: authorName,
          body: body,
          createdAt: (comment["createdAt"] as? Timestamp)?.dateValue()
        )
      }
    }
    
    self.answer = answer
  }
  
  init(id: String, uid: String, title: String, body: String, author: String? = nil, answer: Answer? = nil) {
    self.id = id
    self.uid = uid
    self.title = title
    self.body = body
    self.answer = answer
    self.author = author
  }
  
  func toDictionary() -> Dictionary<String, Any> {
    return [
      "id": self.id,
      "uid": self.uid,
      "title": self.title,
      "body": self.body,
      "createdAt": FieldValue.serverTimestamp()
    ]
  }
}

struct Answer {
  var author: String
  var body: String
  var createdAt: Date?
}
