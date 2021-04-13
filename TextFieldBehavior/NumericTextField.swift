//
//  NumericTextField.swift
//  TextFieldBehavior
//
//  Created by Jonathan Badger on 3/30/21.
//

import SwiftUI

struct NumericTextField<T>: UIViewRepresentable {
    private var title: String
    @Binding var value: T
    private var formatter: NumberFormatter
    @State var errorMessage = ""
    private var keyboardType: UIKeyboardType
    
    init(title: String = "", value: Binding<T>, numberFormatter: NumberFormatter, keyboardType: UIKeyboardType) {
        self.title = title
        self._value = value
        self.formatter = numberFormatter
        self.keyboardType = keyboardType
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var value: T
        var formatter: NumberFormatter
        @Binding var errorMessage: String
        
        init(value: Binding<T>, formatter: NumberFormatter, errorMessage: Binding<String>) {
            self._value = value
            self.formatter = formatter
            self._errorMessage = errorMessage
        }
        
        func textFor<T>(value: T) -> String? {
            return formatter.string(for: value)
        }
        
        func scrubbedText(currentText: String) -> String {
            switch formatter.numberStyle {
            case .currency:
                if let prefix = formatter.currencySymbol,
                   !currentText.contains(prefix),
                   !currentText.isEmpty {
                    return prefix + currentText
                }
            case .percent: ()
                if !currentText.contains("%") {
                    return currentText + "%"
                }
            default:
                ()
            }
            return currentText
        }
        
        func showAlert(errorMessage: String, view: UIView) {
            let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            if let parentController = view.parentViewController {
                parentController.present(alert, animated: true)
            }
        }
        
        //MARK: UITextFieldDelegate methods
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            guard let currentText = textField.text else { return }
            let string = scrubbedText(currentText: currentText)
            
            var valueContainer: AnyObject?
            var errorContainer: NSString?
            formatter.getObjectValue(&valueContainer, for: string, errorDescription: &errorContainer)
            
            if let errorString = errorContainer as String? {
                if let stringVal = formatter.string(for: value) {
                    textField.text = stringVal
                } else {
                    textField.text = nil
                }
                showAlert(errorMessage: errorString, view: textField as UIView)
                return
            }
            
            if let newValue = valueContainer as? T,
               errorContainer == nil {
                self.value = newValue
            }
        }
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        if !title.isEmpty {
            textField.placeholder = title
        }
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.keyboardType = keyboardType
        textField.borderStyle = .roundedRect
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(value: $value, formatter: formatter, errorMessage: $errorMessage)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = context.coordinator.textFor(value: value)
        uiView.keyboardType = keyboardType
    }
}

struct NumericTextField_Previews: PreviewProvider {
    static let formatter = NumberFormatter()
    static var previews: some View {
        NumericTextField(value: Binding.constant(5), numberFormatter: formatter, keyboardType: .numbersAndPunctuation)
    }
}




