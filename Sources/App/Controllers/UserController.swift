import Vapor

/// Controls basic CRUD operations on `User` instances.
final class UserController {
    /// Saves a decoded `User` instance to the database.
    /// - Parameter request: The requet for adding a user.
    /// - Returns: A future of the user.
    func create(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap { user in
            return user.save(on: request)
        }
    }

    /// Returns a list of all users.
    /// - Parameter request: The request for fetching all users.
    /// - Returns: A future of an array of all users.
    func index(_ request: Request) throws -> Future<[User]> {
        return User.query(on: request).all()
    }

    /// Finds the user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to look for.
    /// - Returns: A future of the user.
    func find(_ request: Request) throws -> Future<User> {
        return try request.parameters.next(User.self).flatMap { user in
            return request.future(user)
        }
    }

    /// Updates a user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to update.
    /// - Returns: A future of the user.
    func update(_ request: Request) throws -> Future<User> {
        return try request.parameters.next(User.self).flatMap({ user -> EventLoopFuture<User> in
            return try request.content.decode(User.self).flatMap { updatedUser -> EventLoopFuture<User> in
                user.name = updatedUser.name
                return user.update(on: request)
            }
        })
    }

    /// Deletes a user specified in the given request's parameter.
    /// - Parameter request: The request that specifies which user to delete.
    /// - Returns: A furute of the HTTP status of this `DELETE` operation.
    func delete(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).flatMap { user in
            return user.delete(on: request)
        }.transform(to: .noContent)
    }
}
