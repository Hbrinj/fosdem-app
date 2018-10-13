//
//  XMLParser.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 17/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class ScheduleParser {
    func parse(xml: String) -> [Talk] {
        let xml = try! XML.parse(xml)
        
        let talks: [Talk] = xml["schedule", "day"]
            .flatMap({$0["room"]})
            .flatMap({$0["event"]})
            .map(createTalk)
        
        return talks
    }
    
    private func createTalk(_ event: XML.Accessor) -> Talk {
        return Talk(
            id: Int(event.attributes["id"]!)!,
            title: event["title"].text!,
            subTitle: event["subtitle"].text ?? "",
            startTime: event["start"].text ?? "",
            duration: event["duration"].text ?? "",
            type: event["type"].text ?? "",
            abstract: event["abstract"].text ?? "",
            track: event["track"].text ?? "",
            description: event["description"].text ?? "",
            people: [""],
            links: [""]
        )
    }
}
