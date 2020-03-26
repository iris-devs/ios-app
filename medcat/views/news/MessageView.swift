//
//  MessageView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct MessageView: View {
  var message: Message  
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      if message.title != "" {
        HStack(alignment: .top, spacing: 10) {
          if message.type != nil {
            Circle()
              .foregroundColor(message.type == "alert" ? .red : .orange)
              .frame(width: 12, height: 12)
              .padding(.top, 5)
          }
          
          Text(message.title)
            .font(.headline)
        }
      }
      
      Text(message.summary)
        .font(.body)
        .lineLimit(3)

      HStack {
        Text(Formatter.date.string(from: message.createdAt))
          .font(.caption)
          .foregroundColor(.secondary)

        Spacer()
        if message.author != nil {
          Text(message.author!)
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.vertical, 10)
  }
}

struct MessageView_Previews: PreviewProvider {
  static var previews: some View {
    MessageView(message: Message(
      id: "id",
      title: "RKI vorsichtig optimistisch: Corona-Infektionskurve flacht etwas ab",
      summary: "Seit ein paar Tagen läuft das öffentliche Leben in Deutschland wegen des Coronavirus auf Sparflamme. Experten betonten: Es dauert, bis sich die Vorkehrungen in den Zahlen zu Neuinfektionen niederschlagen. Diese Woche dürfte mehr Klarheit bringen.",
      body: "Seit ein paar Tagen läuft das öffentliche Leben in Deutschland wegen des Coronavirus auf Sparflamme. Experten betonten: Es dauert, bis sich die Vorkehrungen in den Zahlen zu Neuinfektionen niederschlagen. Diese Woche dürfte mehr Klarheit bringen.",
      createdAt: Date(),
      author: "Rober Koch Institut",
      type: "warn"
    ))
  }
}
