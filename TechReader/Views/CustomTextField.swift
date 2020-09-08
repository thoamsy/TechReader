//
//  CustomTextField.swift
//  TechReader
//
//  Created by yk on 2020/9/9.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {

  class Coordinator: NSObject, UITextFieldDelegate {

    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?


    init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>) {
      _text = text
      _isResponder = isResponder
      _nextResponder = nextResponder
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
      text = textField.text ?? ""
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
      DispatchQueue.main.async {
        self.isResponder = true
      }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
      DispatchQueue.main.async {
        self.isResponder = false
        if self.nextResponder != nil {
          self.nextResponder = true
        }
      }
    }
  }

  @Binding var text: String
  @Binding var nextResponder: Bool?
  @Binding var isResponder: Bool?

  var isSecured = false
//  var keyboard: UIKeyboardType = .default

  func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.isSecureTextEntry = isSecured
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
//    textField.keyboardType = keyboard
    textField.delegate = context.coordinator
    return textField
  }

  func makeCoordinator() -> CustomTextField.Coordinator {
    return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder)
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
    uiView.text = text
    if isResponder ?? false {
      uiView.becomeFirstResponder()
    }
  }

}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
      CustomTextField(
        text: .constant("24234234"),
        nextResponder: .constant(nil),
        isResponder: .constant(nil)
      )
        .keyboardType(.URL)
    }
}
