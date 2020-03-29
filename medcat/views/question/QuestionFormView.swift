//
//  QuestionFormView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 24.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct QuestionFormView: View {
  @Binding var isVisible: Bool
  @EnvironmentObject private var sessionStore: SessionStore
  @ObservedObject private var store = QuestionStore.shared
  @ObservedObject var keyboard = KeyboardResponder()
  
  @State var saving: Bool = false
  @State var text: String = ""
  @State var title: String = ""
  
  var body: some View {
    NavigationView {
      Form {
        Section(
          header: Text("Title"),
          footer: QuestionValidationMessage(text: title, max: 10)
        ) {
          TextField("Enter Title here...", text: $title)
        }
        
        Section(
          header: Text("Question"),
          footer: QuestionValidationMessage(text: text, max: 100)
        ) {
          TextView("Enter Question here...", text: $text)
            .frame(height: 100)
        }
      }
      .navigationBarItems(
        leading: Button("Cancel", action: self.cancel),
        trailing: Button(saving ? "Submitting..." : "Submit", action: self.save).disabled(self.saving)
      )
        .navigationBarTitle("Ask question")
        .padding(.bottom, keyboard.currentHeight)
    }
  }
  
  func cancel() {
    self.isVisible = false
  }
  
  func save() {
    // Simple validation
    guard title.words > 0
      && title.words <= 10
      && text.words > 0
      && text.words <= 100 else { return }
    
    let question = Question(
      id: "",
      uid: sessionStore.session!.uid,
      title: title,
      category: "",
      body: text
    )
    
    self.saving = true
    store.addQuestion(question) { error in
      print("Saving....")
      self.saving = false
      self.isVisible = false
      
      if let error = error {
        print("\(error)")
      }
    }
  }
}

struct QuestionFormView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionFormView(isVisible: .constant(true))
      .environmentObject(SessionStore())
  }
}
