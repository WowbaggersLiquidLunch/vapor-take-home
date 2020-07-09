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
    /// - Returns: A future of an array of `Artist` instances.
    func searchArtist(artist: String, on request: Request) throws -> Future<[Artist]> {
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
                request.future(artistSearch.results)
            }
        }
    }
    
    /// Searches for songs ny the title and artist ID as requested.
    /// - Parameters:
    ///   - title: The song title.
    ///   - artistID: The artist ID.
    ///   - request: The request for searching for the songs.
    /// - Returns: A future of an array of all matching songs.
    func searchSongs(title: String, byArtistID artistID: Int, on request: Request) throws -> Future<[Song]> {
        let artistReleasesURLRelativePath = "artists/\(artistID)/releases"

        let artistReleasesURL = discogsAPIBaseURL.appendingPathComponent(artistReleasesURLRelativePath)
        
        return try request.client().get(artistReleasesURL, headers: headers).flatMap { response in
            try response.content.decode(ArtistReleasesResponse.self).flatMap { artistReleases in
                request.future(artistReleases.releases.filter { $0.title == title })
            }
        }
    }
    
}
