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
        return Array(Set(talks.map({$0.track})))
    }
    
    func getSectionedTracks() -> [Section<String>] {
        var dict = [Character:Section<String>]()
        var letter: Character
        var sections = [Section<String>]()
        
        for track in getTracks() {
            letter = track.uppercased().first!
            if(dict[letter] != nil) {
                dict[letter]?.objects.append(track)
            } else {
                dict[letter] = Section<String>(title: String(letter), objects: [track])
            }
        }
        

        for key in dict.keys {
            dict[key]?.objects.sort(by: {(s1, s2) -> Bool in return s1.uppercased() < s2.uppercased()})
        
        }
        sections = dict.compactMap({$1})
        return sections.sorted(by: {$0.title < $1.title})
    }
    
    func getDays() -> [String] {
        //TODO: implement
        return ["derp"]
    }
    
    func getTalksForParticularTopic(_ topic: String) -> [Talk] {
        return talks.filter({$0.track == topic}).sorted(by: {$0.title < $1.title})
    }
    
}
