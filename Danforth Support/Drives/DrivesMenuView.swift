//
//  DrivesMenuView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/23/23.
//

import SwiftUI

struct DrivesMenuView: View {
    @EnvironmentObject var model: NetworkDrivesModel
    
    
//    @State var drivesToMount = [NetworkDrive]()
    
    var body: some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        VStack {
            TitleBarView()
            ZStack {
                LazyVGrid (columns: columns, spacing: 12) {
                    ForEach(model.drives) { drive in
                        ZStack {
                            ButtonView(driveLetter: drive.letter, driveName: drive.name, isLoading: drive.isLoading)
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
                                .blur(radius: drive.isAccessible ? 0 : 2)
                            
                            if !drive.isAccessible {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.red)
                                    .opacity(drive.isAccessible ? 0 : 0.30)
                                HStack (alignment: .center) {
                                    Image(systemName: "bolt.slash.fill")
                                    Text("Inaccessible")
                                }
//                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .blur(radius: model.isRefreshing ? 1.2 : 0)
                
                if model.isRefreshing {
                    ProgressView()
                }
            }
            Spacer()
            
            // tool bar at bottom
            ToolBarView()
        }
        .padding(.top, 20)
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
            .frame(width: 400, height: 325)
    }
}
