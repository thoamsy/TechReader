//
//  ArticleForm.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI
import Combine

struct ArticleForm: View {
  @Binding var articleURL: String
  @State private var testSuccess = false
  let onSubmit: () -> Void

  var body: some View {
    Form {
      Label("URL", systemImage: "newspaper")
      TextField("", text: $articleURL, onEditingChanged: {_ in }) {
        onSubmit()
        testSuccess = true
      }
      .keyboardType(.URL)
      .onReceive(Just(articleURL), perform: { newValue in
        if URL(string: newValue) != nil {
          articleURL = newValue
        }
      })
      if testSuccess {
        Text("YES").foregroundColor(.red)
      }
    }
  }
}

struct ArticleForm_Previews: PreviewProvider {
  static var previews: some View {
    ArticleForm(articleURL: .constant(""), onSubmit: { })
  }
}
