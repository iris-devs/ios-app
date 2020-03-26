//
//  LikesView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 25.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct LikesView: View {
  var likes: Int = 0
  var isLiked: Bool = false

  var body: some View {
    Button(action: {
      
    }) {
      VStack(alignment: .center, spacing: 8) {
        Image(systemName: "hand.thumbsup.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 16)

        Text("\(likes)")
          .font(.caption)
      }
    }.foregroundColor(isLiked ? Color.gray : Color.blue)
  }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        LikesView()
        LikesView(likes: 10)
        LikesView(likes: 10, isLiked: true)
      }
    }
}
