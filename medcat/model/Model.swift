//
//  Model.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 30.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol Model: Identifiable where ID == String {
  init(_ snapshot: QueryDocumentSnapshot)
  static var collectionName: String { get }
}

protocol ConvertableModel: Model {
  func toDictionary() -> Dictionary<String, Any>
}
