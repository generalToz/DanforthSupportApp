//
//  TitleBarView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/28/23.
//

import SwiftUI

struct TitleBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack (spacing: 20) {
            Image(colorScheme == .dark ? "danforth.frond.white" : "danforth.frond")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            Text("Danforth Network Drives")
            Image(systemName: "externaldrive.connected.to.line.below")
        }
        .font(.title)
        .padding(.bottom, 12)    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView()
    }
}
