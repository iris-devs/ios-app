//
//  SessionStore.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Combine
import Firebase
import SwiftUI

class SessionStore: ObservableObject {
  var didChange = PassthroughSubject<SessionStore, Never>()
  let userCollection = Firestore.firestore().collection("users")

  @Published var session: User? {
    didSet { self.didChange.send(self) }
  }

  var authHandle: AuthStateDidChangeListenerHandle?
  var userListener: ListenerRegistration?
  
  func listen() {
    authHandle  = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if let user = user {
        self.session = User(uid: user.uid, email: user.email, displayName: user.displayName)
        self.userListener = self.userCollection.document(user.uid).addSnapshotListener({ (documentSnapshot, error) in
          guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
          }
          
          self.session?.setMetaInfoFrom(document: document)
        })
      } else {
        self.session = nil
        self.userListener?.remove()
      }
    })
  }

  func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
    Auth.auth().signIn(withEmail: email, password: password, completion: handler)
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
      self.session = nil
    } catch {
      print("Error")
    }
  }
  
  func unbind() {
    guard let handle = authHandle else { return }
    Auth.auth().removeStateDidChangeListener(handle)
  }
  
  deinit {
    unbind()
  }
}

struct User {
  var uid: String
  var email: String?
  var displayName: String?
  var org: String?
  var state: String?
  var phone: String?
  var photoUrl: URL?
  
  init(uid: String, email: String?, displayName: String?) {
    self.uid = uid
    self.email = email
    self.displayName = displayName
  }
  
  mutating func setMetaInfoFrom(document: DocumentSnapshot) {
    self.displayName = document.get("fullName") as? String
    self.org = document.get("org") as? String
    self.state = document.get("state") as? String
    self.phone = document.get("phone") as? String
    
    if let photoUrl = document.get("photoUrl") as? String {
      self.photoUrl = URL(string: photoUrl)
    }
  }
}
