//
//  ShareLinkView.swift
//  TechReader
//
//  Created by yk on 2020/9/1.
//

import SwiftUI
import LinkPresentation


class ActivityController: UIViewController, UIActivityItemSource {
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return ""
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return metadata?.originalURL
  }

  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
    return metadata
  }

  var metadata: LPLinkMetadata?
  var activityViewController: UIActivityViewController?
  var completion: UIActivityViewController.CompletionWithItemsHandler?


  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
    activityViewController?.completionWithItemsHandler = completion
    present(activityViewController!, animated: true)
  }
}

struct ShareLinkView: UIViewControllerRepresentable {
  typealias UIViewControllerType = ActivityController
  var metadata: LPLinkMetadata?
  var completion: (() -> Void)

  func makeUIViewController(context: Context) -> ActivityController {
    let controller = ActivityController()
    controller.metadata = metadata
    controller.completion = {
      (activityType, completed, returned, error) in
      self.completion()
    }
    controller.loadView()
    return controller
  }
  func updateUIViewController(_ uiViewController: ActivityController, context: Context) {

  }
}

struct ShareLinkView_Previews: PreviewProvider {
    static var previews: some View {
      ShareLinkView(metadata: nil, completion: {})
    }
}
