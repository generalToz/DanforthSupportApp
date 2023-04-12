//
//  NetworkDrivesView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//

import SwiftUI

struct NetworkDrivesView: View {
    @EnvironmentObject var model: NetworkDrivesModel

    var body: some View {
        
        Spacer()
        
        ZStack {
            if !model.isAuthenticated && !model.isConnected {
                DisconnectedView()
                    .onDisappear {
                        model.quitChecking = true
                    }
            }
            else if model.isConnected && !model.isAuthenticated {
                LoginView()
            }
            else {
                DrivesMenuView()
            }
        }
        Spacer()
    }
}

struct NetworkDrivesView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkDrivesView()
    }
}
