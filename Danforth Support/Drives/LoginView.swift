//
//  LoginView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    @State var submitted = false
    @State var displayProgressView = false
    @State var loginFailed = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("colorBG"))
                    .opacity(0.8)
                    .frame(width: 280, height: 280)
                    .shadow(radius: 3, x: 2, y: 2)
                VStack {
                    Text("Please login to your Danforth account:")
                        .padding(.vertical)
                    VStack {
                        TextField("Danforth user name", text: $model.username)
                        SecureField("Danforth password", text: $model.password)
                    }
                    .disabled(submitted)
                    Text("Username or password is incorrect")
                        .font(.callout)
                        .foregroundColor(.red)
                        .opacity(loginFailed && !model.isAuthenticated ? 1 : 0)
                    HStack {
                        Spacer()
                        Button("Continue") {
                            Task {
                                submitted = true    // disables button and fields
                                model.isConnected = await model.connectionCheck()
                                if model.isConnected {
                                    displayProgressView = true
                                    // false delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        displayProgressView = false
                                        model.isAuthenticated = model.authenticationCheck()
                                        model.getDrives()
                                        
                                        // kickback invalid login
                                        if !model.isAuthenticated {
                                            loginFailed = true
                                            submitted = false
                                        }
                                    }
                                }
                            }
                        }
                        .disabled(submitted)
                        .keyboardShortcut(.defaultAction)
                        .padding(.bottom)
                    }
                }
                .padding(.horizontal, 75)
                .blur(radius: submitted ? 1.2 : 0)
                
                if displayProgressView {
                    ProgressView()
                        .scaleEffect(1.2)
                }
            }
            
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(NetworkDrivesModel())
            .frame(width: 400, height: 325)

    }
}
