//
//  TabView.swift
//  menubartestapp
//
//  Created by Alex Tosspon on 4/7/23.
//

import SwiftUI

struct TabView: View {
    @Environment(\.colorScheme) var colorScheme

    var tab: Tab
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.01)
            if isSelected {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? .gray : .white)
                    .opacity(colorScheme == .dark ? 0.4 : 0.2)
                    .shadow(radius: 2, y: 3)
            }
            VStack (spacing: 3) {
                Image(systemName: tab.sybmol)
                    .font(.largeTitle)
                Text(tab.title)
                    .font(.subheadline)
            }
        }
        .frame(height: 75)
    }
}



    

