//
//  ContentView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/8/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack (spacing: 0) {
            SidebarView()

            VStack {
    
                // TODO: change this rect into content views
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 345)
                
                // Toolbar at the bottom
                HStack {
                    Text("About")
                    Divider()
                        .frame(height: 15)
                    Text("Quit")
                        .onTapGesture {
                            NSApp.terminate(nil)
                        }
                }
                .font(.footnote)
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 420)
            .frame(minHeight: 500)
    }
}
