//
//  NewsDetailView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import MDText

struct NewsDetailView: View {
    var message: Message
    var body: some View {
      VStack {
        MarkdownView(text: message.body, title: message.title)
      }
      .navigationBarTitle(Text(message.title), displayMode: .inline)
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
      NewsDetailView(message: Message(
        id: "id",
        title: "RKI vorsichtig optimistisch: Corona-Infektionskurve flacht etwas ab",
        summary: "",
        
        body: "Seit\nein paar **Tagen** läuft das öffentliche Leben in Deutschland wegen des Coronavirus auf Sparflamme. Experten betonten: Es dauert, bis sich die Vorkehrungen in den Zahlen zu Neuinfektionen niederschlagen. Diese Woche dürfte mehr Klarheit bringen.",
        createdAt: Date(),
        author: "Rober Koch Institut",
        type: "warn"
      ))
    }
}
