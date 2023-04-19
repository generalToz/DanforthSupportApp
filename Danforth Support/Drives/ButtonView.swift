//
//  ButtonView.swift
//  Danforth Network Drives
//
//  Created by Alex Tosspon on 3/24/23.
//

import SwiftUI

struct ButtonView: View {
    
    @EnvironmentObject var model: NetworkDrivesModel
    
    let driveLetter: String
    let driveName: String
    let isLoading: Bool
    let isAccessible: Bool
    
    @State private var insideButton = false
    @State var shadowRadius = CGFloat(2)
    @State var shadowX = CGFloat(1)
    @State var shadowY = CGFloat(3)
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            ZStack (alignment: .leading) {
                if isAccessible {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(insideButton ? Color("colorButtonIn") : Color("colorButtonOut"))
                        .shadow(radius: shadowRadius, x: shadowX, y: shadowY)
                }
                else{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.red)
                        .opacity(0.8)
                }
                HStack (spacing: 10) {
                    ZStack {
                        // maybe green outline to show mounted?
                        //                    if model.checkIsMounted(driveName) {
                        //                        Circle()
                        //                            .stroke(lineWidth: 3)
                        //                            .foregroundColor(.green)
                        //                    }
                        if isLoading {
                            Circle()
                                .fill(.shadow(.inner(radius: 1, x: 1, y: 1)))
                                .foregroundColor(.gray)
                                .opacity(0.35)
                            ProgressView()
                                .scaleEffect(0.88)
                        }
                        else if !isAccessible {
                            Circle()
                                .fill(.shadow(.inner(radius: 1, x: 1, y: 1)))
                                .foregroundColor(.gray)
                            Image(systemName: "bolt.slash.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                        }
                        else {
                            Circle()
                                .fill(.shadow(.inner(radius: 1, x: 1, y: 1)))
                                .foregroundColor(model.drivesMounted.contains(driveName) ? .green : .blue)
                            Text(driveLetter)
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            if insideButton && !model.drivesMounted.contains(driveName) {
                                Circle()
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .frame(height: 35)
                    Text(driveName)
                        .font(.title2)
                        .bold()
                        .blur(radius: isAccessible ? 0 : 3)
                }
                .padding(.leading, 8)
            }
            
            if !isAccessible {
                HStack (alignment: .center) {
                    Text("Inaccessible")
                }
                .foregroundColor(Color("colorBG"))
                .shadow(radius: 1, x: 1, y: 1)
                .font(.title2)
                .bold()
                .padding(.leading, 50)
            }
        }
        .frame(height: 45)
        .onHover { inside in
            if inside {
                self.insideButton = true
                self.shadowRadius = 1
                self.shadowX = 1
                self.shadowY = 2
            }
            else {
                self.insideButton = false
                self.shadowRadius = 2
                self.shadowX = 1
                self.shadowY = 3
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(driveLetter: "G:", driveName: "Public", isLoading: true, isAccessible: true)
    }
}
