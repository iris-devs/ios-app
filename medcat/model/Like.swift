//
//  Like.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 30.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Like: ConvertableModel {
  static var collectionName = "likes"

  var id: String

  init(_ snapshot: QueryDocumentSnapshot) {
    self.id = snapshot.documentID
  }
  
  init(_ id: String) {
    self.id = id
  }
  
  func toDictionary() -> Dictionary<String, Any> {
    [
      "id": self.id,
      "createdAt": FieldValue.serverTimestamp()
    ]
  }
}
