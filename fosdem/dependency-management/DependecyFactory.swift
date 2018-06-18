//
//  Injection.swift
//  fosdem
//
//  Created by Houman Brinjcargorabi on 17/06/2018.
//  Copyright © 2018 Hbrinj. All rights reserved.
//

import Foundation

class DependencyFactory {
    // MARK: This is where the magic happens
    private var objects = [String: AnyObject]()
    private let DEFAULT_QUALIFIER: String = "none"
    private static var factoryInstance: DependencyFactory = {
        let factory = DependencyFactory()
        return factory
    }()
    
    private init() {
        register()
    }
    
    public static func getInstance() -> DependencyFactory {
        return factoryInstance
    }
    
    //TODO: make this more readable
    func insert(objectof type: Any, object: AnyObject) {
        let _type = String(describing: type)
        objects["\(_type)\(DEFAULT_QUALIFIER)"] = object as AnyObject
    }
    
    private func getInstanceOf<T>(object type: Any, with qualifier: String = "none") -> T {
        //TODO: Throw an exception if it isn't found
        let type = String(describing: type)
        let object = Optional.some(objects["\(type)\(qualifier)"])
        return object as! T
    }
    
    public static func getInstanceOf<T>(object type: Any, with qualifier: String = "none") -> T {
        return factoryInstance.getInstanceOf(object: type, with: qualifier)
    }
}
