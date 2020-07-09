//
//  Song.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor

struct Song: Codable {
    let id: Int
    let title: String
    let label: String
    let thumb: String?
}

// MARK: - Content Conformance
// Allows `Song` to be encoded to and decoded from HTTP messages.
extension Song: Content { }
