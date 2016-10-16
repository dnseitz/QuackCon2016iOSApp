//
//  FootballViewController.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import PagingView

class FootballViewController: UIViewController {
  @IBOutlet weak var homeTeam: UILabel!
  @IBOutlet weak var homePossession: UIImageView!
  @IBOutlet weak var awayTeam: UILabel!
  @IBOutlet weak var awayPossession: UIImageView!
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var quarter: UILabel!
  @IBOutlet weak var plays: PagingView!
  
  @IBOutlet weak var background: UIImageView!
  fileprivate enum Team {
    case home, away
  }
  
  var playsList: [(String, String?)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      plays.dataSource = self
      plays.delegate = self
      plays.infinite = false
      plays.registerNib(UINib(nibName: "PlayViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayView")
      
      //homePossession.isHidden = true
      awayPossession.isHidden = true
      
      self.view.sendSubview(toBack: background)
      background.layer.masksToBounds = true
      
      //playsList = ["This is the first play", "This is the second", "This is the third"]
      sleep(4)
      playsList = [("", "A first down means the team has advanced the ball 10 yards from its starting position. A team has four downs to move the football 10 yards.")]
    }

  override func viewWillDisappear(_ animated: Bool) {
    background.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    background.isHidden = false
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func updateInformation(with json: [String : AnyObject], style: NotificationType) {
    guard style == .content else { return }
    if let possession = json["possession"] as? String {
      if let homeTeam = json["hometeam"] as? String {
        self.homeTeam.text = homeTeam
        if possession == homeTeam {
          self.setPossession(team: .home)
        }
      }
      if let awayTeam = json["awayteam"] as? String {
        self.awayTeam.text = awayTeam
        if possession == awayTeam {
          self.setPossession(team: .away)
        }
      }
    }
    if let homeScore = json["homescore"] as? Int, let awayScore = json["awayscore"] as? Int {
      self.score.text = "\(homeScore) - \(awayScore)"
    }
    if let quarter = json["quarter"] as? Int {
      self.quarter.text = "Quarter \(quarter)"
    }
    if let play = json["playdesc"] as? String {
      let help = json["tutorial"] as? String
      self.playsList.append((play, help))
    }
    self.plays.reloadData()
    self.plays.backgroundColor = UIColor.clear
  }
  
  fileprivate func setPossession(team: Team) {
    switch team {
    case .home:
      homePossession.isHidden = false
      awayPossession.isHidden = true
      break
    case .away:
      homePossession.isHidden = true
      awayPossession.isHidden = false
      break
    }
  }
}

extension FootballViewController: PagingViewDataSource, PagingViewDelegate {
  func pagingView(_ pagingView: PagingView, numberOfItemsInSection section: Int) -> Int {
    return self.playsList.count
  }
  
  func pagingView(_ pagingView: PagingView, cellForItemAtIndexPath indexPath: IndexPath) -> PagingViewCell {
    let cell = plays.dequeueReusableCellWithReuseIdentifier("PlayView")
    
    if let cell = cell as? PlayViewCell {
      cell.textLabel.text = self.playsList[indexPath.item].0
      cell.helpLabel.text = self.playsList[indexPath.item].1
      cell.helpLabel.textColor = UIColor.blue
      cell.textLabel.backgroundColor = UIColor.clear
    }
    
    return cell
  }
  
//  func indexPathOfStartingInPagingView(_ pagingView: PagingView) -> IndexPath? {
//    if self.playsList.count > 0 {
//      return IndexPath(item: self.playsList.count - 1, section: 0)
//    }
//    return nil
//  }
}
