# TextFieldBehavior

* created using XCode 12.4 and iOS 14

This is a sample XCode project that accompanies a [blog post](https://www.dabblingbadger.com/blog/2021/4/6/tips-and-tricks-for-making-the-most-of-textfield-in-swiftui) discussing tips and tricks for using `TextField` in SwiftUI.

More specifically, this code covers what I feel are two major deficiencies of `TextField` as of SwiftUI 2.0.  
1.  Optional strings can't be used with `TextField`.  But this can be easily fixed. (see Optional+WrappedString.swift)
2.  The alternate constructor `TextField(title: StringProtocol, value: Binding<T>, formatter: Formatter)` makes working with numbers a real pain.  The state of the bound value is *only* updated in the `.onCommit` closure, which requires that the user press the return key.  This won't happen if the user navigates/taps away from the textfield and can never happen using numeric keyboards because none of them have return keys.  The solution for now is to add the desired behavior manually by wrapping `UITextField` into a `View` following the 'UIViewRepresentable' protocol (see NumericTextField.swift).
