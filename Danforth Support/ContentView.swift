//
//  ContentView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("tabSymbol") var tabSelectedSymbol = ""
    @AppStorage("tabTitle") var tabSelectedTitle = ""
        
    var body: some View {
        // ZStack to ensure that sidebar is always on top
        ZStack {
            // Right side - Content
            HStack (spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 75)
                ZStack {
                    // Background rect to maintain total shape to 390px
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 320)
                        .frame(minHeight: 500)

                    // PageViews
                    VStack {

                        if tabSelectedTitle == "Passwords" {
                            PasswordView()
                        }
                        else if tabSelectedTitle == "Drives" {
                            NetworkDrivesView()
                                .environmentObject(NetworkDrivesModel())
                        }
                        else if tabSelectedTitle == "Links" {
                            LinksView()
                        }
                        else if tabSelectedTitle == "About" {
                            AboutView()
                        }
                        else {
                            Spacer()
                        }

                        // Bottom toolbar at the bottom
                        HStack {
                            Text("About")
                                .onTapGesture {
                                    tabSelectedTitle = "About"
                                }
                            Divider()
                                .frame(height: 15)
                            Text("Quit")
                                .onTapGesture {
                                    NSApp.terminate(nil)
                                }
                        }
                        .font(.caption)
                        .padding(.bottom)
                    }
                }
            }
            // Left side - Sidebar
            HStack (spacing: 0) {
                // Sidebar fits 75px on left
                SidebarView()
                    .frame(width: 75)
                Spacer()
            }
        } // zstack
    } // view
} // struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 395)
            .frame(minHeight: 500)
    }
}
