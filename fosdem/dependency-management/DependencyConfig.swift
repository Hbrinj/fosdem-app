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
        self.insert(objectof: DataReader.self, object: XMLDataReader())
    }
}
