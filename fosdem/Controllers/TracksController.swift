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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: This should probably be in the dep factory somehow...
        schedule = Schedule()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.getTracks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        cell.textLabel?.text = schedule.getTracks()[indexPath.row]
        return cell
    }
    
}
