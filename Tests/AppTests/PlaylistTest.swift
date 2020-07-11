//
//  PlaylistTest.swift
//  AppTests
//
//  Created by 冀卓疌 on 20-07-10.
//

@testable import App
import FluentPostgreSQL
@testable import Vapor
import XCTest

class PlaylistTest: XCTestCase {
    var app: Application!
    var connection: PostgreSQLConnection!
    var request: Request!
    var mockPlaylistService: MockPlaylistService!
    var newPlaylist: Playlist!
    
    override func setUp() {
        do {
            try Application.reset()
            app = try Application.testable()
            connection = try app.newConnection(to: .psql).wait()
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        request = Request(using: app)
        mockPlaylistService = try! request.make(MockPlaylistService.self)
        mockPlaylistService.reset()
        
        newPlaylist = Playlist(
            id: nil,
            name: "Testing... testing...",
            description: "A playlist for testing.",
            songs: Songs(
                results:[
                    Song(
                        id: Int.random(in: Int.min...Int.max),
                        title: "Test Song",
                        labels: ["Test Label"],
                        thumb: nil
                    ),
                    Song(
                        id: Int.random(in: Int.min...Int.max),
                        title: "Test Song 2: Electric Boogloo",
                        labels: [
                            "Mechanic Boogloo",
                            "Meta-Physical Boogloo"
                        ],
                        thumb: "https://i.kym-cdn.com/photos/images/original/000/516/642/25f.jpg"
                    )
                ]
            )
        )
    }
    
    override func tearDown() {
        connection?.close()
        try? app.syncShutdownGracefully()
    }
    
    func testCreatePlaylist() throws {
        let playlist = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self)
        
        XCTAssertNotNil(playlist.id )
        
        XCTAssertEqual(playlist.name, newPlaylist.name)
        XCTAssertEqual(playlist.description, newPlaylist.description)
        XCTAssertEqual(playlist.songs, newPlaylist.songs)
    }
    
    func testListPlaylists() throws {
        try app.sendRequest(to: "/playlists", method: .POST, body: newPlaylist)
        
        let playlists = try app.getResponse(to: "/playlists", method: .GET, decodeTo: Playlists.self)
        let playlist = playlists.results.first
        
        XCTAssertNotNil(playlist)
        XCTAssertNotNil(playlist?.id)
        
        XCTAssertEqual(playlist?.name, newPlaylist.name)
        XCTAssertEqual(playlist?.description, newPlaylist.description)
        XCTAssertEqual(playlist?.songs, newPlaylist.songs)
    }
    
    func testGetPlaylist() throws {
        let playlistID = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self).requireID()
        
        let playlist = try app.getResponse(to: "/playlists/\(playlistID)", decodeTo: Playlist.self)
        
        XCTAssertEqual(playlist.id, playlistID)
        XCTAssertEqual(playlist.name, newPlaylist.name)
        XCTAssertEqual(playlist.description, newPlaylist.description)
        XCTAssertEqual(playlist.songs, newPlaylist.songs)
    }
    
    func testUpdatePlaylist() throws {
        let playlist = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self)
        
        playlist.name = "Good Music"
        
        let playlistID = try playlist.requireID()
        let updatedPlaylist = try app.getResponse(to: "/playlists/\(playlistID)", method: .PUT, data: playlist, decodeTo: Playlist.self)
        
        XCTAssertEqual(updatedPlaylist.id, playlistID)
        XCTAssertEqual(updatedPlaylist.name, "Good Music")
        XCTAssertEqual(updatedPlaylist.description, playlist.description)
        XCTAssertEqual(updatedPlaylist.songs, playlist.songs)
    }
    
    func testDeletePlaylist() throws {
        let playlistID = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self).requireID()
        
        let deleteResponse = try app.sendRequest(to: "/playlists/\(playlistID)", method: .DELETE)
        XCTAssertEqual(deleteResponse.http.status, .noContent)
        
        let notFoundResponse = try app.sendRequest(to: "/playlists/\(playlistID)", method: .GET)
        XCTAssertEqual(notFoundResponse.http.status, .notFound)
    }
    
    func testAddSongToPlaylist() throws {
        let playlist = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self)
        let playlistID = try playlist.requireID()
        
        let mockSong = Song(
            id: 42,
            title: "Journey of the Sorcerer",
            labels: ["Asylum Records"],
            thumb: "https://upload.wikimedia.org/wikipedia/en/3/30/The_Eagles_-_One_of_These_Nights.jpg"
        )
        
        mockPlaylistService.songToReturn = mockSong
        
        let playlistWithNewSong = try app.getResponse(
            to:"/playlists/\(playlistID)/songs/\(mockSong.id)",
            method: .POST,
            decodeTo: Playlist.self
        )
        XCTAssertEqual(playlistWithNewSong.songs.count, playlist.songs.count + 1)
        
        playlist.songs.append(mockSong)
        XCTAssertEqual(playlistWithNewSong.songs, playlist.songs)
    }
    
    func testRemoveSongFromPlaylist() throws {
        let playlist = try app.getResponse(to: "/playlists", method: .POST, data: newPlaylist, decodeTo: Playlist.self)
        let playlistID = try playlist.requireID()
        
        let songToRemove = playlist.songs.first
        XCTAssertNotNil(songToRemove)
        
        let deleteResponse = try app.sendRequest(
            to:"/playlists/\(playlistID)/songs/\(songToRemove!.id)",
            method: .DELETE
        )
        XCTAssertEqual(deleteResponse.http.status, .noContent)
        
        let playlistWithSongRemoved = try app.getResponse(
            to: "/playlists/\(playlistID)",
            method: .GET,
            decodeTo: Playlist.self
        )
        XCTAssertEqual(playlistWithSongRemoved.songs.count, playlist.songs.count - 1)
        XCTAssertTrue(
            playlistWithSongRemoved.songs.allSatisfy { $0.id != songToRemove?.id }
        )
    }
}
