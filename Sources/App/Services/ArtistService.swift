import Vapor

/// A service for artist-related endpoints.
protocol ArtistService: Service {
    
    /// Searches for an artist as requested.
    /// - Parameters:
    ///   - artist: The name of the artist to look for.
    ///   - request: The request for searching for the artist.
    func searchArtist(artist: String, on request: Request) throws -> Future<Artists>
    
    /// Searches for songs ny the title and artist ID as requested.
    /// - Parameters:
    ///   - title: The song title.
    ///   - artistID: The artist ID.
    ///   - request: The request for searching for the songs.
    func searchSongs(title: String, byArtistID artistID: Int, on request: Request) throws -> Future<Songs>
    
}
