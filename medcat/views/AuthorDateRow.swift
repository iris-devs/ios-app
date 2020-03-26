//
//  AuthorDateRow.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 26.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct AuthorDateRow: View {
  var author: String
  var date: Date? = nil
  
  var body: some View {
    HStack {
      if date != nil {
        Text(Formatter.date.string(from: date!))
          .font(.footnote)
          .foregroundColor(.gray)
      }
      Spacer()
      Text(author)
        .font(.footnote)
        .foregroundColor(.gray)
    }
  }
}

struct AuthorDateRow_Previews: PreviewProvider {
  static var previews: some View {
    AuthorDateRow(author: "Vitali Stsepaniuk", date: Date())
  }
}
