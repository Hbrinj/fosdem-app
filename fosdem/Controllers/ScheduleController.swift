//
//  ScheduleController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 01/06/2019.
//  Copyright © 2019 Hbrinj. All rights reserved.
//

import UIKit
import RealmSwift

class ScheduleController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!
  private let talkObjects = try! Realm().objects(TalkObject.self)
  private var dataNotifToken: NotificationToken? = nil

  override func viewDidLoad() {
    setupDataNotification()

    //TODO: really should do MVVM with this
  }
  // Mark: - Setup
  private func setupDataNotification() {
    dataNotifToken = talkObjects.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.tableView else { return }
      switch changes {
      case .initial:
        // Results are now populated and can be accessed without blocking the UI
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        // Query results have changed, so apply them to the UITableView
        tableView.beginUpdates()
        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                             with: .automatic)
        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                             with: .automatic)
        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                             with: .automatic)
        tableView.endUpdates()
      case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
      }
    }
  }

  // Mark: - Data Source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return talkObjects.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
    cell.titleLabel.text = talkObjects[indexPath.row].title
    print("\(talkObjects[indexPath.row].title)")
    return cell
  }

  deinit {
    dataNotifToken?.invalidate()
  }
}
