//
//  CategoryStore.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore

class QuestionStore: ObservableObject {
  static let shared = QuestionStore()
  
  let categoryCollection = Firestore.firestore().collection("categories")
  let questionCollection = Firestore.firestore().collection("questions")
  
  var questionRef: DocumentReference? = nil
  var questionListener: ListenerRegistration?
  
  @Published var questions = [Question]()
  @Published var categories = [Category]()
  
  var listener: ListenerRegistration?
  
  func loadCategories() {
    categoryCollection.getDocuments() { querySnapshot, err in
      if let err = err {
        print("Error: \(err)")
      } else {
        let categories = querySnapshot?.documents.compactMap { documentSnapshot -> Category? in
          let lang = Locale.current.languageCode ?? "unknown"
          guard let title = documentSnapshot.get("title_\(lang)") as? String
            ?? documentSnapshot.get("title") as? String
            else { return nil }
          
          return Category(id: documentSnapshot.documentID, title: title)
        }
        
        self.categories = categories ?? []
      }
    }
  }
  
  func addQuestion(_ question: Question, handler: @escaping (Error?) -> ()) {
    questionCollection.addDocument(data: question.toDictionary(), completion: handler)
  }
  
  func load(_ completion: ((Error?) -> ())? = nil) {
    questionCollection.order(by: "createdAt", descending: true).getDocuments { querySnapshot, err in
      if let err = err {
        print("Error: \(err)")
        completion?(err)
        return
      }
      
      let questions = querySnapshot?.documents.compactMap { documentSnapshot -> Question? in
        return Question.from(documentSnapshot)
      }
      
      self.questions = questions ?? []
      completion?(nil)
    }
  }
  
  func listen() {
    guard listener == nil else { return }
    listener = questionCollection.addSnapshotListener { querySnapshot, error in
      if error != nil {
        print("\(error!.localizedDescription)")
        return
      }
      
      self.load()
    }
  }
  
  deinit {
    listener?.remove()
  }
}


struct Category: Identifiable {
  var id: String
  var title: String
}

struct Question: Identifiable {
  var id: String
  var uid: String
  var title: String
  var category: String
  var body: String
  var likes: Int = 0
  var createdAt: Date?
  var answer: Answer?
  
  func toDictionary() -> Dictionary<String, String> {
    return [
      "title": self.title,
      "category": self.category,
      "body": self.body,
      "uid": self.uid
    ]
  }
  
  static func from(_ documentSnapshot: QueryDocumentSnapshot) -> Question? {
    guard let uid = documentSnapshot.get("uid") as? String,
      let title = documentSnapshot.get("title") as? String,
      let category = documentSnapshot.get("category") as? String,
      let body = documentSnapshot.get("body") as? String
      else { return nil }
    
    let likes = documentSnapshot.get("likes") as? Int ?? 0
    let createdAt = (documentSnapshot.get("createdAt") as? Timestamp)?.dateValue()
    
    var answer: Answer? = nil
    
    if let comment = documentSnapshot.get("comment") as? Dictionary<String, Any> {
      if let body = comment["body"] as? String, let authorName = comment["authorName"] as? String {
        answer = Answer(
          author: authorName,
          body: body,
          createdAt: (comment["createdAt"] as? Timestamp)?.dateValue()
        )
      }
    }

    return Question(
      id: documentSnapshot.documentID,
      uid: uid,
      title: title,
      category: category,
      body: body,
      likes: likes,
      createdAt: createdAt,
      answer: answer
    )
  }
}

struct Answer {
  var author: String
  var body: String
  var createdAt: Date?
}
