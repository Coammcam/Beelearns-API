//
//  UserController.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        
        usersRoute.group(":id"){ user in
//            user.get(use: getUser)
            user.put(use: updateUser)
            user.delete(use: deleteUser)
        }
    }
    
    func getUser(req: Request) throws -> EventLoopFuture<UserDTO> {
        guard let userId = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .map { user in
                return user.toDTO()
            }
    }
    
    func updateUser(req: Request) throws -> EventLoopFuture<User> {
        guard let userId = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        let updateData = try req.content.decode(UserDTO.self)
        
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.username = updateData.username
                user.phone_number = updateData.phone_number
                user.profile_image = updateData.profile_image
                user.date_of_birth = updateData.date_of_birth
                return user.save(on: req.db).map { user }
            }
    }
    
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userId = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user in
                return user.delete(on: req.db)
            }
            .transform(to: .noContent)
    }


}
