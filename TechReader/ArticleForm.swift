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
  @Environment(\.presentationMode) var presentationMode
  @State private var metadata: LPLinkMetadata?

  let onSubmit: (_ metadata: LPLinkMetadata?) -> Void

  var body: some View {
    VStack {
      Form {
        Label("URL", systemImage: "newspaper")
        TextField("", text: $articleURL, onEditingChanged: {_ in }) {
          LinksModel.fetchMetadata(for: articleURL) {
            self.handleLinkFetchResult($0)
          }
        }
        .keyboardType(.URL)
        .disableAutocorrection(true)
      }
      if metadata != nil {
        VStack {
          LinkView(metadata: metadata)
            .aspectRatio(contentMode: .fit)
        }
      }
    }.navigationBarItems(trailing: Button(action: {
      onSubmit(self.metadata)
      presentationMode.wrappedValue.dismiss()
    }) {
      Text("Save")
    }.disabled(metadata == nil))
  }

  private func handleLinkFetchResult(_ result: Result<LPLinkMetadata, Error>) {
    DispatchQueue.main.async {
      switch result {
        case .success(let metadata):
          self.metadata = metadata
          print(metadata.title, metadata.description, metadata.imageProvider)
        case .failure(let error): print(error.localizedDescription)
      }
    }
  }
}

struct ArticleForm_Previews: PreviewProvider {
  static var previews: some View {
    ArticleForm(articleURL: .constant(""), onSubmit: { print($0) })
  }
}
