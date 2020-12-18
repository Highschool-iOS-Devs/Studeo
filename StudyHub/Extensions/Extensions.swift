//
//  Extensions.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

//NOTE: - Styling for buttons



//NOTE: - Custom Text Field

struct CustomTextField: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .frame(width: 250, height: 10)
            .font(Font.custom("Montserrat-Regular", size: 15.0))
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
