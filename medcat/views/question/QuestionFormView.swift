//
//  QuestionFormView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 24.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import SwiftUIX

func wordsCount(string: String) -> Int {
  let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
  let components = string.components(separatedBy: chararacterSet)
  let words = components.filter { !$0.isEmpty }
  
  return words.count
}

struct QuestionFormView: View {
  @Binding var isVisible: Bool
  @State var title: String = ""
  
  private var titleWordsCount: Int {
    return wordsCount(string: self.title)
  }
  
  @State var text: String = ""
  
  private var textWordsCount: Int {
    return wordsCount(string: self.text)
  }
  
  @State var category = -1
  @State var errorTitle: String?
  @State var errorQuestion: String?
  @State var saving: Bool = false
  @State var error: String? = nil
  
  @ObservedObject private var store = QuestionStore.shared
  @EnvironmentObject private var sessionStore: SessionStore
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        if error != nil {
          Text(error!)
            .font(.body)
            .foregroundColor(.red)
        }
        
        VStack(alignment: .leading) {
          HStack {
            Text("Title".uppercased())
              .font(.headline)
            
            Spacer()
            Text("\(titleWordsCount) / 10 max words")
              .font(.footnote)
              .foregroundColor(titleWordsCount > 10 ? .red : .systemGray3)
          }
          
          TextField("Enter title here...", text: $title)
            .font(.body)
          
          Divider().padding(.top, 10)
        }
        
        //      VStack(alignment: .leading) {
        //        HStack {
        //          Text("Category".uppercased())
        //            .font(.headline)
        //
        //          Spacer()
        //          Text("optional")
        //            .font(.footnote)
        //            .foregroundColor(.systemGray3)
        //        }
        //
        //        Picker(selection: $category, label: EmptyView()) {
        //          ForEach(0..<self.store.categories.count, id: \.self) { index in
        //            Text(self.store.categories[index].title)
        //          }
        //        }.pickerStyle(SegmentedPickerStyle())
        //
        //        Divider().padding(.top, 10)
        //      }
        
        VStack(alignment: .leading) {
          HStack {
            Text("Question".uppercased())
              .font(.headline)
            
            Spacer()
            Text("\(textWordsCount) / 100 max words")
              .font(.footnote)
              .foregroundColor(textWordsCount > 100 ? .red : .systemGray3)
          }
          
          TextView("Enter your question here...", text: $text)
            .height(150)
          
          Divider().padding(.top, 10)
        }
        
        VStack {
          if saving {
            ActivityIndicator()
          }

          Button(action: {
            self.save()
          }) {
            HStack {
              Text("Submit")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.white)
                .font(.body)
                .background(Color.blue)
                .cornerRadius(4)
            }
          }.disabled(self.saving)
        }
        
        Spacer()
      }
        
      .padding(20)
    }
    .onAppear(perform: store.loadCategories)
    .navigationBarTitle("Ask question")
  }
  
  func save() {
    guard titleWordsCount > 0
      && titleWordsCount <= 10
      && textWordsCount > 0
      && textWordsCount <= 100 else { return }
    
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
