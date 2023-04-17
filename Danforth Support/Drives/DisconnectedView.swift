//
//  DisconnectedView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//

import SwiftUI

struct DisconnectedView: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    @State private var showDelayText1 = false
    @State private var showDelayText2 = false
    @State private var timedOut = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            Spacer()
            // Symbol
            VStack {
                if !timedOut {
                    ProgressView()
                }
                else {
                    Image(systemName: "bolt.slash")
                        .font(.largeTitle)
                }
            }
            .frame(height: 30)
            
            // Main display text
            if !timedOut {
                Text("Connecting to Danforth network...")
                    .padding(.vertical)
                    .font(.title3)
            }
            else {
                Text("Disconnected from Danforth network")
                    .padding(.vertical)
                    .font(.title3)
            }
            
            // Delay Text Group
            VStack (alignment: .leading) {
                
                // Delay Text 1
                if !timedOut {
                    Text("This is taking longer than expected.")
                        .padding(.bottom, 4)
                        .opacity(showDelayText1 ? 1 : 0)
                }
                else {
                    Text("Unable to locate Danforth resources.")
                        .padding(.bottom, 4)
                }
                
                // Delay Text 2
                Text("Please make sure that you're properly connected to Danforth_Center wi-fi or VPN.")
                    .opacity(showDelayText2 ? 1 : 0)
                
                
            } // content vstack
            .multilineTextAlignment(.leading)
            .font(.callout)
            .bold()
            .frame(width: 224)
            
            // Refresh Button
            Button("Refresh") {
                model.quitChecking = false
                showDelayText1 = false
                showDelayText2 = false
                timedOut = false
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                        showDelayText1 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 14) {
                        showDelayText2 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                        model.quitChecking = true
                        timedOut = true
                        print("connection timeout - quitting check")
                    }
                }
                Task {
                    await model.connectionCheckLoop()
                    if !model.quitChecking {
                        model.isAuthenticated = model.authenticationCheck()
                    }
                }
            } // button
            .opacity(timedOut ? 1 : 0)
            .padding()
            
            Spacer()
            
        } // main vstack
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                showDelayText1 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 14) {
                showDelayText2 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                model.quitChecking = true
                timedOut = true
                print("connection timeout - quitting check")
            }
        } // task1
        .task {
            await model.connectionCheckLoop()
            if !model.quitChecking {
                model.isAuthenticated = model.authenticationCheck()
            }
        } // task2
        
    } // view
} // struct

struct DisconnectedView_Previews: PreviewProvider {
    static var previews: some View {
        DisconnectedView()
    }
}
