//
//  DanforthPWChangeview.swift
//  Danforth Support
//
//  Created by Alex Tosspon on 4/10/23.
//

import SwiftUI

struct DanforthPWChangeview: View {
    @StateObject var navigationState = NavigationState()
    
    @State var showWebView = false
    
    @Binding var showDanforthPWChange: Bool
    @Binding var danforthPasswordSuccess: Bool

    var body: some View {
        
        let pageURL = navigationState.url?.absoluteString ?? "(none)"
        let msHome = "office.com"
        let pwChangePage = "https://account.activedirectory.windowsazure.com/ChangePassword.aspx?BrandContextID=O365&ruO365="
        let pwReturnCode = "https://portal.office.com/ChangePassword.aspx?ReturnCode"
        //        let msLogin = "login.microsoftonline.com"
        //        let timeOutPage = "https://account.activedirectory.windowsazure.com/PageTimedOut.aspx"
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .onAppear {
                    showWebView = true
                }
            
            if showWebView {
                WebView(request: URLRequest(url: URL(string: pwChangePage)!), navigationState: navigationState)
                // the smallest possible size at which webview doesn't have a scroll bars
                    .frame(height: 598)
                
                // Adds a whiteout rectangle at top of window to hide the microsoft menu
                if pageURL.contains(pwChangePage) {
                    VStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 90)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                
                if  pageURL.contains(msHome) || pageURL.contains(pwReturnCode) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .onAppear {
                            danforthPasswordSuccess = true
                            showWebView = false
                        }
                        .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                showDanforthPWChange = false
                            }
                        }
                }
                
                if pageURL.contains("none") {
                    ProgressView()
                }
                // MARK: URL shown for Testing
                // VStack {
                //      Spacer()
                //      Text(pageURL)
                //          .font(.caption2)
                //       .foregroundColor(Color.blue)
                //       .multilineTextAlignment(.leading)
                //       .textSelection(.enabled)
                // }
            }
//            else {
//                ProgressView()
//            }
        }
    }
}

struct DanforthPWChangeview_Previews: PreviewProvider {
    static var previews: some View {
        DanforthPWChangeview(showDanforthPWChange: .constant(false), danforthPasswordSuccess: .constant(false))
    }
}
