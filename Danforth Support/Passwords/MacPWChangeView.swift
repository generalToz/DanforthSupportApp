//
//  MacPWChangeView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/10/23.
//

import SwiftUI

struct MacPWChangeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var macPW = MacPasswordValidation()
    
    @Binding var showMacPWChange: Bool
    @Binding var macPasswordSuccess: Bool

    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("colorBG"))
                    .frame(width: 280, height: 280)
                    .shadow(radius: 3, x: 2, y: 2)
                
                VStack {
                    // Title
                    VStack {
                        Text("**Change Mac Password**")
                        Text("for \(macPW.fullName)")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 6)
                    
                    // Fields
                    VStack {
                        HStack {
                            SecureField("Old Password", text: $macPW.oldPassword)
                            if macPW.oldPassword != "" {
                                Image(systemName: macPW.oldPasswordCheck)
                                    .foregroundColor(macPW.oldPasswordCheck == "xmark" ? .red : .green)
                                    .bold()
                                    .frame(width: 8, height: 8)
                            }
                        }
                        HStack {
                            SecureField("New Password", text: $macPW.newPassword)
                                .onChange(of: macPW.newPassword) { _ in
                                    macPW.verifyPassword = ""
                                }
                            if macPW.newPassword != "" {
                                Image(systemName: macPW.newPasswordCheck)
                                    .foregroundColor(macPW.newPasswordCheck == "xmark" ? .yellow : .green)
                                    .bold()
                                    .frame(width: 8, height: 8)
                            }
                        }
                        HStack {
                            SecureField("Verify", text: $macPW.verifyPassword)
                            if macPW.verifyPassword != "" {
                                Image(systemName: macPW.verifyPasswordCheck)
                                    .foregroundColor(macPW.verifyPasswordCheck == "xmark" ? .red : .green)
                                    .bold()
                                    .frame(width: 8, height: 8)
                            }
                        }
                        HStack {
                            TextField("Password Hint (recommended)", text: $macPW.passwordHint)
                            if macPW.passwordHint != "" {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .bold()
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Red alert text
                    VStack (alignment: .leading) {
                        Text(macPW.errorMessageLine1)
                        Text(macPW.errorMessageLine2)
                    }
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.red)
                    .frame(height: 12)
                    .padding(.top, 6)
                    
                    // Buttons
                    HStack (spacing: 30){
                        Button {
                            macPasswordSuccess = false
                            showMacPWChange = false
                        } label: {
                            Text("Cancel")
                        }
                        .keyboardShortcut(.cancelAction)
                        Button {
                            macPW.setMacPassword()
                            macPasswordSuccess = true
                        } label: {
                            Text("Change")
                        }
                        .keyboardShortcut(.defaultAction)
                        .disabled(!macPW.changeAllowed)
                    }
                    .padding(6)
                }
                .frame(width: 255)
            }
            
            Spacer()
        }
    }
}

struct MacPWChangeView_Previews: PreviewProvider {
    static var previews: some View {
        MacPWChangeView(showMacPWChange: .constant(false), macPasswordSuccess: .constant(false))
            .frame(width: 375, height: 450)

    }
}
