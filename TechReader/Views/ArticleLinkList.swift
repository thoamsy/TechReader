//
//  ArticleLinkList.swift
//  TechReader
//
//  Created by yk on 2020/9/8.
//

import SwiftUI

struct ArticleLinkList: View {
  @EnvironmentObject var linksList: LinksModel
  @Environment(\.editMode) var editMode

  @State private var linkToShare: Link?

  private func onDelete(indexSet: IndexSet) {
    linksList.links.remove(atOffsets: indexSet)
  }

  var isEditing: Bool {
    editMode?.wrappedValue.isEditing ?? false
  }


  var body: some View {
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
      .listStyle(InsetListStyle())
      if linkToShare != nil {
        ShareLinkView(metadata: linkToShare!.metadata) {
          self.linkToShare = nil
        }.frame(width: 0, height: 0)
      }

    }
  }
}

struct ArticleLinkList_Previews: PreviewProvider {
  static var previews: some View {
    ArticleLinkList()
  }
}
