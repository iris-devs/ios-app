//
//  FiltersAndSortingView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 26.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI

struct FiltersAndSortingView: View {
  @Binding var filter: Int
  @Binding var sorting: Int
  @Binding var isVisible: Bool
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(header: Text("Filter")) {
            Picker("", selection: $filter) {
              Text("All").tag(0)
              Text("Only Answered").tag(1)
              Text("Only Mine").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
          }
          
          Section(header: Text("Sort Order")) {
            Picker("", selection: $sorting) {
              Text("Most Recent").tag(0)
              Text("Most Liked").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
          }
        }
      }
      .navigationBarTitle("Questionslist Settings")
      .navigationBarItems(trailing: Button(action: {
        self.isVisible = false
      }) {
        Text("Apply")
      })
    }
  }
}

struct FiltersAndSortingView_Previews: PreviewProvider {
  static var previews: some View {
    FiltersAndSortingView(
      filter: .constant(0),
      sorting: .constant(0),
      isVisible: .constant(true)
    )
  }
}
