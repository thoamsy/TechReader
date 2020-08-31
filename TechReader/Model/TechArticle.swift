//
//  TechArticle.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import Foundation

final class TechArticle: ObservableObject {
  @Published var cover: URL?
  @Published var title: String = ""
  @Published var description: String?
}
