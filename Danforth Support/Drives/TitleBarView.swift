//
//  TitleBarview.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/12/23.
//

import SwiftUI

struct TitleBarView: View {    
    var body: some View {
        HStack {
            Text("Danforth Network Drives")
                .font(.title2)
                .bold()
            Spacer()
            RefreshButton()
        }
        .frame(height: 75)
        .padding(.horizontal, 4)
    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView()
            .frame(width: 320)
            .environmentObject(NetworkDrivesModel())
        
    }
}
