//
//  RefreshButton.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/12/23.
//

import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    @State private var insideButton = false

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 21)
                .shadow(radius: 1, x: 1, y: 1)
            Image(systemName: "arrow.counterclockwise.circle.fill")
                .foregroundColor(insideButton ? .gray : .blue)
                .font(.title)
                .onTapGesture {
                    model.isRefreshing = true
                    Task {
                        await model.isConnected = model.connectionCheck()
                        model.isAuthenticated = model.authenticationCheck()
                        model.getDrives()
                        model.loadDrives()
                        model.isRefreshing = false
                    }
                }
        }
        .onHover { inside in
            if inside {
                insideButton = true
            }
            else {
                insideButton = false
            }
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton()
    }
}
