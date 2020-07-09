import Foundation
import Vapor
@testable import App

class MockArtistService: ArtistService, Service {
    
    /// Predefined artists to return.
    var artistsToReturn: [Artist] = []
    /// The record of searches performed.
    var searchedArtists: [String] = []
    
    /// Predefined songs to return.
    var songsToReturn: [Song] = []
    /// The record of searches performed.
    var searchedSongsByArtistID: [(artistID: Int, songTitle: String)] = []
    
    func reset() {
        artistsToReturn = []
        searchedArtists = []
        songsToReturn = []
        searchedSongsByArtistID = []
    }

    // MARK: - ArtistService Conformance
    /// <#Description#>
    /// - Parameters:
    ///   - artist: <#artist description#>
    ///   - request: <#request description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func searchArtist(artist: String, on request: Request) throws -> EventLoopFuture<[Artist]> {
        searchedArtists.append(artist)
        return request.future(artistsToReturn)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - artistID: <#artistID description#>
    ///   - request: <#request description#>
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    func searchSongs(title: String, byArtistID artistID: Int, on request: Request) throws -> EventLoopFuture<[Song]> {
        searchedSongsByArtistID.append((artistID: artistID, songTitle: title))
        return request.future(songsToReturn)
    }
    
}
