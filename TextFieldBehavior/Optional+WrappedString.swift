//
//  Optional+WrappedString.swift
//  TextFieldBehavior
//
//  Created by Jonathan Badger on 4/6/21.
//

import Foundation

extension Optional where Wrapped == String {
    var _boundString: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundString: String {
        get {
            return _boundString ?? ""
        }
        set {
            _boundString = newValue.isEmpty ? nil : newValue
        }
    }
}
