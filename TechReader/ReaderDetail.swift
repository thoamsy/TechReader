//
//  ReaderDetail.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI
import LinkPresentation

struct ReaderDetail: View {

  @State private var showPopover = false
  @State private var articleURL = ""
  @EnvironmentObject var linksList: LinksModel

  @State private var articleURLs: [String] = ["initial"]

  var addButton: some View {
    Button(action: { showPopover.toggle() }) {
      Image(systemName: "plus.circle")
    }.sheet(isPresented: $showPopover) {
      ArticleForm(articleURL: $articleURL) {
        articleURLs.append(articleURL)
        articleURL = ""
        keepLink($0)
      }
    }
  }

  private func keepLink(_ metadata: LPLinkMetadata?) {
    metadata.map { self.linksList.createLink(with: $0) }
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(linksList.links) { link in
          VStack(alignment: .leading) {
            Text("Header")
              .font(.subheadline)
              .foregroundColor(Color(UIColor.secondaryLabel))
            LinkView(metadata: link.metadata)
              .aspectRatio(contentMode: .fit)
          }
          .contextMenu {
            Button(action: {}) {
              Label("Delete", systemImage: "trash")
            }
          }
        }
        .onMove{ indices, newOffset in
          linksList.links.move(fromOffsets: indices, toOffset: newOffset)
        }
        .onDelete { indexSet in
          linksList.links.remove(atOffsets: indexSet)
        }
      }
      .listStyle(GroupedListStyle())
      .navigationTitle("Articles")
      .navigationBarItems(leading: EditButton(), trailing: addButton)
    }
  }
}

struct ReaderDetail_Previews: PreviewProvider {
  static var previews: some View {
    ReaderDetail()
  }
}
