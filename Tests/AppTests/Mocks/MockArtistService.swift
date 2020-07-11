import Vapor
@testable import App

class MockArtistService: ArtistService, Service {
    
    /// Pre-defined artists to return.
    var artistsToReturn: Artists = .init()
    /// The record of searches performed.
    var searchedArtists: [String] = []
    
    /// Pre-defined songs to return.
    var songsToReturn: Songs = .init()
    /// The record of searches performed.
    var searchedSongsByArtistID: [(artistID: Int, songTitle: String)] = []
    
    func reset() {
        artistsToReturn = Artists()
        searchedArtists = []
        songsToReturn = Songs()
        searchedSongsByArtistID = []
    }

    // MARK: - ArtistService Conformance
    /// Returns pre-defined artists, regardless of the actual request.
    /// - Parameters:
    ///   - artist: The artist to look for.
    ///   - request: The request for looking for the given artist.
    /// - Returns: A future of the array of the pre-defined artists.
    func searchArtist(artist: String, on request: Request) throws -> EventLoopFuture<Artists> {
        searchedArtists.append(artist)
        return request.future(artistsToReturn)
    }
    
    /// Returns pre-defined songs, regardless of the actual request.
    /// - Parameters:
    ///   - title: The title by which to look for the songs.
    ///   - artistID: The ID of the artist associated with the songs.
    ///   - request: The request for looking for songs by the given song title and artist ID.
    /// - Returns: A future of the array of the pre-defined artists.
    func searchSongs(title: String, byArtistID artistID: Int, on request: Request) throws -> EventLoopFuture<Songs> {
        searchedSongsByArtistID.append((artistID: artistID, songTitle: title))
        return request.future(songsToReturn)
    }
    
}
