//
//  QuestionViewModel.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 29.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine

enum QuestionValueCheck {
  case valid
  case empty
  case limitExceeded
}

// Unfortunately doesn't work with TextView, not possible to use,
// seems like SwiftUI bug
class QuestionValueViewModel: ObservableObject {
  var max: Int = 0

  @Published var value = ""
  @Published var message = ""
  @Published var isValid = false
  
  private var cancellableSet: Set<AnyCancellable> = []
  
  init(max: Int) {
    self.max = max

    isValidPublisher
      .receive(on: RunLoop.main)
      .map { result -> String in
        switch result {
          case .empty:
            return "Must not be empty"
          case .limitExceeded:
            return "\(self.value.words) / \(max) max words limit exceeded"
          default:
            return "\(self.value.words) / \(max) max words"
        }
    }
    .assign(to: \.message, on: self)
    .store(in: &cancellableSet)
    
    isValidPublisher
      .receive(on: RunLoop.main)
      .map { $0 == .valid }
      .assign(to: \.isValid, on: self)
      .store(in: &cancellableSet)
  }
  
  private var isEmptyPublisher: AnyPublisher<Bool, Never> {
    $value
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.isEmpty }
      .eraseToAnyPublisher()
  }
  
  private var valueLimitExceededPublisher: AnyPublisher<Bool, Never> {
    $value
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.words >  self.max }
      .eraseToAnyPublisher()
  }
  
  private var isValidPublisher: AnyPublisher<QuestionValueCheck, Never> {
    Publishers.CombineLatest(isEmptyPublisher, valueLimitExceededPublisher)
      .map { isEmpty, limitExceeded in
        if isEmpty {
          return .empty
        }
        
        if limitExceeded {
          return .limitExceeded
        }
        
        return .valid
    }
    .eraseToAnyPublisher()
  }
}
