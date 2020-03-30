//
//  QuestionValidationMessage.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 29.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct QuestionValidationMessage: View {
  var text: String
  var max: Int
  
  private var isValid: Bool {
    return text.words > 0 && text.words <= max
  }
  
  var body: some View {
    Text(
      text.count == 0
        ? "Must not be empty"
        : (text.words < max
          ? "\(text.words) / \(max) max words"
          : "\(text.words) / \(max) max words limit exceeded")
    ).foregroundColor(isValid ? .gray : .red)
  }
}

struct QuestionValidationMessage_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      QuestionValidationMessage(text: "", max: 10)
      QuestionValidationMessage(text: "Valid", max: 10)
      QuestionValidationMessage(text: "Max two words", max: 2)
    }
  }
}
