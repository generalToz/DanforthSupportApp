//
//  Danforth_SupportApp.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/8/23.
//

import SwiftUI

@main
struct Danforth_Support_App: App {
    var body: some Scene {
        
        MenuBarExtra {
            ContentView()
        } label: {
            // 16x16 low res icon
            Image("frond.menu.icon")
                .renderingMode(.template)
            
            // FIXME: There is an open question on Stack Exchange on how to manage the image size using a view
            // MenuIconView()
        }
        .menuBarExtraStyle(.window)
    }
}
