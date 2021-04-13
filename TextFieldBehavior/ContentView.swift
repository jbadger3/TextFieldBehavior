//
//  ContentView.swift
//  TextFieldBehavior
//
//  Created by Jonathan Badger on 3/30/21.
//

import SwiftUI

struct ContentView: View {
    @State var plainText: String? = nil
    @State var textFieldValue: Double? = nil
    @State var keyBoardType: UIKeyboardType = .numbersAndPunctuation
    @State var numericTextFieldValue: Double? = nil
    @State var numberFormatter = NumberFormatter()
    @State var numberStyle: NumberFormatter.Style = .currency
    private var numberStyles: [NumberFormatter.Style] = [.none, .currency, .percent]
    private var styleText = [0: ".none", 2: ".currency", 3: ".percent"]
    private var keyboardTypes: [UIKeyboardType] = [.default, .asciiCapable, .numbersAndPunctuation, .URL, .numberPad, .phonePad, .namePhonePad, .emailAddress, .decimalPad, .twitter, .webSearch, .asciiCapableNumberPad]
    private var keyboardTypeText = [0: ".default", 1: ".asciiCapable", 2: ".numbersAndPunctuation", 3: ".URL", 4: ".numberPad", 5: ".phonePad", 6: ".namePhonePad", 7: ".emailAddress", 8: ".decimalPad", 9: ".twitter", 10: ".webSearch", 11: ".asciiCapableNumberPad"]
    
    @State var showingAlert = false
    
    var body: some View {
        numberFormatter.numberStyle = numberStyle
        return
            NavigationView {
                Form {
                    Picker(selection: $keyBoardType, label: Text("KeyboardType:").fontWeight(.semibold), content: {
                        ForEach(keyboardTypes, id: \.self) { keyBoardType in
                            Text(keyboardTypeText[Int(keyBoardType.rawValue)] ?? "")
                        }
                    })
                    Picker(selection: $numberStyle, label: Text("Number Style:").fontWeight(.semibold), content: {
                        ForEach(numberStyles, id: \.self) { numberStyle in
                            Text(styleText[Int(numberStyle.rawValue)] ?? "")
                        }
                    }).onChange(of: numberStyle, perform: { value in
                        numberFormatter.numberStyle = value
                    })
                    HStack {
                        Text("TextField (string)")
                            .fontWeight(.semibold)
                        TextField("", text: $plainText.boundString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(keyBoardType)
                        Text("value: \(plainText == nil ? "nil" : plainText!)")
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("TextField (value)")
                            .fontWeight(.semibold)
                        TextField("", value: $textFieldValue, formatter: numberFormatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(keyBoardType)
                        Text("value: \(textFieldValue == nil ? "nil" : String(textFieldValue!))")
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("NumericTextField")
                            .fontWeight(.semibold)
                            .fixedSize()
                        NumericTextField(title: "", value: $numericTextFieldValue, numberFormatter: numberFormatter, keyboardType: keyBoardType)
                        Text("value: \(numericTextFieldValue == nil ? "nil" : String(numericTextFieldValue!))")
                            .fontWeight(.semibold)
                            .fixedSize()
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var myInt: Int = 45
    static var previews: some View {
        ContentView()
    }
}


