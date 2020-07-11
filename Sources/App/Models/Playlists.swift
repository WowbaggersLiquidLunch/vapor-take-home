//
//  Playlists.swift
//  App
//
//  Created by 冀卓疌 on 20-07-10.

import Vapor

/// The structure for returning playlists in a response, as defined by the API documentation.
struct Playlists: Codable {
    
    init(results: [Playlist] = []) {
        self.results = results
    }
    
    /// The playlists.
    let results: [Playlist]
    
}

// MARK: - Content Conformance

// Allows `Playlists` to be encoded to and decoded from HTTP messages.
extension Playlists: Content { }
