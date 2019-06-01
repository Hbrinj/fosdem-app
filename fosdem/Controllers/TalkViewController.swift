//
//  TalkViewController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 15/10/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TalkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var talkTableView: UITableView!

  var talk: Talk?
  var talkCells = [TalkCellType.talkTitle,
                   TalkCellType.talkSubtitle,
                   TalkCellType.talkDescription,
                   TalkCellType.scheduleButton]
  var realm: Realm?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    talkTableView.separatorColor = UIColor.clear
    talkTableView.rowHeight = UITableView.automaticDimension
    talkTableView.allowsSelection = false
    navigationItem.title = ""
    realm = try! Realm()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return talkCells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell

    switch talkCells[indexPath.row] {
    case .talkTitle:
      let genericCell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath) as! GenericLabelCell
      setupLabel(genericCell.genericLabel!, with: talk!.title)
      genericCell.genericLabel!.textAlignment = .center
      cell = genericCell
    case .talkSubtitle:
      let genericCell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath) as! GenericLabelCell
      setupLabel(genericCell.genericLabel!, with: talk!.subTitle!)
      genericCell.genericLabel!.textColor = UIColor.darkGray
      genericCell.genericLabel!.font = UIFont.systemFont(ofSize: 12)
      genericCell.genericLabel!.textAlignment = .center
      cell = genericCell
    case .talkDescription:
      let genericCell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath) as! GenericLabelCell
      setupLabel(genericCell.genericLabel!, with: stripHtml(from: talk!.abstract))
      cell = genericCell
    case .scheduleButton:
      cell = tableView.dequeueReusableCell(withIdentifier: "scheduleButtonCell", for: indexPath)
    }

    return cell
  }

  private func setupLabel(_ label: UILabel, with text: String ) {
    label.text = text
    label.numberOfLines = label.calculateMaxLines()
    label.lineBreakMode = .byWordWrapping
    label.sizeToFit()
  }

  private func stripHtml(from text: String) -> String {
    return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }

  @IBAction func addTalkToSchedule(_ sender: UIButton) {
    print("HIT!")
    try! realm?.write {
      realm!.add(TalkObject.convert(from: talk!))
    }
  }


}

extension UILabel {
  func calculateMaxLines() -> Int {
    let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
    let charSize = font.lineHeight
    let text = (self.text ?? "") as NSString
    let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    let lines = Int(textSize.height/charSize)
    return lines
  }

}
