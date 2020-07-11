//
//  MockPlaylistService.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor
@testable import App

class MockPlaylistService: PlaylistService, Service {
    
    /// The pre-defined song to return, regardless of the request.
    var songToReturn: Song?
    /// The record of searches performed.
    var searchedSongIDs: [Int] = []
    
    func reset() {
        songToReturn = nil
        searchedSongIDs = []
    }
    
    /// Returns the pre-defined song, regardless of the actual request.
    /// - Parameters:
    ///   - songID: The song's ID.
    ///   - request: The request for this search.
    /// - Returns: A future of the predefined song.
    func searchSong(byID songID: Int, on request: Request) throws -> Future<Song> {
        searchedSongIDs.append(songID)
        return request.future(songToReturn!)
    }
    
}
