//
//  TracksController.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 09/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import UIKit

class TracksController: UIViewController {
    private var _reader: DataReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        _reader = DependencyFactory.getInstanceOf(object: DataReader.self)
        let x:[Talk] = _reader.parseSchedule()
        for z in x {
            print(z)
        }
        //_reader = DependencyFactory.getInstance().getInstanceOf<DataReader>()
        //_reader!.parseSchedule()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

