import Vapor
import Fluent

final class Category: Model, Content, @unchecked Sendable {
    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Children(for: \.$category)
    var attributes: [Attribute]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

