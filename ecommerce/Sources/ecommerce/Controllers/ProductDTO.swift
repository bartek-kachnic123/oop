import Vapor

struct ProductDTO: Content {
    let id: UUID?
    let name: String
    let price: String
}

