//
//  Playlist.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor
import FluentPostgreSQL

final class Playlist: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var name: String
    var description: String
    var songIDs: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case songIDs = "songs"
    }
}

/// Allows `Playlist` to be encoded to and decoded from HTTP messages.
extension Playlist: Content { }

/// Allows `Playlist` to be used as a dynamic parameter in route definitions.
extension Playlist: Parameter { }
