import Vapor

/// A controller for artist-related endpoint logics.
final class ArtistController {
    
    /// Searches for an artist as requested.
    /// - Parameter request: The request to search the artist.
    /// - Returns: A future of an array of `Artist` instances.
    func searchArtist(_ request: Request) throws -> Future<[Artist]> {
        let artistString = try request.query.get(String.self, at: "q")
        let service = try request.make(ArtistService.self)
        return try service.searchArtist(artist: artistString, on: request)
    }
    
    /// Searches for songs by title and artist ID as specified in the given request.
    /// - Parameter request: The given request that specifies the song title and the artist's ID.
    /// - Returns: A future of an array of songs.
    func searchSongsByArtistID(_ request: Request) throws -> Future<[Song]> {
        let artistID = try request.parameters.next(Int.self)
        let songTitle = try request.query.get(String.self, at: "q")
        let service = try request.make(ArtistService.self)
        return try service.searchSongs(title: songTitle, byArtistID: artistID, on: request)
    }
    
}
