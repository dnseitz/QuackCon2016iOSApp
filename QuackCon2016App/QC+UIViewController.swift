//
//  QC+UIViewController.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit

protocol Notifiable {
  func updateInformation(with json:[String: AnyObject], style: NotificationType)
}

extension UIViewController : Notifiable {
  func updateInformation(with json:[String: AnyObject], style: NotificationType) {
    // Override in subclass
  }
}
