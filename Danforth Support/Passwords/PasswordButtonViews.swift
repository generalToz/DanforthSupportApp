//
//  PasswordButtonViews.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//

import SwiftUI

struct PasswordButtonViews: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isInside = false
    
    enum ButtonType: String {
        case danforth = "Danforth"
        case mac = "Mac"
    }
    
    let type: ButtonType
    let isSuccess: Bool
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            
            if isSuccess {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
            }
            else {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("colorBG"))
                    .opacity(isInside ? 0.65 : 1)
                    .shadow(radius: 3, x: 2, y: 2)
            }
            HStack (spacing: 20) {
                Image(type.rawValue == "Mac" ? "finder.logo" : "danforth.frond")
                    .renderingMode(colorScheme == .dark && type.rawValue == "Danforth" ? .template : .original)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .shadow(radius: 1, x: 1, y: 1)
                    .padding(.leading)
                if isSuccess {
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .shadow(radius: 1, x: 1, y: 1)
                            Text("Success!")
                                .bold()
                        }
                        .font(.title)
                        Text("Your \(type.rawValue) password has been changed")
                            .font(.callout)
                    }
                }
                else {
                    VStack (alignment: .leading) {
                        Text("Change your")
                        Text("\(type.rawValue) password")
                    }
                    .font(.title2)
                    .bold()
                }
            }
        }
        .onHover { inside in
            if inside { isInside = true }
            else { isInside = false }
        }
    }
}

struct PasswordButtonViews_Previews: PreviewProvider {
    static var previews: some View {
        PasswordButtonViews(type: .danforth
                            , isSuccess: false)
            .frame(width: 280, height: 75)
    }
}
