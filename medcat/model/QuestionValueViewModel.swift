//
//  QuestionViewModel.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 29.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine

class QuestionValueViewModel: ObservableObject {
  @Published var value: String = ""
  @Published var isValid = false
  @Published var message = ""

  var max: Int = 10
  
  private var cancellableSet: Set<AnyCancellable> = []
  
  init(max: Int) {
    self.max = max
//    message = "\(value.words) / \(max) max words"
  }
  
  private var isTitleEmpty: AnyPublisher<Bool, Never> {
    $value
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0 == "" }
      .eraseToAnyPublisher()
  }
  
  private var valueLimitExceeded: AnyPublisher<Bool, Never> {
    $value
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.words >  self.max }
      .eraseToAnyPublisher()
  }
  
  private var message: AnyPublisher<String, Never> {
    $value
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { "\($0.words) / \(self.max) max words" }
      .eraseToAnyPublisher()
  }
}
