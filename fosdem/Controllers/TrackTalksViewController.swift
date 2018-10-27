//
//  TrackTalksViewController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 14/10/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import UIKit

class TrackTalksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var trackTalksTableView: UITableView!

  var talks = [Talk]()
  var viewTitle: String? {
    didSet {
      navigationItem.title = viewTitle
    }
  }
  var searchResults = [Talk]()
  let searchController = UISearchController(searchResultsController: nil)
  let SHOW_TALK_SEGUE = "talkSegue"

  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigation()
    setupSearchBar()
  }

  private func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Talks"

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TrackTalksViewController.cancelSearch))
    tapGesture.cancelsTouchesInView = false
    trackTalksTableView.addGestureRecognizer(tapGesture)
  }

  private func setupNavigation() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (searchBarIsEmpty() ? talks.count : searchResults.count)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTalksCell", for: indexPath) as! TrackTalkCell
    let talk = (searchBarIsEmpty() ? talks[indexPath.row] : searchResults[indexPath.row])
    cell.titleLabel?.text = talk.title
    cell.subtitleLabel?.text = talk.subTitle
    return cell
  }

  // MARK: -Search Helpers
  private func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  private func search(for searchText: String) {
    searchResults = talks.filter({
      (talk) -> Bool in
      return talk.title.uppercased().contains(searchText.uppercased())
    })
    trackTalksTableView.reloadData()
  }

  @objc func cancelSearch() {
    if searchBarIsEmpty() {
      searchController.dismiss(animated: true, completion: nil)
    }
    searchController.searchBar.endEditing(true)
  }
  // MARK: -Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case SHOW_TALK_SEGUE:
      setupTalk(for: segue)
      break
    default:
      return
    }
  }

  private func setupTalk(for segue: UIStoryboardSegue) {
    if let indexPath = trackTalksTableView.indexPathForSelectedRow {
      let talk = (searchBarIsEmpty() ? talks[indexPath.row] : searchResults[indexPath.row])
      let controller = segue.destination as! TalkViewController
      controller.talk = talk
    }
  }
}

extension TrackTalksViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    search(for: searchController.searchBar.text!)
  }
}
