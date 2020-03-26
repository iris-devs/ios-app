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
          Section(header: Text("Filter questions")) {
            Picker("", selection: $filter) {
              Text("All").tag(0)
              Text("Answered").tag(1)
              Text("My").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
          }
          
          Section(header: Text("Sorting by")) {
            Picker("", selection: $sorting) {
              Text("Created date").tag(0)
              Text("Likes").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
          }
        }
      }
      .navigationBarTitle("Filtering settings")
      .navigationBarItems(trailing: Button(action: {
        self.isVisible = false
      }) {
        Text("Save")
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
