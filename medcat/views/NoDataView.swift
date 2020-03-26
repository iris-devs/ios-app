//
//  NoDataView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct NoDataView: View {
  var text: String
  var imageName: String? = nil

  var body: some View {
    VStack {
      if imageName != nil {
        Image(systemName: imageName!)
          .resizable()
          .scaledToFit()
          .frame(height: 60)
          .foregroundColor(Color.secondary.opacity(0.5))
      }
        
      Text(text)
        .foregroundColor(.secondary)
        .font(.body)
    }
  }
}

struct NoDataView_Previews: PreviewProvider {
  static var previews: some View {
    NoDataView(text: "No news")
  }
}
