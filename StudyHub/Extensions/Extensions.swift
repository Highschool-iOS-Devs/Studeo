//
//  Extensions.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Combine
//NOTE: - Styling for buttons



//NOTE: - Custom Text Field

struct CustomTextField: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .frame(width: 250, height: 10)
            .font(.custom("Montserrat SemiBold", size: 15, relativeTo: .subheadline))
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

//NOTE: - Custom colors

extension Color {
    public static var buttonBlue: Color {
        return Color(#colorLiteral(red: 0, green: 0.6, blue: 1, alpha: 1))
    }
    public static var buttonPressedBlue: Color {
        return Color(#colorLiteral(red: 0, green: 0.4666666667, blue: 1, alpha: 1))
    }
    public static var gradientLight: Color {
        return Color(#colorLiteral(red: 0, green: 0.9333333333, blue: 1, alpha: 1))
       }
    public static var gradientDark: Color {
        return Color(#colorLiteral(red: 0, green: 0.5843137255, blue: 1, alpha: 1))
    }
}
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
protocol Accumulatable {
    static func +(lhs: Self, rhs: Self) -> Self
}
extension Int : Accumulatable {}

struct AccumulateSequence<T: Sequence>: Sequence, IteratorProtocol
where T.Element: Accumulatable {
    var iterator: T.Iterator
    var accumulatedValue: T.Element?

    init(_ sequence: T) {
        self.iterator = sequence.makeIterator()
    }

    mutating func next() -> T.Element? {
        if let val = iterator.next() {
            if accumulatedValue == nil {
                accumulatedValue = val
            }
            else { defer { accumulatedValue = accumulatedValue! + val } }
            return accumulatedValue

        }
        return nil
    }
}


extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
