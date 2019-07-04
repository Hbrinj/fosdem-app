//
//  Talks.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 10/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation
import RealmSwift

struct Talk {
  let id: Int
  let title: String
  let room: String
  let day: String
  let subTitle: String?
  let startTime: String
  let duration: String
  let type: String
  let abstract: String
  let track: String
  let description: String
  let people: [String]
  let links: [String]
}

class TalkObject: Object {

  func create(from talk: Talk) {
    self.id = talk.id
    self.title = talk.title
    self.room = talk.room
    self.day = talk.day
    self.subTitle = talk.subTitle
    self.startTime = talk.startTime
    self.duration = talk.duration
    self.type = talk.type
    self.abstract = talk.abstract
    self.track = talk.track
    self.desc = talk.description

    for person in talk.people {
      self.people.append(person)
    }

    for link in talk.links {
      self.links.append(link)
    }
  }

  func convertTo() -> Talk {
    var peopleArray: [String] = []
    var linksArray: [String] = []

    for person in self.people {
      peopleArray.append(person)
    }

    for link in self.links {
      linksArray.append(link)
    }

    return Talk(id: self.id,
                title: self.title,
                room: self.room,
                day: self.day,
                subTitle: self.subTitle,
                startTime: self.startTime,
                duration: self.duration,
                type: self.type,
                abstract: self.abstract,
                track: self.track,
                description: self.desc,
                people: peopleArray,
                links: linksArray)
  }

  static func convert(from talk: Talk) -> TalkObject {
    let object = TalkObject()
    object.create(from: talk)
    return object
  }

  override static func primaryKey() -> String? {
    return "id"
  }

  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var room: String = ""
  @objc dynamic var day: String = ""
  @objc dynamic var subTitle: String? = ""
  @objc dynamic var startTime: String = ""
  @objc dynamic var duration: String = ""
  @objc dynamic var type: String = ""
  @objc dynamic var abstract: String = ""
  @objc dynamic var track: String = ""
  @objc dynamic var desc: String = ""
  let people = List<String>()
  let links = List<String>()
}
