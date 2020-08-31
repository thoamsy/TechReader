//
//  ArticleForm.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI
import Combine
import LinkPresentation

struct ArticleForm: View {
  @Binding var articleURL: String
  @State private var metadata: LPLinkMetadata?
  let onSubmit: () -> Void

  var body: some View {
    VStack {
      Form {
        Label("URL", systemImage: "newspaper")
        TextField("", text: $articleURL, onEditingChanged: {_ in }) {
          print(articleURL)
          LinksModel.fetchMetadata(for: articleURL) {
            self.handleLinkFetchResult($0)
          }
          onSubmit()
        }
        .keyboardType(.URL)
        .disableAutocorrection(true)
      }
      if metadata != nil {
        LinkView(metadata: metadata)
          .aspectRatio(contentMode: .fit)
          .layoutPriority(2)
      } else {
        Text("OH?")
          .layoutPriority(2)
      }
    }
  }

  private func handleLinkFetchResult(_ result: Result<LPLinkMetadata, Error>) {
    DispatchQueue.main.async {
      switch result {
        case .success(let metadata): self.metadata = metadata
        case .failure(let error): print(error.localizedDescription)
      }
    }
  }
}

struct ArticleForm_Previews: PreviewProvider {
  static var previews: some View {
    ArticleForm(articleURL: .constant(""), onSubmit: { })
  }
}
