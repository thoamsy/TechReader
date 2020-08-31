//
//  LinkView.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI
import UIKit
import LinkPresentation

struct LinkView: UIViewRepresentable {
  typealias UIViewType = LPLinkView

  var metadata: LPLinkMetadata?

  func makeUIView(context: Context) -> LPLinkView {
    return metadata.map { LPLinkView(metadata: $0) } ?? LPLinkView()
  }
  func updateUIView(_ uiView: LPLinkView, context: Context) {

  }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
