//
//  DependencyConfig.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 18/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation

extension DependencyFactory {
    @objc public func register() {
        
        // The reader
        self.insert(objectof: DataReader.self, object: XMLDataReader())
        
        // The talk data
        let reader: DataReader = XMLDataReader()
        self.insert(objectof: Array<Talk>.self , object: reader.parseSchedule() as AnyObject, with: "Talks")
    }
}
