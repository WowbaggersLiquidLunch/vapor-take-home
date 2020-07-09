import Vapor
import FluentPostgreSQL

// Allow `User` to be used as a dynamic migration.
extension User: Migration { }
