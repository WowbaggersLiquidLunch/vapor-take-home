//
//  Users.swift
//  App
//
//  Created by 冀卓疌 on 20-07-10.
//

import Vapor

/// The structure for returning users in a response, as defined by the API documentation.
struct Users: Codable {
    
    init(results: [User] = []) {
        self.results = results
    }
    
    /// The array of users.
    let results: [User]
    
}

// MARK: - Content Conformance

// Allows `Users` to be encoded to and decoded from HTTP messages.
extension Users: Content { }
