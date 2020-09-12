//
//  LinksModel.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import Foundation
import LinkPresentation


final class LinksModel: ObservableObject {
  @Published var links: [ArticleLink] = []

  class func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
    guard let url = URL(string: link) else { return }

    URLSession.shared.dataTaskPublisher(for: url)
      .retry(2)
      .tryMap() { element in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return String(decoding: element.data, as: UTF8.self)
//        return String(data: element.data, encoding: .utf8)
      }
      .sink(receiveCompletion: {
        print(("JLKJKL: \($0)"))
      }, receiveValue: { value in
        print(value)
      })

    let metadataProvider = LPMetadataProvider()

    metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
      if let error = error {
        completion(.failure(error))
        return
      }

      if let metadata = metadata {
        completion(.success(metadata))
      }
    }
  }

  init() {
    loadLinks()
  }

  func createLink(with metadata: LPLinkMetadata) {
    let link = ArticleLink()
    link.id = Int(Date.timeIntervalSinceReferenceDate)
    link.metadata = metadata
    links.append(link)
    saveLinks()
  }

  fileprivate func loadLinks() {
    guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let linksURL = docDirURL.appendingPathComponent("links")

    if FileManager.default.fileExists(atPath: linksURL.path) {
      do {
        let data = try Data(contentsOf: linksURL)
        guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ArticleLink] else { return }
        links = unarchived
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  fileprivate func saveLinks() {
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: links, requiringSecureCoding: true)
      guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
      }

      try data.write(to: docDirURL.appendingPathComponent("links"))
    } catch {
      print(error.localizedDescription)
    }
  }
}

final class ArticleLink: NSObject, NSSecureCoding, Identifiable {
  static var supportsSecureCoding = true

  enum encoderKeys: String {
    case id, metadata
  }

  func encode(with coder: NSCoder) {
    guard let id = id, let metadata = metadata else { return }
    coder.encode(NSNumber(integerLiteral: id), forKey: encoderKeys.id.rawValue)
    coder.encode(metadata as NSObject, forKey: encoderKeys.metadata.rawValue)
  }

  required init?(coder: NSCoder) {
    id = coder.decodeObject(of: NSNumber.self, forKey: encoderKeys.id.rawValue)?.intValue
    metadata = coder.decodeObject(of: LPLinkMetadata.self, forKey: encoderKeys.metadata.rawValue)
  }

  override init() {
    super.init()
  }

  var id: Int?
  var metadata: LPLinkMetadata?
}
