//
//  Remote.swift
//  ThinkingInSwiftUI
//
//  Created by yk on 2020/7/25.
//

import Foundation
import Combine



struct LoadingError: Error {

}


final class Remote<D>: ObservableObject {
  typealias TransformData = (Data) -> D?

  @Published var result: Result<D, Error>?
  var value: D? {
    try? result?.get()
  }

  let url: URL
  let transform: TransformData

  init(url: URL, transform: @escaping TransformData) {
    self.url = url
    self.transform = transform
  }

  func load() {
    return URLSession.shared.dataTask(with: url) {
      data, _, _ in
      DispatchQueue.main.async {
        if let d = data, let v = self.transform(d) {
          debugPrint(v)
          self.result = .success(v)
        } else {
          self.result = .failure(LoadingError())
        }
      }
    }.resume()
  }
}
