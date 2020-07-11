//
//  PlaylistController.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor

/// A controller for playlist-related endpoints.
final class PlaylistController {
    
    // MARK: - Basic CRUD Operations
    
    /// Saves a playlist as requested into the database.
    /// - Parameter request: The request for adding a playlist.
    /// - Returns: A future of the newly saved playlist.
    func create(_ request: Request) throws -> Future<Playlist> {
        try request.content.decode(Playlist.self).flatMap { playlist in
            playlist.save(on: request)
        }
    }
    
    /// Lists all playlist per request.
    /// - Parameter request: The request for listing all playlists.
    /// - Returns: A future instance of a `Playlists` containing all playlists in the database.
    func index(_ request: Request) throws -> Future<Playlists> {
        Playlist.query(on: request).all().map { playlists in
            Playlists(results: playlists)
        }
    }
    
    /// Finds a playlist by its ID as specified in the request.
    /// - Parameter request: The request for finding a playlist by its ID.
    /// - Returns: A future of the playlist.
    func find(_ request: Request) throws -> Future<Playlist> {
        try request.parameters.next(Playlist.self).flatMap { playlist in
            request.future(playlist)
        }
    }
    
    /// Updates a playlist with a new one provided by the request.
    /// - Parameter request: The request that provides the new playlist.
    /// - Returns: A future of the updated playlist.
    func update(_ request: Request) throws -> Future<Playlist> {
        try request.parameters.next(Playlist.self).flatMap { playlist in
            try request.content.decode(Playlist.self).flatMap { updatedPlaylist in
                playlist.name = updatedPlaylist.name
                playlist.description = updatedPlaylist.description
                playlist.songs = updatedPlaylist.songs
                return playlist.update(on: request)
            }
        }
    }
    
    /// Deletes a playlist by its ID as specified in the request.
    /// - Parameter request: The request for deleting a playlist by its ID
    /// - Returns: A future of the HTTP status of this `DELETE` operation.
    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        try request.parameters.next(Playlist.self).flatMap { playlist in
            playlist.delete(on: request)
        }.transform(to: .noContent)
    }
    
    // MARK: - Playlist Content Management
    
    /// Adds the song by its request-specified ID to the playlist by its request-specified ID.
    /// - Parameter request: The request that specifies the song ID and the playlist ID.
    /// - Returns: A future of the playlist with the song added in.
    func addSong(_ request: Request) throws -> Future<Playlist> {
        try request.parameters.next(Playlist.self).flatMap { playlist in
            let songID = try request.parameters.next(Int.self)
            let service = try request.make(PlaylistService.self)
            return try service.searchSong(byID: songID, on: request).flatMap { song in
                playlist.songs.append(song)
                return playlist.update(on: request)
            }
        }
    }
    
    /// Removes the song by its request-specified ID to the playlist by its request-specified ID.
    /// - Parameter request: The request that specifies the song ID and the playlist ID.
    /// - Returns: A future of the playlist with the song removed.
    func removeSong(_ request: Request) throws -> Future<HTTPStatus> {
        try request.parameters.next(Playlist.self).flatMap { playlist in
            let songID = try request.parameters.next(Int.self)
            playlist.songs.removeAll(where: { $0.id == songID } )
            return playlist.update(on: request).transform(to: .noContent)
        }
    }
    
    // MARK: -
    
}
