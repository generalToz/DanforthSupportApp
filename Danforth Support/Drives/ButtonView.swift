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
    
    @State private var insideButton = false
    @State var shadowRadius = CGFloat(2)
    @State var shadowX = CGFloat(1)
    @State var shadowY = CGFloat(3)
    
    var body: some View {
        
        ZStack {
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(insideButton ? Color("colorButtonIn") : Color("colorButtonOut"))
                    .shadow(radius: shadowRadius, x: shadowX, y: shadowY)
                HStack {
                    ZStack {
                        Circle()
                            .foregroundColor(insideButton ? .gray : .blue)
                        // maybe green outline to show mounted?
                        //                    if model.checkIsMounted(driveName) {
                        //                        Circle()
                        //                            .stroke(lineWidth: 3)
                        //                            .foregroundColor(.green)
                        //                    }
                        Text(driveLetter)
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                    .frame(height: 35)
                    Text(driveName)
                        .font(.title2)
                        .bold()
                }
                .padding(.leading, 8)
            }
            .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                ProgressView()
            }
        }
        .frame(width: 175, height: 60)
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
        ButtonView(driveLetter: "G:", driveName: "Public", isLoading: false)
    }
}
