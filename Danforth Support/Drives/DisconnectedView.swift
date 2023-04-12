//
//  DisconnectedView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//

import SwiftUI

struct DisconnectedView: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    var body: some View {
        
        VStack {
            ProgressView()
                .padding()
            Text("Connecting to Danforth network...")
        }
        .task {
            await model.connectionCheckLoop()
            if !model.quitChecking {
                model.isAuthenticated = model.authenticationCheck()
                //            print("from View1: authentication: \(model.isAuthenticated)")
                //            print("from View1: storedUsername: \(model.storedUsername)")
                //            print("from View1: username: \(model.username)")
            }
        }
        
        
    }
}

struct DisconnectedView_Previews: PreviewProvider {
    static var previews: some View {
        DisconnectedView()
    }
}
