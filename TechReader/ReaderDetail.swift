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
  @Environment(\.editMode) var editMode

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

  private func onDragItems(indexSet: IndexSet, items: [NSItemProvider]) {
    for provider in items {
      guard provider.canLoadObject(ofClass: URL.self) else { return }
      provider.loadObject(ofClass: URL.self) { url, error in
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

  var isEditing: Bool {
    editMode?.wrappedValue.isEditing ?? false
  }

  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(Array(linksList.links.enumerated()), id: \.1) { (index, link) in
            VStack(alignment: .leading) {
              Text(link.metadata?.title ?? "Untitle")
                .font(.subheadline)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .lineLimit(1)
                .frame(width: 300)
                .truncationMode(.tail)


              if !isEditing {
                LinkView(metadata: link.metadata)
                  .aspectRatio(contentMode: .fit)
                  .disabled(true)
              }

            }
            .contextMenu {
              Button(action: {
                onDelete(indexSet: IndexSet(integer: index))
              }) {
                Label("Delete", systemImage: "trash")
                  .foregroundColor(.red)
                  .border(Color.red)
              }

              Section {
                Button(action: {
                }) {
                  Label("Edit", systemImage: "square.and.pencil")
                }

                Button(action: {
                  linkToShare = link
                }) {
                  Label("Share", systemImage: "square.and.arrow.up")
                }
              }
            }
          }
          .onMove { indices, newOffset in
            linksList.links.move(fromOffsets: indices, toOffset: newOffset)
          }
          .onDelete(perform: onDelete(indexSet:))
          //          .onInsert(of: [.url], perform: onDragItems(indexSet:items:))
        }

        if linkToShare != nil {
          ShareLinkView(metadata: linkToShare!.metadata) {
            self.linkToShare = nil
          }.frame(width: 0, height: 0)
        }
      }
      .navigationTitle("Articles")
      .navigationBarItems(leading: EditButton(), trailing: addButton)
      .onDrop(of: [.url], isTargeted: nil, perform: { providers in
        print("JLKJLK")
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
