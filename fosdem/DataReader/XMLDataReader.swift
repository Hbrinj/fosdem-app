//
//  XMLDataReader.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 10/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation

class XMLDataReader: DataReader {
    private let SCHEDULE_PATH = "."
    func parseSchedule() -> [Talk] {
        //TODO: should they just return empty?
        guard let path = Bundle.main.url(forResource: "2018", withExtension: "xml") else {
            print("Couldn't find the file")
            return []
        }
        do {
            let content = try String(contentsOf: path, encoding: .utf8)
            return ScheduleParser().parse(xml: content)
        } catch {
            print("Error:", error)
            return []
        }
    }
}
