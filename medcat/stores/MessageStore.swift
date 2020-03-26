//
//  MessageStore.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

class MessageStore: ObservableObject {
  let collection = Firestore.firestore().collection("messages")
  var listener: ListenerRegistration?

  @Published var messages = [Message]()
  
  func load() {
    listen()
  }
  
  func listen() {
    listener = collection.addSnapshotListener { snapshot, error in
      if error != nil {
        print("\((error?.localizedDescription)!)")
        return
      }
      
      snapshot?.documentChanges.forEach { diff in
        if diff.type == .added {
          self.messages.append(Message.from(documentSnapshot: diff.document))
        }
        
        if diff.type == .modified {
          self.messages = self.messages.map { message -> Message in
            guard message.id == diff.document.documentID else { return message }
            
            return Message.from(documentSnapshot: diff.document)
          }
        }
      }
    }
  }

  deinit {
    listener?.remove()
  }
}

struct Message: Identifiable {
  var id: String
  var title: String
  var summary: String
  var body: String
  var createdAt: Date
  var author: String?
  var type: String?

  init(id: String, title: String, summary: String, body: String, createdAt: Date, author: String? = nil, type: String? = nil) {
    self.id = id
    self.title = title
    self.summary = summary
    self.body = body
    self.createdAt = createdAt
    self.author = author
    self.type = type
  }
  
  static func from(documentSnapshot: QueryDocumentSnapshot) -> Message {    
    return Message(
      id: documentSnapshot.documentID,
      title: documentSnapshot.get("title") as? String ?? "",
      summary: documentSnapshot.get("summary") as? String ?? documentSnapshot.get("text") as? String ?? "",
      body: documentSnapshot.get("text") as? String ?? "",
      createdAt: (documentSnapshot.get("createdAt") as? Timestamp)?.dateValue() ?? Date(),
      author: documentSnapshot.get("authorName") as? String,
      type: documentSnapshot.get("type") as? String
    )
  }
}
