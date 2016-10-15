//
//  Topic.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

class Topic {
  let name: String
  let displayName: String
  let topicArn: String
  
  init(name: String, displayName: String, topicArn: String) {
    self.name = name
    self.displayName = displayName
    self.topicArn = topicArn
  }
}
