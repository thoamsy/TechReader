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


  private func onDragItems(indexSet: IndexSet, items: [NSItemProvider]) {
    for provider in items {
      guard provider.canLoadObject(ofClass: URL.self) else { return }
      let _ = provider.loadObject(ofClass: URL.self) { url, error in
        url.map {
          LinksModel.fetchMetadata(for: $0.absoluteString) { result in
            DispatchQueue.main.async {
              switch result {
                case .success(let metadata):
                  keepLink(metadata)
                default:
                  break;
              }
            }
          }
        }
      }
    }
  }


  var body: some View {
    NavigationView {
      ArticleLinkList()
        .environmentObject(LinksModel())
        .navigationTitle("Articles")
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .onDrop(of: [.url], isTargeted: nil, perform: { providers in
          for provider in providers {
            guard provider.canLoadObject(ofClass: URL.self) else { return false }
            _ = provider.loadObject(ofClass: URL.self) { url, error in
              url.map {
                LinksModel.fetchMetadata(for: $0.absoluteString) { result in
                  DispatchQueue.main.async {
                    switch result {
                      case .success(let metadata):
                        keepLink(metadata)
                      default:
                        break;
                    }
                  }
                }
              }
            }
            return true
          }
          return false
        })
    }
  }
}

struct ReaderDetail_Previews: PreviewProvider {
  static var previews: some View {
    ReaderDetail()
  }
}
