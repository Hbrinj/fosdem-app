//
//  TalkViewController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 15/10/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation
import UIKit

class TalkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var talkTableView: UITableView!

  var talk: Talk?
  var talkCells = [TalkCellType.talkTitle,TalkCellType.talkSubtitle, TalkCellType.talkDescription]


  override func viewDidLoad() {
    super.viewDidLoad()
    talkTableView.separatorColor = UIColor.clear
    talkTableView.rowHeight = UITableView.automaticDimension
    talkTableView.allowsSelection = false
    navigationItem.title = ""
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return talkCells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath) as! GenericLabelCell
    switch talkCells[indexPath.row] {
    case .talkTitle:
      setupLabel(cell.genericLabel!, with: talk!.title)
      cell.genericLabel!.textAlignment = .center
    case .talkSubtitle:
      setupLabel(cell.genericLabel!, with: talk!.subTitle!)
      cell.genericLabel!.textColor = UIColor.darkGray
      cell.genericLabel!.font = UIFont.systemFont(ofSize: 12)
      cell.genericLabel!.textAlignment = .center
    case .talkDescription:
      setupLabel(cell.genericLabel!, with: stripHtml(from: talk!.abstract))
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

extension UINavigationItem {

  func setTitle(title:String, subtitle:String) {

    let one = UILabel()
    one.text = title
    one.lineBreakMode = .byWordWrapping
    one.numberOfLines = 2
    one.font = UIFont.systemFont(ofSize: 17)
    one.sizeToFit()

    let two = UILabel()
    two.text = subtitle
    two.lineBreakMode = .byTruncatingTail
    two.numberOfLines = 2
    two.font = UIFont.systemFont(ofSize: 12)
    two.textColor = UIColor.lightGray
    two.textAlignment = .center
    two.sizeToFit()

    let stackView = UIStackView(arrangedSubviews: [one, two])
    stackView.distribution = .equalCentering
    stackView.axis = .vertical

    let width = max(one.frame.size.width, two.frame.size.width)
    stackView.frame = CGRect(x: 0, y: 0, width: width, height: 55)

    //one.sizeToFit()
    //two.sizeToFit()

    self.titleView = stackView
  }
}
