import Vapor
import Fluent

final class Product: Model, Content, @unchecked Sendable {
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "price")
    var price: Decimal

    init() {}

    init(id: UUID? = nil, name: String, price: Decimal) {
        self.id = id
        self.name = name
        self.price = price
    }
}

