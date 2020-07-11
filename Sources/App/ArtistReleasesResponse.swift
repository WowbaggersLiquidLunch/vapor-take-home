//
//  ArtistReleasesResponse.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Foundation

/// Discorgs's response structure to a search of all songs by an artist.
struct ArtistReleasesResponse: Decodable {
    struct Pagination: Decodable {
        struct URLs: Decodable {
            let last: URL
            let next: URL
        }
        
        let perPage: Int
        let pages: Int
        let page: Int
        let urls: URLs
        let items: Int
        
        enum CodingKeys: String, CodingKey {
            case perPage = "per_page"
            case pages
            case page
            case urls
            case items
        }
    }
    
    let pagination: Pagination
    /// The songs.
    let releases: [Song]
}
