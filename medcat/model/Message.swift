//
//  Message.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 30.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message: Model {
  static var collectionName: String = "messages"
  
  var id: String
  var title: String
  var summary: String
  var body: String
  var createdAt: Date
  var author: String?
  var type: String?
  
  init(_ snapshot: QueryDocumentSnapshot) {
    self.id = snapshot.documentID
    self.title = snapshot.get("title") as? String ?? ""
    self.summary = snapshot.get("summary") as? String ?? snapshot.get("text") as? String ?? ""
    self.body = snapshot.get("text") as? String ?? ""
    self.createdAt = (snapshot.get("createdAt") as? Timestamp)?.dateValue() ?? Date()
    self.author = snapshot.get("authorName") as? String
    self.type = snapshot.get("type") as? String
  }
  
  init(id: String, title: String, summary: String, body: String, createdAt: Date, author: String? = nil, type: String? = nil) {
    self.id = id
    self.title = title
    self.summary = summary
    self.body = body
    self.createdAt = createdAt
    self.author = author
    self.type = type
  }
}
