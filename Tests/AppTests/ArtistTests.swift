@testable import App
import FluentPostgreSQL
@testable import Vapor
import XCTest

class ArtistTests: XCTestCase {

    var app: Application!
    var connection: PostgreSQLConnection!
    var request: Request!
    var mockArtistService: MockArtistService!

    override func setUp() {
        do {
            try Application.reset()
            app = try Application.testable()
            connection = try self.app.newConnection(to: .psql).wait()
        }
        catch {
            fatalError(error.localizedDescription)
        }

        request = Request(using: self.app)
        mockArtistService = try! request.make(MockArtistService.self)
        mockArtistService.reset()
    }

    override func tearDown() {
        connection?.close()
        try? app.syncShutdownGracefully()
    }

    func testGetArtists() throws {
        let mockArtists = Artists(
            results:  [
                Artist(id: 1, title: "Artist1", thumb: nil, coverImage: nil),
                Artist(id: 2, title: "Artist2", thumb: nil, coverImage: nil)
            ]
        )

        mockArtistService.artistsToReturn = mockArtists

        let search = "rickastley"

        let returnedArtists = try self.app.getResponse(
            to: "/artists/search?q=\(search)",
            method: .GET,
            decodeTo: Artists.self
        )
        
        XCTAssertEqual(mockArtists, returnedArtists)
    }
    
    func testGetSongsByArtistID() throws {
        let mockSongs = Songs(
            results: [
                Song(id: 3, title: "Eric the Half-a-Bee", labels: ["Charisma Records"], thumb: nil),
                Song(id: 5, title: "Eric the Half-a-Bee", labels: ["Columbia Records"], thumb: nil),
            ]
        )
        
        mockArtistService.songsToReturn = mockSongs
        
        let artistIDToSearch = 1337
        let songTitleToSearch = "Never Gonna Give You Up".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let returnedSongs = try self.app.getResponse(
            to:"/artists/\(artistIDToSearch)/songs/search?q=\(songTitleToSearch)",
            method: .GET,
            decodeTo: Songs.self
        )
        
        XCTAssertEqual(mockSongs, returnedSongs)
    }
}
