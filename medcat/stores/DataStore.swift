//
//  DataStore.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 30.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseCrashlytics

class DataStore<T: Model>: ObservableObject {
  private let db = Firestore.firestore()
  private var listener: ListenerRegistration?
  private var listenOnUserCollection: Bool
  
  @Published var items = [T]()
  
  init(_ listenOnUserCollection: Bool = false) {
    self.listenOnUserCollection = listenOnUserCollection
  }
  
  func subscribe(_ user: User?) {
    guard let user = user, listener == nil else { return }
    var query: Query
    
    if listenOnUserCollection {
      query = db.collection("users").document(user.uid).collection(T.collectionName)
    } else {
      var roles: [String] = ["public"]
      if let userRoles = user.roles {
        roles += userRoles
      }
      
      query = db.collection(T.collectionName)
        .whereField("roles", arrayContainsAny: roles)
      
      // Small hack, while firestore doesn't support OR queries
      if T.self == Message.self {
        query = query
          .whereField("isPublished", isEqualTo: true)
          .whereField("isDeleted", isEqualTo: false)
      }
    }
    
    listener = query.addSnapshotListener { snapshot, error in
      guard error == nil else {
        print("Datastore::subscribe: \(error!.localizedDescription)")
        Crashlytics.crashlytics().record(error: error!)
        return
      }
      
      snapshot?.documentChanges.forEach { diff in
        switch diff.type {
          case .added:
            self.items.append(T(diff.document))
          case .modified:
            self.items = self.items.map { item -> T in
              guard item.id == diff.document.documentID else { return item }
              return T(diff.document)
          }
          case .removed:
            self.items = self.items.filter { $0.id != diff.document.documentID }
        }
      }
    }
  }
  
  func add<T: ConvertableModel>(_ record: T, completion: ((Error?) -> ())? = nil) {
    db.collection(T.collectionName).addDocument(data: record.toDictionary(), completion: completion)
  }
  
  func set<T: ConvertableModel>(_ record: T, user: User, completion: ((Error?) -> ())? = nil) {
    db.collection("users")
      .document(user.uid)
      .collection(T.collectionName)
      .document(record.id)
      .setData(record.toDictionary(), completion: completion)
  }
  
  func delete(_ record: T, from user: User, completion: ((Error?) -> ())? = nil) {
    db.collection("users").document(user.uid).collection(T.collectionName).document(record.id).delete(completion: completion)
  }
  
  deinit {
    listener?.remove()
    listener = nil
  }
}
