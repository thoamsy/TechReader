//
//  LinksModel.swift
//  TechReader
//
//  Created by yk on 2020/8/31.
//

import Foundation
import LinkPresentation


class LinksModel {
  class func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
    guard let url = URL(string: link) else { return }

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
}

