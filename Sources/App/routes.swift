import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "Hello Universe" example
    router.get { req in
        return "Hello Universe"
    }
    
    // MARK: - Users Requests
    
    let userController = UserController()
    
    // /users
    // Create a new user.
    router.post("users", use: userController.create)
    
    // /users/{userID}
    // Find user by ID.
    router.get("users", User.parameter, use: userController.find)
    
    // Returns a list of all `User`s.
    router.get("users", use: userController.index)
    
    // /users/{userID}
    // Update user.
    router.put("users", User.parameter, use: userController.update)
    
    // /users/{userID}
    // delete a user
    router.delete("users", User.parameter, use: userController.delete)
    
    // MARK: - Artists Requests
    
    let artistController = ArtistController()
    
    // /artists/search
    // Search for an artist.
    router.get("artists", "search", use: artistController.searchArtist)
    
    // /artists/{artistID}/songs/search
    // Search for songs by artistID.
    router.get("artists", Int.parameter, "songs", "search", use: artistController.searchSongs)
    
    // MARK: - Playlists Requests
    
    let playlistController = PlaylistController()
    
    // POST /playlists
    // Create a new playlist.
    router.post("playlists", use: playlistController.create)
    
    // GET /playlists
    // List playlists.
    router.get("playlists", use: playlistController.index)
    
    // GET /playlists/{playlistID}
    // Find playlist by ID.
    router.get("playlists", Playlist.parameter, use: playlistController.find)
    
    // GET /playlists/{playlistID}
    // Update a playlist.
    router.put("playlists", Playlist.parameter, use: playlistController.update)
    
    // DELETE /playlists/{playlistID}
    // Delete a playlist.
    router.delete("playlists", Playlist.parameter, use: playlistController.delete)
    
    // POST /playlists/{playlistID}/songs/{songID}
    // Add song to playlist.
    router.post("playlists", Playlist.parameter, "songs", Int.parameter, use: playlistController.addSong)
    
    // /playlists/{playlistID}/songs/{songID}
    // Remove song from a playlist.
    router.delete("playlists", Playlist.parameter, "songs", Int.parameter, use: playlistController.removeSong)
    
}
