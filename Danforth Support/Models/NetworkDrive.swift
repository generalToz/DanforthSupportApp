//
//  Models.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/20/23.
//

import SwiftUI

struct NetworkDrive: Identifiable {
    
    var id = UUID()
    var isAccessible = true     // new - to flag when a drive can't be accessed
    var isLoading = false       // new - to tell the button that the drive is loading
    var data: String
    var name: String {
        var name = ""
        if data.contains("U:") {
            name = "Personal"
        }
        else {
            if let index = data.lastIndex(of: "/") {
                name = String(data.suffix(from: index))
            }
            name = String(name.dropFirst(1))
            name = name.replacingOccurrences(of: "$", with: "")
            name = name.replacingOccurrences(of: "_", with: " ")
            name = name.capitalized
        }
        return name
    }
    var letter: String {
        var letter = ""
        if data.contains("U:") {
            letter = "U:"
        }
        else {
            if let index = data.firstIndex(of: "%") {
                letter = String(data.prefix(upTo: index))
            }
        }
        return letter
    }
    var address: String {
        var path = ""
        if let range = data.range(of: "%") {
            path = String(data[range.upperBound...])
        }
        let address = String(path.dropFirst(2))
        return address
    }
    var sharename: String {
        var addr = address
        var sharename = ""
        if addr.contains("@") {
            if let range = addr.range(of: "@") {
                addr = String(addr[range.upperBound...])
            }
        }
        if let index = addr.firstIndex(of: "/") {
            sharename = String(addr.prefix(upTo: index))
        }
        return sharename
    }
}
