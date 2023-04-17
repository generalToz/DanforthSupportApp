//
//  LinksView.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/9/23.
//

import SwiftUI

struct LinksView: View {
    
    var body: some View {
        
        VStack {
            HStack (alignment: .center) {
                Text("Danforth Links")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .frame(height: 75)
            .padding(.horizontal, 4)
            
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("colorBG"))
                    .shadow(radius: 3, x: 2, y: 2)
                VStack (alignment: .leading) {
                    
                    LinkView(image: "danforth.frond", name: "Danforth Center", link: "https://www.danforthcenter.org", render: .lightOnly)
                    LinkView(image: "outlook.icon", name: "Webmail", link: "https://outlook.office.com", render: .lightAndDark)
                    LinkView(image: "spam.icon", name: "Spam Server", link: "https://spm1.danforthcenter.org", render: .none)
                    LinkView(image: "okta", name: "Okta", link: "https://ddpsc.okta.com", render: .lightAndDark)
                    LinkView(image: "workvivo", name: "Workvivo", link: "https://www.workvivo.com", render: .lightOnly)
                    LinkView(image: "cafe", name: "Café Menu", link: "https://danforthcafe.brinkpos.net", render: .none)
                    
                    Spacer()
                }
                .font(.title3)
                .padding(.horizontal)
            }
        }
        .frame(width: 280)
        .padding(.bottom)
        
    }
}

struct LinkView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var image: String
    @State var name: String
    @State var link: String
    @State var render: RenderInColor
    @State private var isInside = false
    
    enum RenderInColor {
        case lightOnly
        case lightAndDark
        case none
    }
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            Rectangle()
                .foregroundColor(.blue)
                .opacity(isInside ? 1 : 0)
                .onHover { inside in
                    if isInside {
                        isInside = true
                    }
                    else {
                        isInside = false
                    }
                }
            HStack {
                Group {
                    if render == .none {
                        Image(image)
                            .renderingMode(.template)
                            .resizable()
                    }
                    else if render == .lightOnly {
                        Image(image)
                            .renderingMode(colorScheme == .dark ? .template : .original)
                            .resizable()
                    }
                    else if render == .lightAndDark {
                        Image(image)
                            .renderingMode(.original)
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 30, height: 30)
                
                Link(destination: URL(string: link)!) {
                    VStack (alignment: .leading, spacing: 1) {
                        Text(name)
                            .font(.headline)
                        Text(link)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 6)
                }
            }
        }
        
    }
}


struct LinksView_Previews: PreviewProvider {
    static var previews: some View {
        LinksView()
            .frame(width: 320)
    }
}

