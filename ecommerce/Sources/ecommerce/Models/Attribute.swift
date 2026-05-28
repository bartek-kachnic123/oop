import Vapor
import Fluent

final class Attribute: Model, Content, @unchecked Sendable {
    static let schema = "attributes"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Parent(key: "category_id")
    var category: Category

    init() {}

    init(id: UUID? = nil, name: String, categoryID: UUID) {
        self.id = id
        self.name = name
        self.$category.id = categoryID
    }
}

