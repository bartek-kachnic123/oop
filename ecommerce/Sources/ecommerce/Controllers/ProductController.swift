import Vapor
import Fluent

struct ProductController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {

        let api = routes.grouped("api", "products")

        api.get(use: apiIndex)
        api.post(use: create)

        api.group(":productID") { product in
            product.get(use: show)
            product.put(use: update)
            product.delete(use: delete)
        }

        let ui = routes.grouped("products")

        ui.get(use: indexPage)
        ui.get("create", use: createPage)
        ui.post(use: createUI)

        ui.get(":productID", use: showPage)
        ui.get(":productID", "edit", use: editPage)
        ui.post(":productID", "edit", use: updateUI)
        ui.post(":productID", "delete", use: deleteUI)
    }

    func apiIndex(req: Request) throws -> EventLoopFuture<[Product]> {
        Product.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Product> {
        let product = try req.content.decode(Product.self)
        return product.save(on: req.db).map { product }
    }

    func show(req: Request) throws -> EventLoopFuture<Product> {
        Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func update(req: Request) throws -> EventLoopFuture<Product> {
        let input = try req.content.decode(Product.self)

        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = input.name
                product.price = input.price
                return product.save(on: req.db).map { product }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func indexPage(req: Request) throws -> EventLoopFuture<View> {
        Product.query(on: req.db).all()
            .flatMap { products in

                let dtos = products.map {
                    ProductDTO(
                        id: $0.id,
                        name: $0.name,
                        price: String(format: "%.2f", NSDecimalNumber(decimal: $0.price).doubleValue)
                    )
                }

                return req.view.render("products/index", ["products": dtos])
            }
    }

    func createPage(req: Request) throws -> EventLoopFuture<View> {
        req.view.render("products/create")
    }

    func showPage(req: Request) throws -> EventLoopFuture<View> {
        Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in

                let dto = ProductDTO(
                    id: product.id,
                    name: product.name,
                    price: String(format: "%.2f", NSDecimalNumber(decimal: product.price).doubleValue)
                )

                return req.view.render("products/show", ["product": dto])
            }
    }

    func editPage(req: Request) throws -> EventLoopFuture<View> {
        Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in

                let dto = ProductDTO(
                    id: product.id,
                    name: product.name,
                    price: String(format: "%.2f", NSDecimalNumber(decimal: product.price).doubleValue)
                )

                return req.view.render("products/edit", ["product": dto])
            }
    }

    func createUI(req: Request) throws -> EventLoopFuture<Response> {
        let dto = try req.content.decode(ProductDTO.self)

        guard let price = Decimal(string: dto.price) else {
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/products/create"))
        }

        let product = Product(name: dto.name, price: price)

        return product.save(on: req.db).map {
            req.redirect(to: "/products/\(product.id!)")
        }
    }

    func updateUI(req: Request) throws -> EventLoopFuture<Response> {
        let dto = try req.content.decode(ProductDTO.self)

        guard let price = Decimal(string: dto.price) else {
            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/products"))
        }

        return Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.name = dto.name
                product.price = price

                return product.save(on: req.db).map {
                    req.redirect(to: "/products/\(product.id!)")
                }
            }
    }

    func deleteUI(req: Request) throws -> EventLoopFuture<Response> {
        Product.find(req.parameters.get("productID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.delete(on: req.db).map {
                    req.redirect(to: "/products")
                }
            }
    }
}

