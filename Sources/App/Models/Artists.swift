//
//  Artists.swift
//  App
//
//  Created by 冀卓疌 on 20-07-10.
//

import Vapor

/// The structure for returning artists in a response, as defined by the API documentation.
struct Artists: Equatable, Codable {
    
    init(results: [Artist] = []) {
        self.results = results
    }
    
    /// The array of artists.
    private let results: [Artist]
    
}

// MARK: - Content Conformance

// Allows `Artists` to be encoded to and decoded from HTTP messages.
extension Artists: Content { }
