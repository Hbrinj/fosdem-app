//
//  Schedule.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 02/10/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation

class Schedule {
    let talks: [Talk]
    
    init() {
        let reader: DataReader = DependencyFactory.getInstanceOf(object: DataReader.self)
        talks = reader.parseSchedule()
    }
    
    func getTracks() -> [String] {
        return Array(Set(talks.map({$0.track}))).sorted(by: {$0 < $1})
    }
    
    func getDays() -> [String] {
        //TODO: implement
        return ["derp"]
    }
    
    func getTalksForParticularTopic(_ topic: String) -> [Talk] {
        return talks.filter({$0.track == topic}).sorted(by: {$0.title < $1.title})
    }
    
}
