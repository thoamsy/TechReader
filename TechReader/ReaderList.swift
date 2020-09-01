//
//  ReaderList.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import SwiftUI
import Combine

struct ReaderList: View {
  private func fetchHTML(url: URL) {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .sink(receiveCompletion: {_ in }, receiveValue: { data in
        print(data)
      })

  }

    var body: some View {
      Button("FOO") {
        fetchHTML(url: URL(string: "https://9to5mac.com/2020/08/29/apple-watch-national-parks-challenge/")!)
      }
    }
}

struct ReaderList_Previews: PreviewProvider {
    static var previews: some View {
        ReaderList()
    }
}
