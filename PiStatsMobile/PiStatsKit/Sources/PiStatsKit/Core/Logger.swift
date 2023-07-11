//
//  Logger.swift
//  PiHoleStats
//
//  Created by Fernando Bunn on 21/06/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import os.log

public struct Logger {
    public init() { }
    
    public func osLog(category: String) -> OSLog {
        return OSLog(subsystem: "PiStats", category: category)
    }
    
    public func osLog<Subject>(describing instance: Subject) -> OSLog {
        return osLog(category: String(describing: instance))
    }
}
