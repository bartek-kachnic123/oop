import Vapor
import Fluent

struct CategoryController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {

        let api = routes.grouped("api", "categories")

        api.get(use: apiIndex)
        api.post(use: apiCreate)

        api.group(":categoryID") { category in
            category.get(use: apiShow)
            category.put(use: apiUpdate)
            category.delete(use: apiDelete)
        }

        let ui = routes.grouped("categories")

        ui.get(use: indexPage)
        ui.get("create", use: createPage)
        ui.post(use: createUI)

        ui.get(":categoryID", use: showPage)
        ui.get(":categoryID", "edit", use: editPage)
        ui.post(":categoryID", "edit", use: updateUI)
        ui.post(":categoryID", "delete", use: deleteUI)
    }

    func apiIndex(req: Request) throws -> EventLoopFuture<[Category]> {
        Category.query(on: req.db)
            .with(\.$attributes)
            .all()
    }

    func apiCreate(req: Request) throws -> EventLoopFuture<Category> {
        let dto = try req.content.decode(CreateCategoryDTO.self)

        let category = Category(name: dto.name)

        return category.save(on: req.db).flatMap {
            let attributes = dto.attributes
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                .map { Attribute(name: $0, categoryID: category.id!) }

            return attributes.create(on: req.db).map {
                category
            }
        }
    }

    func apiShow(req: Request) throws -> EventLoopFuture<Category> {
        let id = try uuid(req)

        return Category.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$attributes)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func apiUpdate(req: Request) throws -> EventLoopFuture<Category> {
        let id = try uuid(req)
        let dto = try req.content.decode(CreateCategoryDTO.self)

        return Category.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = dto.name
                return category.save(on: req.db).map { category }
            }
    }

    func apiDelete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let id = try uuid(req)

        return Category.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func indexPage(req: Request) throws -> EventLoopFuture<View> {
        Category.query(on: req.db).all()
            .flatMap { categories in
                req.view.render("categories/index", ["categories": categories])
            }
    }

    func createPage(req: Request) throws -> EventLoopFuture<View> {
        req.view.render("categories/create")
    }

    func createUI(req: Request) throws -> EventLoopFuture<Response> {
        let dto = try req.content.decode(CreateCategoryDTO.self)

        let category = Category(name: dto.name)

        return category.save(on: req.db).flatMap {
            let attributes = dto.attributes
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                .map { Attribute(name: $0, categoryID: category.id!) }

            return attributes.create(on: req.db).map {
                req.redirect(to: "/categories/\(category.id!)")
            }
        }
    }

    func showPage(req: Request) throws -> EventLoopFuture<View> {
        let id = try uuid(req)

        return Category.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$attributes)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                req.view.render("categories/show", ["category": category])
            }
    }

    func editPage(req: Request) throws -> EventLoopFuture<View> {
        let id = try uuid(req)

        return Category.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$attributes)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                req.view.render("categories/edit", ["category": category])
            }
    }

    func updateUI(req: Request) throws -> EventLoopFuture<Response> {
        let id = try uuid(req)
        let dto = try req.content.decode(CreateCategoryDTO.self)

        return Category.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.name = dto.name
                return category.save(on: req.db).map {
                    req.redirect(to: "/categories/\(category.id!)")
                }
            }
    }

    func deleteUI(req: Request) throws -> EventLoopFuture<Response> {
        let id = try uuid(req)

        return Category.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map {
                req.redirect(to: "/categories")
            }
    }

    private func uuid(_ req: Request) throws -> UUID {
        guard let string = req.parameters.get("categoryID"),
              let uuid = UUID(uuidString: string) else {
            throw Abort(.badRequest)
        }
        return uuid
    }
}

