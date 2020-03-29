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
  @State var title: String = ""
  
  @State var titleWords = 0
  @State var textWords = 0
  
  @State var text: String = ""
    
  @State var category = -1
  @State var errorTitle: String?
  @State var errorQuestion: String?
  @State var saving: Bool = false
  @State var error: String? = nil
  
  @ObservedObject private var store = QuestionStore.shared
  @EnvironmentObject private var sessionStore: SessionStore
  @ObservedObject var keyboard = KeyboardResponder()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Title"), footer: WordCounter(text: title, max: 10, count: $titleWords)) {
          TextField("Enter Title here...", text: $title)
        }
        
        Section(header: Text("Question"), footer: WordCounter(text: text, max: 100, count: $textWords)) {
          TextView("Enter Question here...", text: $text)
            .frame(height: 100)
        }
        
        VStack {
          if saving {
            ActivityIndicator()
          }
          
          Button(action: {
            self.save()
          }) {
            HStack {
              Text("Submit Question")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.white)
                .font(.body)
                .background(Color.blue)
                .cornerRadius(4)
            }
          }.disabled(self.saving)
        }
      }
      .navigationBarItems(trailing: Button(action: {
        self.isVisible = false
      }) {
        Text("Cancel")
      })
        .navigationBarTitle("Ask question")
        .padding(.bottom, keyboard.currentHeight)
    }
  }
  
  func save() {
//    guard titleWordsCount > 0
//      && titleWordsCount <= 10
//      && textWordsCount > 0
//      && textWordsCount <= 100 else { return }
//    
    let question = Question(
      id: "",
      uid: sessionStore.session!.uid,
      title: title,
      category: "",
      body: text
    )
    
    self.saving = true
    store.addQuestion(question) { error in
      if let error = error {
        self.error = error.localizedDescription
        self.saving = false
        
        return
      }
      
      self.store.load() { err in
        self.saving = false
        
        if let err = err {
          self.error = err.localizedDescription
          return
        }
        
        self.isVisible = false
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
