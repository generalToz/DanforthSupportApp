//
//  DrivesMenuView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//

import SwiftUI

struct DrivesMenuView: View {
    @EnvironmentObject var model: NetworkDrivesModel
        
    var body: some View {
        
        VStack {
            TitleBarView()
            ZStack {
                VStack {
                    ForEach(model.drives) { drive in
                        ZStack {
                            ButtonView(driveLetter: drive.letter, driveName: drive.name, isLoading: drive.isLoading, isAccessible: drive.isAccessible)
                                .onTapGesture {
                                    // the button click
                                    if let i = model.drives.firstIndex(where: { $0.name == drive.name }) {       // flag to tell button to show progress view
                                        model.drives[i].isLoading = true
                                    }
                                    model.buttonClicked.toggle()
                                    Task {
                                        await model.isConnected = model.connectionCheck()
                                        model.isAuthenticated = model.authenticationCheck()
                                        //                                        drivesToMount.append(drive)
                                        let modelResult = await model.mountDrive(drive)
                                        if modelResult == "Inaccessible" {
                                            if let i = model.drives.firstIndex(where: { $0.name == drive.name }) {
                                                model.drives[i].isAccessible = false
                                            }
                                        }
                                        //                                        drivesToMount = [NetworkDrive]()
                                        if let i = model.drives.firstIndex(where: { $0.name == drive.name }) {       // flag to tell button to hide progress view
                                            model.drives[i].isLoading = false
                                        }
                                    }
                                }
                                .disabled(model.isRefreshing || !drive.isAccessible)
//                                .blur(radius: drive.isAccessible ? 0 : 3)
                           
                        }  // Button creation
                        .blur(radius: model.isRefreshing ? 3 : 0)
                        
                    } // ForEach
                }
                if model.isRefreshing {
                    ProgressView()
                        .scaleEffect(1.5)
                } // end if
            } // zstack
            
            HStack {
                Spacer()
                Text("Logout") // \(model.username)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .shadow(radius: 1, x: 1, y: 1)
                    .onTapGesture {
                        model.storedPassword = ""
                        model.password = ""
                        model.isAuthenticated = false
                        // add kdestroy?
                    }
            } // logout view
            .padding(.bottom, 12)
            .padding(.horizontal, 4)
            Spacer()
        }
        .frame(width: 280)
        .onAppear {
            
            model.isAuthenticated = model.authenticationCheck()
            //            model.getDrives()
            if model.networkDrivesData.isEmpty {
                model.getDrives()
            }
            model.loadDrives()
            
        }
        
    }
}

struct DrivesMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DrivesMenuView()
            .environmentObject(NetworkDrivesModel())
            .frame(width: 320)
            .frame(minHeight: 600)
    }
}
