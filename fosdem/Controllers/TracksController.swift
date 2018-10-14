//
//  TracksController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 09/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import UIKit

class TracksController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var schedule: Schedule!
    var sectionedTracks: [Section<String>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: This should probably be in the dep factory somehow...
        schedule = Schedule()
        sectionedTracks = schedule.getSectionedTracks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedTracks[section].objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        cell.textLabel?.text = sectionedTracks[indexPath.section].objects[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedTracks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionedTracks[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionedTracks.map({$0.title})
    }
}
