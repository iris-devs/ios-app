//
//  NewsListView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 23.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct NewsListView: View {
  var news: [Message]
  @State var selection: Int?
  
  var body: some View {
    List(news) { item in
      NavigationLink(destination: NewsDetailView(message: item)) {
        MessageView(message: item)
          .padding(.horizontal, 4)
      }
    }
    .navigationBarTitle("News", displayMode: .large)
  }
}

struct NewsListView_Previews: PreviewProvider {
  static var previews: some View {
    NewsListView(news: [
      Message(
        id: "1",
        title: "RKI vorsichtig optimistisch: Corona-Infektionskurve flacht etwas ab",
        summary: "Seit ein paar Tagen läuft das öffentliche Leben in Deutschland wegen des Coronavirus auf Sparflamme. Experten betonten: Es dauert, bis sich die Vorkehrungen in den Zahlen zu Neuinfektionen niederschlagen. Diese Woche dürfte mehr Klarheit bringen.",
        body: "Seit ein paar Tagen läuft das öffentliche Leben in Deutschland wegen des Coronavirus auf Sparflamme. Experten betonten: Es dauert, bis sich die Vorkehrungen in den Zahlen zu Neuinfektionen niederschlagen. Diese Woche dürfte mehr Klarheit bringen.",
        createdAt: Date()
      ),
      Message(
        id: "2",
        title: "COVID-19: Erste Daten für die Anzahl von Patienten sowie verfügbaren Intensivbetten",
        summary: "Deutschlands Intensiv- und Notfallmediziner gewinnen nach erstmaliger Datenerhebung eine Ad-hoc-Übersicht auf die verfügbaren Behandlungskapazitäten hiesiger Intensivstationen",
        body: "Deutschlands Intensiv- und Notfallmediziner gewinnen nach erstmaliger Datenerhebung eine Ad-hoc-Übersicht auf die verfügbaren Behandlungskapazitäten hiesiger Intensivstationen",
        createdAt: Date(),
        author: "coliquio GmbH",
        type: "alert"
      )
    ])
  }
}
