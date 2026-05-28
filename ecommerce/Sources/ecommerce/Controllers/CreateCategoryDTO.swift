import Vapor

struct CreateCategoryDTO: Content {
    let name: String
    let attributes: [String]
}

