//
//  QuackConHTTPRequest.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

struct QuackConHTTPRequest {
  let parameters: [String: String]?
  let route: String
  let host = "http://67.171.192.151:3000"
  
  init(_ route: String, parameters params: [String: String]? = nil) {
    self.route = route
    self.parameters = params
  }
  
  func get(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
      var request = buildRequest()
      request.httpMethod = "GET"
      let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
      task.resume()
  }
  
  func post(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var request = buildRequest()
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
  }
  
  private func buildRequest() -> URLRequest {
    let paramString: String
    if let parameters = self.parameters {
      var paramList: [String] = []
      for (key, value) in parameters {
        paramList.append("\(key)=\(value)")
      }
      if paramList.count > 0 {
        paramString = "?\(paramList.joined(separator: "&"))"
      }
      else {
        paramString = ""
      }
    }
    else {
      paramString = ""
    }
    let url = URL(string: "\(host)\(route)\(paramString)")!
    print(url.absoluteString)
    return URLRequest(url: url)
  }
}
