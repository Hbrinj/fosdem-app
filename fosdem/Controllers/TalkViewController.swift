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
  private var talkCells = [TalkCellType.talkTitle,
                   TalkCellType.talkSubtitle,
                   TalkCellType.talkDescription,
                   TalkCellType.scheduleButton]
  private let realm = try! Realm()
  private var realmTalkObjectRef: Results<TalkObject>?
  private var talkRemovedNotif: NotificationToken? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    talkTableView.separatorColor = UIColor.clear
    talkTableView.rowHeight = UITableView.automaticDimension
    talkTableView.allowsSelection = false
    navigationItem.title = ""
    realmTalkObjectRef = realm.objects(TalkObject.self).filter("id = %@", talk!.id)
    setupTalkRemovedNotif()
  }

  // MARK: -Setup
  private func setupTalkRemovedNotif() {
    talkRemovedNotif = realmTalkObjectRef?.observe { [weak self] (changes: RealmCollectionChange) in
        guard let tableView = self?.talkTableView else { return }
        switch changes {
        case .initial:
          break
        case .update(_,_,_,_):
          guard let index = self?.talkCells.firstIndex(of: .scheduleButton) else { return }
          let indexPath = IndexPath(row: index, section: 0)
          self?.setupScheduleButton((tableView.cellForRow(at: indexPath) as! ScheduleButtonCell).scheduleButton)
        case .error(let error):
          fatalError("\(error)")
        }
      }
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
      let buttonCell = tableView.dequeueReusableCell(withIdentifier: "scheduleButtonCell", for: indexPath) as! ScheduleButtonCell
      setupScheduleButton(buttonCell.scheduleButton)
      cell = buttonCell
    }

    return cell
  }

  private func setupLabel(_ label: UILabel, with text: String ) {
    label.text = text
    label.numberOfLines = label.calculateMaxLines()
    label.lineBreakMode = .byWordWrapping
    label.sizeToFit()
  }

  private func setupScheduleButton(_ button: UIButton) {
    if realmTalkObjectRef?.count != 0 {
      button.setTitle("Remove From Schedule", for: .normal)
      button.setTitleColor(.red, for: .normal)
    } else {
      button.setTitle("Add to schedule", for: .normal)
      button.setTitleColor(.systemBlue, for: .normal)
    }
  }

  private func stripHtml(from text: String) -> String {
    return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }

  @IBAction func talkScheduleButton(_ sender: UIButton) {
    // If its there remove it because we're showing a remove button
    if realmTalkObjectRef?.first != nil {
      guard let objectRef = realmTalkObjectRef?.first! else { return }
      try! realm.write {
        realm.delete(objectRef)
      }
    } else {
      try! realm.write {
        realm.add(TalkObject.convert(from: talk!))
      }
    }
  }

  deinit {
    talkRemovedNotif?.invalidate()
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

extension UIColor {
  static let systemBlue = UIButton(type: .system).tintColor
}
