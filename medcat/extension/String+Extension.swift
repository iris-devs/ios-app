//
//  String+Extension.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 29.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation

extension String {
  var words: Int {
    let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
    let components = self.components(separatedBy: chararacterSet)
    let words = components.filter { !$0.isEmpty }

    return words.count
  }
}
