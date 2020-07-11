//
//  Song.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor

struct Song: Equatable {
    
    let id: Int
    let title: String
    let labels: [String]?
    // `thumb` can be an `URL` type, which has automatic `Codable` conformance, but there is no need to interact with the URL, and `String` is safer, especially when the URLs are not guaranted to be fully percent-encoded.
    let thumb: String?
    
    fileprivate struct Label: Codable {
        let id: Int
        let name: String
    }
    
}

// MARK: - Codable Conformance

extension Song: Codable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(Int.self, forKey: .id)
        
        
        // `labels` require special treatment because sometimes Discorgs returns 1 label string per release, and sometimes it returns an array of `Label` object per release.
        // This is also why `Song` needs custom `Codable` conformance.
        if let label = try? values.decode(String.self, forKey: .label) {
            labels = [label]
        } else {
            // Need to try decoding from `[String]` because the `labels` is encoded to `[String]`.
            // `labels` is decoded from `[String]` in `testGetSongsByArtistID()`.
            labels = (try? values.decode([String].self, forKey: .labels))
                ?? (try? values.decode([Label].self, forKey: .labels).map { $0.name })
        }
        
        thumb = try? values.decode(String.self, forKey: .thumb)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(labels, forKey: .labels)
        try container.encodeIfPresent(thumb, forKey: .thumb)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case label
        case labels
        case thumb
    }
    
}

// MARK: - Content Conformance

// Allows `Song` to be encoded to and decoded from HTTP messages.
extension Song: Content { }
