import NIOSSL
import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    
    app.routes.defaultMaxBodySize = "10mb"
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.databases.use(DatabaseConfigurationFactory.mongo(
        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
    ), as: .mongo)

    app.migrations.add(CreateWord())
    app.migrations.add(CreateTrueFalseQuestion())
//    try await app.autoMigrate()

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
