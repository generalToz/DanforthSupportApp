//
//  SwiftUIView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/8/23.
//

import SwiftUI

struct MenuIconView: View {
    var body: some View {
        Image("danforth.frond")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16, alignment: .center)
    }
}

struct MenuIconView_Previews: PreviewProvider {
    static var previews: some View {
        MenuIconView()
    }
}
