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
    router.get("artists", Int.parameter, "songs", "search", use: artistController.searchSongsByArtistID)
    
    
    
    // MARK: - Playlists Requests
}
