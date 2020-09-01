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

  @State private var linkToShare: Link?
  @State private var articleURLs: [String] = ["initial"]

  var addButton: some View {
    Button(action: { showPopover.toggle() }) {
      Image(systemName: "plus.circle")
    }.sheet(isPresented: $showPopover) {
      NavigationView {
        ArticleForm(articleURL: $articleURL) {
          articleURLs.append(articleURL)
          articleURL = ""
          keepLink($0)
        }
      }
    }
  }

  private func keepLink(_ metadata: LPLinkMetadata?) {
    metadata.map { self.linksList.createLink(with: $0) }
  }

  private func onDelete(indexSet: IndexSet) {
    linksList.links.remove(atOffsets: indexSet)
  }

  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(Array(linksList.links.enumerated()), id: \.1) { (index, link) in
            VStack(alignment: .leading) {
              Text("Header")
                .font(.subheadline)
                .foregroundColor(Color(UIColor.secondaryLabel))
              LinkView(metadata: link.metadata)
                .aspectRatio(contentMode: .fit)
                .disabled(true)
            }
            .contextMenu {
              Button(action: {
                onDelete(indexSet: IndexSet(integer: index))
              }) {
                Label("Delete", systemImage: "trash")
                  .foregroundColor(.red)
                  .border(Color.red)
              }

              Button(action: {
                linkToShare = link
              }) {
                Label("Share", systemImage: "square.and.arrow.up")
              }
            }
          }
          .onMove { indices, newOffset in
            linksList.links.move(fromOffsets: indices, toOffset: newOffset)
          }
          .onDelete(perform: onDelete(indexSet:))
        }
        .listStyle(GroupedListStyle())

        if linkToShare != nil {
          ShareLinkView(metadata: linkToShare!.metadata) {
            self.linkToShare = nil
          }.frame(width: 0, height: 0)
        }
      }
      .navigationTitle("Articles")
      .navigationBarItems(trailing: addButton)

    }
  }
}

struct ReaderDetail_Previews: PreviewProvider {
  static var previews: some View {
    ReaderDetail()
  }
}
