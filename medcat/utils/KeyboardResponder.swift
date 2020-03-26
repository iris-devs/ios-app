//
//  KeyboardResponder.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 26.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
  let didChange = PassthroughSubject<KeyboardResponder, Never>()
  private var _center: NotificationCenter
  @Published var currentHeight: CGFloat = 0 {
    didSet { self.didChange.send(self) }
  }
  
  init(center: NotificationCenter = .default) {
    _center = center
    _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  deinit {
    _center.removeObserver(self)
  }
  
  @objc func keyBoardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      currentHeight = keyboardSize.height
    }
  }
  
  @objc func keyBoardWillHide(notification: Notification) {
    currentHeight = 0
  }
}
