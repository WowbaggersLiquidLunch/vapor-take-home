//
//  Playlist.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor
import FluentPostgreSQL

/// A playlist.
final class Playlist: PostgreSQLModel {
    
    typealias Database = PostgreSQLDatabase
    
    /// The playlist's ID, can be `nil` only before it's created in the database.
    var id: Int?
    
    /// The playlist's name.
    var name: String
    
    /// The playlist's description.
    var description: String
    
    /// The playlist's collection of songs.
    var songs: Songs
    
    /// Creates a playlist in memory.
    /// - Parameters:
    ///   - id: The playlist's ID, can be `nil` only before it's created in the database.
    ///   - name: The playlist's name.
    ///   - description: The playlist's description.
    ///   - songs: The playlist's collection of songs.
    init(id: Int? = nil, name: String, description: String, songs: Songs) {
        self.id = id
        self.name = name
        self.description = description
        self.songs = songs
    }
    
}

/// Allows `Playlist` to be encoded to and decoded from HTTP messages.
extension Playlist: Content { }

/// Allows `Playlist` to be used as a dynamic parameter in route definitions.
extension Playlist: Parameter { }
