//
//  ViewController.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import AWSSNS


class ViewController: UITableViewController {

  var topics: [Topic] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.getTopics()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.topics.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
    
    cell.textLabel?.text = self.topics[indexPath.row].displayName
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let topic = self.topics[indexPath.row]
    
    if topic.displayName.range(of: "Football") != nil {
      // We would subscribe to this topic here...
      let fbViewController = FootballViewController(nibName: "FootballViewController", bundle: nil)
      self.navigationController?.pushViewController(fbViewController, animated: true)
    }
    else if topic.displayName.range(of: "Rollerderby") != nil {
      // Same down here...
      
    }
  }
  
  func getTopics() {
    let request = QuackConHTTPRequest("/topics")
    request.get() {(data, response, error) in
      if let error = error {
        print(error)
      }
      else {
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
        self.topics.removeAll()
        
        for (key, value) in json {
          let value = value as! [String: String]
          let displayName = value["displayName"]!
          let topicArn = value["topicArn"]!
          let topic = Topic(name: key, displayName: displayName, topicArn: topicArn)
          self.topics.append(topic)
          print(topic.name)
        }
        
        self.tableView.reloadData()
        
      }
    }
  }
  
  func subscribe(topic: Topic) {
    let subscribe = QuackConHTTPRequest("/subscribe", parameters: ["topic": topic.name, "protocol": "application", "endpointArn": AppDelegate.endpointArn!])
    
    subscribe.post() {(data, response, error) in
      if let error = error {
        print(error)
      }
      else {
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
        
        if let error = json["error"] {
          print (error)
        }
        else {
          print (json["subscriptionArn"])
        }
      }
    }
  }
}

