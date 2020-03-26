//
//  MarkdownView.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 24.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import SwiftUI
import WebKit
import Down

struct MarkdownView: UIViewRepresentable {
  let text: String
  var title: String? = nil

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    
    return webView
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    let down = Down(markdownString: text)
    
    if let html = try? down.toHTML() {
      var pageTitle = ""
      if let title = self.title {
        pageTitle = "<h1 class=\"main-title\">\(title)</h1>"
      }
      let body = """
      <html>
          <head>
              <style>
                body {
                  font-family: -apple-system, Helvetica; sans-serif;
                  padding: 5px 10px;
                }
              </style>
              <meta name="viewport" content="width=device-width, initial-scale=1">
          </head>
          <body>
              \(pageTitle)
              \(html)
          </body>
      </html>
      """

      uiView.loadHTMLString(body, baseURL: Bundle.main.resourceURL)
    }
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
      if let url = navigationAction.request.url {
        if url.absoluteString.starts(with: "http") {
          UIApplication.shared.open(url)
          decisionHandler(.cancel)
          return
        }
      }

      decisionHandler(.allow)
    }
  }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
      MarkdownView(text: "Markdown: **Bold**")
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
    }
}
