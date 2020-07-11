import Vapor

struct DiscogService: ArtistService {
    
    /// The shared component among Discogs APIs.
    private let discogsAPIBaseURL = URL(string: "https://api.discogs.com")!
    
    /// The HTTP headers that include the required Discorgs API token.
    private let headers: HTTPHeaders = [
        "Authorization": "Discogs token=\(Environment.apiToken)"
    ]
    
    /// Searches for an artist as requested.
    /// - Parameters:
    ///   - artist: The name of the artist to look for.
    ///   - request: The request for searching for the artist.
    /// - Returns: A future instance `Artists`.
    func searchArtist(artist: String, on request: Request) throws -> Future<Artists> {
        let searchURLRelativePath = "database/search"
        
        var searchURLComponents = URLComponents(
            url: discogsAPIBaseURL.appendingPathComponent(searchURLRelativePath),
            resolvingAgainstBaseURL: true
        )
        searchURLComponents?.queryItems = [URLQueryItem(name: "q", value: artist)]

        guard let url = searchURLComponents?.url else {
            fatalError("Couldn't create search URL")
        }
        
        return try request.client().get(url, headers: headers).flatMap { response in
            try response.content.decode(ArtistSearchResponse.self).flatMap { artistSearch in
                request.future(
                    Artists(results: artistSearch.results)
                )
            }
        }
    }
    
    /// Searches for songs ny the title and artist ID as requested.
    /// - Parameters:
    ///   - title: The song title.
    ///   - artistID: The artist ID.
    ///   - request: The request for searching for the songs.
    /// - Returns: A future instance of `Songs` containing all matching songs.
    func searchSongs(title: String, byArtistID artistID: Int, on request: Request) throws -> Future<Songs> {
        let artistReleasesURLRelativePath = "artists/\(artistID)/releases"
        let artistReleasesURL = discogsAPIBaseURL.appendingPathComponent(artistReleasesURLRelativePath)
        
        return try request.client().get(artistReleasesURL, headers: headers).flatMap { response in
            try response.content.decode(ArtistReleasesResponse.self).flatMap { artistReleases in
                request.future(
                    Songs(results: artistReleases.releases.filter { $0.title == title } )
                )
            }
        }
    }
    
}
