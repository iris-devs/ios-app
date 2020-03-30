//
//  PasswordViewModel.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 28.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import Combine
import Navajo_Swift

enum PasswordCheck {
  case valid
  case empty
  case noMatch
  case notStrongEnough
}

class PasswordViewModel: ObservableObject {
  @Published var password = ""
  @Published var passwordConfirm = ""
  @Published var passwordMessage = ""
  @Published var isValid = false
  
  private var cancellableSet: Set<AnyCancellable> = []
  
  init() {
    isValidPublisher
      .receive(on: RunLoop.main)
      .map { passwordCheck in
        switch passwordCheck {
          case .empty:
            return "Password must not be empty"
          case .noMatch:
            return "Passwords do not match"
          case .notStrongEnough:
            return "Password not strong enough"
          default:
            return ""
        }
    }
    .assign(to: \.passwordMessage, on: self)
    .store(in: &cancellableSet)
    
    isValidPublisher
      .receive(on: RunLoop.main)
      .map { $0 == .valid }
      .assign(to: \.isValid, on: self)
      .store(in: &cancellableSet)
  }
  
  private var isEmptyPublisher: AnyPublisher<Bool, Never> {
    $password
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0 == ""}
      .eraseToAnyPublisher()
  }
  
  private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($password, $passwordConfirm)
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .map { $0 == $1 }
      .eraseToAnyPublisher()
  }
  
  private var strengthPublisher: AnyPublisher<PasswordStrength, Never> {
    $password
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { Navajo.strength(ofPassword: $0) }
      .eraseToAnyPublisher()
  }
  
  private var isStrongEnoughPublisher: AnyPublisher<Bool, Never> {
    strengthPublisher
      .map { strength in
        switch strength {
          case .reasonable, .strong, .veryStrong:
            return true
          default:
            return false
        }
    }
    .eraseToAnyPublisher()
  }
  
  private var isValidPublisher: AnyPublisher<PasswordCheck, Never> {
    Publishers.CombineLatest3(isEmptyPublisher, arePasswordsEqualPublisher, isStrongEnoughPublisher)
      .map { passwordIsEmpty, passwordsAreEqual, passwordIsStrongEnough in
        if (passwordIsEmpty) {
          return .empty
        }
        else if (!passwordsAreEqual) {
          return .noMatch
        }
        else if (!passwordIsStrongEnough) {
          return .notStrongEnough
        }
        
        return .valid
    }
    .eraseToAnyPublisher()
  }
}
