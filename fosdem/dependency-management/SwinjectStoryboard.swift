//
//  SwinjectStoryboard.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 27/05/2019.
//  Copyright © 2019 Hbrinj. All rights reserved.
//

import Foundation

import SwinjectStoryboard

extension SwinjectStoryboard {
  @objc class func setup() {
    defaultContainer.register(DataReader.self) { _ in XMLDataReader() }

    defaultContainer.register(Array<Talk>.self, name: "Talks") { r in
      let reader = r.resolve(DataReader.self)!
      return reader.parseSchedule()
    }

    defaultContainer.register(Schedule.self) { r in
      return Schedule(reader: r.resolve(DataReader.self)!)
    }

    // Controllers
    defaultContainer.storyboardInitCompleted(TracksController.self) { r, c in
      c.schedule = r.resolve(Schedule.self)
    }
  }
}
