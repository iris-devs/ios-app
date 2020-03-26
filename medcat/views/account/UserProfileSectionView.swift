//
//  UserProfileSectionView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct UserProfileSectionView: View {
  var title: String
  var text: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(title)
        .font(.headline)
        .foregroundColor(.secondary)
            
      Text(text)
        .font(.body)

      Divider().padding(.top, 15)
    }
    .padding(.vertical, 10)
  }
}


struct UserProfileSectionView_Previews: PreviewProvider {
    static var previews: some View {
      UserProfileSectionView(title: "Ogranisation", text: "coliquio GmbH")
    }
}
