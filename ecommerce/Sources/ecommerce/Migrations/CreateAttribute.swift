import Fluent

struct CreateAttribute: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema("attributes")
            .id()
            .field("name", .string, .required)
            .field("category_id", .uuid, .required, .references("categories", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("attributes").delete()
    }
}

