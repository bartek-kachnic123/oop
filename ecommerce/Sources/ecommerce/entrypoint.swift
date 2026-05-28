import Vapor
import Fluent
import FluentSQLiteDriver
import Leaf

@main
enum Entrypoint {
    static func main() async throws {
        let env = try Environment.detect()
        let app = try await Application.make(env)

        do {
            app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
            app.migrations.add(CreateProduct())
            app.migrations.add(CreateAttribute())
            app.migrations.add(CreateCategory())
            try await app.autoMigrate()

            app.views.use(.leaf)
            try app.register(collection: ProductController())
            try app.register(collection: CategoryController())

            app.get { req in
                "Ecommerce API"
            }

            try await app.execute()
        } catch {
            try? await app.asyncShutdown()
            throw error
        }

        try await app.asyncShutdown()
    }
}

