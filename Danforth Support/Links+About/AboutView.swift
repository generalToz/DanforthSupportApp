//
//  AboutView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("colorBG"))
                    .shadow(radius: 3, x: 2, y: 2)
                VStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        Text("Introducing the")
                            .bold()
                        Text("Danforth Support App")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .bold()
                        Text("This app has been created exclusively for the Donald Danforth Plant Science Center.")
                            .font(.callout)
                            .padding(.top, 8)
                        Text("Here, you can find quick access to password changes, network drives, and important links")
                            .font(.callout)
                            .padding(.top, 8)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        VStack (alignment: .trailing) {
                            Text("Version 0.01beta")
                            Text("2023 © Alex Tosspon")
                        }
                        .font(.system(size: 7))
                    }
                }
                .padding()
                .padding(.top)
            }
        }
        .padding(.top)
        .frame(width: 280)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .frame(width: 320)
    }
}
