//
//  String+Extensions.swift
//  Danforth Password Change
//
//  Created by Alex Tosspon on 3/18/23.
//

import SwiftUI

extension String {
    var isPasswordStrong: Bool {
        containsCharSet(set: .uppercaseLetters) &&
        containsCharSet(set: .lowercaseLetters) &&
        containsCharSet(set: .decimalDigits) &&
        containsCharSet(set: .alphanumerics.inverted) &&
        isLongEnough()
    }
    
    private func containsCharSet(set: CharacterSet) -> Bool {
        rangeOfCharacter(from: set) != nil
    }
    private func isLongEnough() -> Bool {
        count > 9
    }
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
