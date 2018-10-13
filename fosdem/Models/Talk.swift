//
//  Talks.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 10/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation

struct Talk {
    let id: Int
    let title: String
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
