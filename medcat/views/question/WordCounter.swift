//
//  WordCounter.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 28.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

func wordsCount(string: String) -> Int {
  let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
  let components = string.components(separatedBy: chararacterSet)
  let words = components.filter { !$0.isEmpty }
  
  return words.count
}

struct WordCounter: View {
  var text: String
  var max: Int
  
  @Binding var count: Int
  
  private var words: Int {
    wordsCount(string: self.text)
  }
  
  var body: some View {
    Text("\(self.words) / \(max) max words")
      .font(.footnote)
      .foregroundColor(self.words > max ? .red : .systemGray3)
  }
}

struct WordCounter_Previews: PreviewProvider {
  static var previews: some View {
    WordCounter(text: "Test test", max: 10, count: .constant(10))
  }
}
