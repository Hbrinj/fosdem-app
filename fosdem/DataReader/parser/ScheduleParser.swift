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
        
        let talks: [Talk] = xml["schedule"]
          .flatMap({$0["day"]})
          .flatMap(
            {(day: XML.Accessor) -> [[Talk]] in
              return day["room"].compactMap({
                (room: XML.Accessor) -> [Talk] in
                  return room["event"].compactMap(
                    {(event: XML.Accessor) -> Talk in
                      return createTalk(event, room: room.attributes["name"] ?? "", day: day.attributes["date"] ?? "")
                  })
              })
          }).flatMap {$0}
      
      return talks
    }
    
  private func createTalk(_ event: XML.Accessor, room: String, day: String) -> Talk {
      print(event.attributes)
        return Talk(
            id: Int(event.attributes["id"]!)!,
            title: event["title"].text ?? "",
            room: room,
            day: day,
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
