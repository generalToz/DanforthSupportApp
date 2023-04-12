//
//  ToolBarView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/28/23.
//

import SwiftUI

struct ToolBarView: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    var body: some View {
        ZStack {
            HStack (spacing: 6) {
                Text("Logout")
                    .foregroundColor(.blue)
                    .font(.subheadline)
                    .onTapGesture {
                        model.storedPassword = ""
                        model.password = ""
                        model.isAuthenticated = false
                        // add kdestroy?
                    }
                Text("\(model.username)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.blue)
                    .font(.body)
                    .offset(y: -3)
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
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView()
            .environmentObject(NetworkDrivesModel())
    }
}
