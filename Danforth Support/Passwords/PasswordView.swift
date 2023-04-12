//
//  PasswordView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//
//  This article helped the most: https://stackoverflow.com/questions/66838373/how-do-i-display-wkwebview-url

import SwiftUI
import WebKit

struct PasswordView: View {

    @State var showDanforthPWChange = false
    @State var danforthPasswordSuccess = false
    @State var showMacPWChange = false
    @State var macPasswordSuccess = false
    
    var body: some View {
        
        ZStack {
            
            // Initial page with options for resetting either password
            if !showDanforthPWChange && !showMacPWChange {
                VStack {
                    Spacer()
                    // Buttons
                    VStack (alignment: .leading, spacing: 30) {
                        // Danforth Password Change
                        PasswordButtonViews(type: .danforth, isSuccess: danforthPasswordSuccess)
                            .onTapGesture {
                                if !danforthPasswordSuccess {
                                    showDanforthPWChange = true
                                }
                            }
                        // Mac Password Change
                        PasswordButtonViews(type: .mac, isSuccess: macPasswordSuccess)
                            .onTapGesture {
                                if !macPasswordSuccess {
                                    showMacPWChange = true
                                }
                            }
                    }
                    .frame(height: 225)
                    .padding()
                    Spacer ()
                    // Reminder text
                    HStack {
                        Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                        Text("**Reminder:** Your Mac's password does not sync with your Danforth password and must be changed separately.")
                            .font(.body)
                            .frame(width: 250)
                    }
                    .padding()
                    Spacer()
                }
                .transition(.scale)
            }
            
            // Display the Microsoft Password Change page
            if showDanforthPWChange {
                
               DanforthPWChangeview(showDanforthPWChange: $showDanforthPWChange, danforthPasswordSuccess: $danforthPasswordSuccess)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 3, x: 2, y: 2)
                    .transition(.move(edge: .trailing))
            }
            
            // Display secure fields for Mac Password Change page:
            if showMacPWChange {
                MacPWChangeView(showMacPWChange: $showMacPWChange, macPasswordSuccess: $macPasswordSuccess)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeIn, value: showMacPWChange)
        .animation(.easeIn, value: showDanforthPWChange)
        .padding(.top)
        .padding(.horizontal)

// FIXME: don't want app to quit when timeout
//        if pageURL.contains(timeOutPage) {
//            Rectangle()
//                .foregroundColor(.white)
//                .onAppear {
//                    NSApp.terminate(nil)
//                }
//        }
}
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
            .frame(width: 375, height: 450)
    }
}
