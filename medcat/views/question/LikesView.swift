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
  var onLike: ((Bool) -> Void)? = nil

  var body: some View {
    HStack {
      Button(action: {
        self.onLike?(!self.isLiked)
      }) {
        VStack(alignment: .center, spacing: 8) {
          Image(systemName: "hand.thumbsup.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 16)

          Text("\(likes)")
            .font(.footnote)
        }
      }
      .foregroundColor(isLiked ? Color.gray : Color.blue)
      .buttonStyle(BorderlessButtonStyle())
      .padding(10)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        .frame(width: 48, height: 48)
    )
  }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        LikesView()
        LikesView(likes: 10000)
        LikesView(likes: 100, isLiked: true)
      }
    }
}
