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
        let scheduleUrl = URL(fileURLWithPath: SCHEDULE_PATH)
        print(scheduleUrl)
        let scheduleStream = InputStream(url: scheduleUrl)
        let scheduleParser = ScheduleParser(input:scheduleStream!)
        return scheduleParser.parse() 
    }
}
