//
//  ScannedPihole.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/08/2020.
//

import Foundation

struct ScannedPihole: Codable {
    let host: String
    let port: Int
    let token: String?
    let secure: Bool?
}
