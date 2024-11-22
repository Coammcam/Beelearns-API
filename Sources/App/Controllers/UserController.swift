//
//  UserController.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        usersRoute.put(use: updateUser)
        usersRoute.delete(use: deleteUser)
        
        usersRoute.group(":id"){ user in
            user.get(use: getUser)
            
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
    
    func updateUser(req: Request) async throws -> UserDTO {
        let updateData = try req.content.decode(UserDTO.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == updateData.email)
            .first() else {
            throw Abort(.notFound, reason: "User with email \(updateData.email) not found")
        }
        
        if !updateData.username.isEmpty {
            user.username = updateData.username
        }
        user.phone_number = updateData.phone_number ?? user.phone_number
        user.profile_image = updateData.profile_image ?? user.profile_image
        user.date_of_birth = updateData.date_of_birth ?? user.date_of_birth
        
        try await user.save(on: req.db)
        
        return UserDTO(
            email: user.email,
            username: user.username,
            phone_number: user.phone_number,
            date_of_birth: user.date_of_birth,
            profile_image: user.profile_image
        )
    }
    
    func deleteUser(req: Request) async throws -> String {
        let userInfor = try req.content.decode(UserDTO.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userInfor.email)
            .first() else {
            throw Abort(.notFound, reason: "User with email \(userInfor.email) not found")
        }
        
        try await user.delete(on: req.db)
        
        return "User with email \(userInfor.email) has been deleted successfully."
    }
    
    
}
