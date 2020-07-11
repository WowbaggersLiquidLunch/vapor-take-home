import Vapor

/// Controls basic CRUD operations on `User` instances.
final class UserController {
    /// Saves a decoded `User` instance to the database.
    /// - Parameter request: The requet for adding a user.
    /// - Returns: A future of the user.
    func create(_ request: Request) throws -> Future<User> {
        try request.content.decode(User.self).flatMap { user in
            user.save(on: request)
        }
    }

    /// Returns a list of all users.
    /// - Parameter request: The request for fetching all users.
    /// - Returns: A future instance of a `Users` containing all users.
    func index(_ request: Request) throws -> Future<Users> {
        User.query(on: request).all().map { users in
            Users(results: users)
        }
    }

    /// Finds the user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to look for.
    /// - Returns: A future of the user.
    func find(_ request: Request) throws -> Future<User> {
        try request.parameters.next(User.self).flatMap { user in
            request.future(user)
        }
    }

    /// Updates a user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to update.
    /// - Returns: A future of the user.
    func update(_ request: Request) throws -> Future<User> {
        try request.parameters.next(User.self).flatMap { user in
            try request.content.decode(User.self).flatMap { updatedUser in
                user.name = updatedUser.name
                return user.update(on: request)
            }
        }
    }

    /// Deletes a user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to delete.
    /// - Returns: A furute of the HTTP status of this `DELETE` operation.
    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        try request.parameters.next(User.self).flatMap { user in
            user.delete(on: request)
        }.transform(to: .noContent)
    }
}
