//
//  PlaylistService.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor

/// A service for playlist-related endpoints.
protocol PlaylistService: Service {
    /// Retrieves the details of a song by its given ID.
    /// - Parameters:
    ///   - songID: The song's ID.
    ///   - request: The request for this search.
    func searchSong(byID songID: Int, on request: Request) throws -> Future<Song>
}
