//
//  ReaderDetail.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI

struct ReaderDetail: View {

  @State private var showPopover = false
  @State private var articleURL = ""

  @State private var articleURLs: [String] = ["initial"]

  var addButton: some View {
    Button(action: { showPopover.toggle() }) {
      Image(systemName: "plus.circle")
    }.sheet(isPresented: $showPopover) {
      ArticleForm(articleURL: $articleURL) {
        showPopover = false
        articleURLs.append(articleURL)
        articleURL = ""
      }
    }
  }

    var body: some View {
      NavigationView {
        List(articleURLs, id: \.self) {
          Text($0)
        }
        .navigationTitle("FOO")
        .navigationBarItems(trailing: addButton)
      }
      .navigationBarTitle("JJ")
    }
}

struct ReaderDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReaderDetail()
    }
}
