@testable import App
import FluentPostgreSQL
@testable import Vapor
import XCTest

class UserTests: XCTestCase {

    var app: Application!
    var connection: PostgreSQLConnection!
    var request: Request!

    override func setUp() {
        do {
            try Application.reset()
            self.app = try Application.testable()
            self.connection = try app.newConnection(to: .psql).wait()
        }
        catch {
            fatalError(error.localizedDescription)
        }

        self.request = Request(using: app)
    }

    override func tearDown() {
        self.connection?.close()
        try? app.syncShutdownGracefully()
    }

    func testCreateUser() throws {
        let newUser = User(name: "Tony")
        let user = try app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        XCTAssertNotNil(user.id)
        XCTAssertEqual(user.name, "Tony")
    }
    
    func testListUsers() throws {
        let newUser = User(name: "Doge")
        try app.sendRequest(to: "/users", method: .POST, body: newUser)
        
        let users = try app.getResponse(to: "/users", method: .GET, decodeTo: Users.self)
        let user = users.results.first
        
        XCTAssertNotNil(user)
        XCTAssertNotNil(user?.id)
        
        XCTAssertEqual(user?.name, "Doge")
    }

    func testGetUser() throws {
        let newUser = User(name: "Bruce")
        let userID = try app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self).requireID()

        let user = try app.getResponse(to: "/users/\(userID)", decodeTo: User.self)

        XCTAssertEqual(user.id, userID)
        XCTAssertEqual(user.name, "Bruce")
    }

    func testUpdateUser() throws {
        let newUser = User(name: "Peter")
        let user = try app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        XCTAssertNotNil(user.id)
        XCTAssertEqual(user.name, "Peter")

        user.name = "Carol"

        let userID = try user.requireID()
        let updatedUser = try app.getResponse(to: "/users/\(userID)", method: .PUT, data: user, decodeTo: User.self)

        XCTAssertEqual(updatedUser.id, userID)
        XCTAssertEqual(updatedUser.name, "Carol")
    }

    func testDeleteUser() throws {
        let newUser = User(name: "Thor")
        let user = try app.getResponse(to: "/users", method: .POST, data: newUser, decodeTo: User.self)

        let userID = try user.requireID()
        let retrievedUser = try app.getResponse(to: "/users/\(userID)", decodeTo: User.self)

        XCTAssertEqual(retrievedUser.id, userID)

        let deleteResponse = try app.sendRequest(to: "/users/\(userID)", method: .DELETE)
        XCTAssertEqual(deleteResponse.http.status, .noContent)

        let notFoundResponse = try app.sendRequest(to: "/users/\(userID)", method: .GET)
        XCTAssertEqual(notFoundResponse.http.status, .notFound)
    }
}
