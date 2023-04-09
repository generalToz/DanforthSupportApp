//
//  WebViewModel.swift
//  Danforth Password Change
//
//  Created by Alex Tosspon on 3/14/23.
//

import SwiftUI
import WebKit

class NavigationState : NSObject, ObservableObject {
    @Published var url : URL?
    let webView = WKWebView()
}

extension NavigationState : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.url = webView.url
    }
}

struct WebView : NSViewRepresentable {
    
    let request: URLRequest
    var navigationState : NavigationState
        
    func makeNSView(context: Context) -> WKWebView  {
        let webView = navigationState.webView
        webView.navigationDelegate = navigationState
        webView.load(request)
        return webView
    }
    
    func updateNSView(_ uiView: WKWebView, context: Context) { }
}
