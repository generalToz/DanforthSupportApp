//
//  SidebarView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("tabSymbol") var tabSelectedSymbol = ""
    @AppStorage("tabTitle") var tabSelectedTitle = ""

    // The sidebar buttons
    let tabs = [
        Tab(sybmol: "info.circle.fill", title: "Info"),
        Tab(sybmol: "questionmark.circle.fill", title: "Support"),
        Tab(sybmol: "key.icloud.fill", title: "Passwords"),
        Tab(sybmol: "externaldrive.connected.to.line.below.fill", title: "Drives"),
        Tab(sybmol: "link.circle.fill", title: "Links")
    ]
    
    // To store the selected tab
//    @State var tabSelected = Tab(sybmol: "", title: "")
    
    var body: some View {
        
        ZStack {
            // The solid background for the whole sidebar
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 75)
                .shadow(radius: 2, x: 2)
            
            // The stack overlayed on top
            VStack (spacing: 0) {
                // Danforth logo in top right corner with divider
                Image("danforth.frond")
                    .renderingMode(colorScheme == .dark ? .template : .original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                Divider()
                    .padding(10)
                
                // List of tabs active tabs
                ForEach(tabs) { tab in
                    TabView(tab: tab, isSelected: tabSelectedTitle == tab.title ? true : false)
                        .onTapGesture {
                            // Assign tab so it knows to be highlighted
                            tabSelectedTitle = tab.title
                            tabSelectedSymbol = tab.sybmol
                        }
                }
                                
                // To keep everything tight to the top
                Spacer()
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        HStack (spacing: 0) {
            SidebarView()
                .frame(width: 75)
                .frame(minHeight: 500)
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 345)
        }
    }
}
