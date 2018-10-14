//
//  TracksController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 09/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import UIKit

class TracksController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tracksTableView: UITableView!

  var schedule: Schedule!
  var sectionedTracks: [Section<String>]!
  var tracks: [String]!
  var searchResults = [String]()
  let searchController = UISearchController(searchResultsController: nil)


  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: This should probably be in the dep factory somehow...
    schedule = Schedule()
    sectionedTracks = schedule.getSectionedTracks()
    tracks = schedule.getTracks()

    // Setup
    setupSearchBar()
  }

  // MARK: - Setup
  private func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Tracks"
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.title = "Fosdem Tracks"
    definesPresentationContext = true

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TracksController.cancelSearch))
    tapGesture.cancelsTouchesInView = false
    tracksTableView.addGestureRecognizer(tapGesture)
  }

  // MARK: -TableView
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (searchBarIsEmpty() ? sectionedTracks[section].objects.count : searchResults.count)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
    cell.textLabel?.text =
      (searchBarIsEmpty() ? sectionedTracks[indexPath.section].objects[indexPath.row] : searchResults[indexPath.row])
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return (searchBarIsEmpty() ? sectionedTracks.count : 1)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return (searchBarIsEmpty() ? sectionedTracks[section].title : nil)
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return (searchBarIsEmpty() ? sectionedTracks.map({$0.title}) : [])
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cancelSearch()
  }

  // MARK: -Search Helpers
  private func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  private func search(for searchText: String) {
    searchResults = tracks.filter({
      (track) -> Bool in
      return track.uppercased().contains(searchText.uppercased())
    })

    tracksTableView.reloadData()
  }

  @objc func cancelSearch() {
    if searchBarIsEmpty() {
      searchController.dismiss(animated: true, completion: nil)
    }
    searchController.searchBar.endEditing(true)
  }
}

extension TracksController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    search(for: searchController.searchBar.text!)
  }
}
