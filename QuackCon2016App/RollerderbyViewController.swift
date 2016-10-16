//
//  RollerderbyViewController.swift
//  QuackCon2016App
//
//  Created by Daniel Seitz on 10/15/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import UIKit
import PagingView

class RollerderbyViewController: UIViewController {
  @IBOutlet weak var homeTeam: UILabel!
  @IBOutlet weak var awayTeam: UILabel!
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var play: UILabel!
  @IBOutlet weak var help: UILabel!
  //@IBOutlet weak var tips: PagingView!
  @IBOutlet weak var background: UIImageView!
  
  let strokeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName : UIColor.white,
    NSStrokeWidthAttributeName : -1.0,
    ] as [String : Any]
  
  var tipsList: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additinal setup after loading the view.
    
    homeTeam.attributedText = NSAttributedString(string: homeTeam.text!, attributes: strokeTextAttributes)
    awayTeam.attributedText = NSAttributedString(string: awayTeam.text!, attributes: strokeTextAttributes)
    score.attributedText = NSAttributedString(string: score.text!, attributes: strokeTextAttributes)
    
//    tips.delegate = self
//    tips.dataSource = self
//    tips.infinite = false
//    tips.registerNib(UINib(nibName: "PlayViewCell", bundle: nil), forCellWithReuseIdentifier: "TipView")
    
    self.view.sendSubview(toBack: background)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    background.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    background.isHidden = false
  }

  
  override func updateInformation(with json: [String : AnyObject], style: NotificationType) {
    if let data = json["data"] as? [String: AnyObject] {
      if let alert = json["alert"] as? String {
        tipsList.append(alert)
//        tips.reloadData()
//        tips.backgroundColor = UIColor.clear
      }
      parseDataObject(data)
    }
    else {
      parseDataObject(json)
    }
  }
  
  func parseDataObject(_ data: [String : AnyObject]) {
    if let homeScore = data["score_one"] as? Int, let awayScore = data["score_two"] as? Int {
      score.attributedText = NSAttributedString(string: "\(homeScore) - \(awayScore)", attributes: strokeTextAttributes)
    }
    if let play = data["detail"] as? String {
      self.play.text = play
    }
  }
}

//extension RollerderbyViewController: PagingViewDelegate, PagingViewDataSource {
//  func pagingView(_ pagingView: PagingView, numberOfItemsInSection section: Int) -> Int {
//    return self.tipsList.count
//  }
//  
//  func pagingView(_ pagingView: PagingView, cellForItemAtIndexPath indexPath: IndexPath) -> PagingViewCell {
//    let cell = tips.dequeueReusableCellWithReuseIdentifier("TipView")
//    
//    if let cell = cell as? PlayViewCell {
//      cell.textLabel.attributedText = NSAttributedString(string: self.tipsList[indexPath.item], attributes: strokeTextAttributes)
//      cell.textLabel.backgroundColor = UIColor.clear
//    }
//    
//    return cell
//  }
//}
