//
//  UserController.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        usersRoute.put(use: updateUser)
        usersRoute.delete(use: deleteUser)
        
//        usersRoute.group(":id"){ user in
//            user.get(use: getUser)
//        }
        
        usersRoute.group("data", ":email"){ usersRoute in
            usersRoute.get(use: getUserData)
            usersRoute.put(use: updateUserData)
        }
    }
    
//    func getUser(req: Request) throws -> EventLoopFuture<UserDTO> {
//        guard let userId = req.parameters.get("id", as: ObjectId.self) else {
//            throw Abort(.badRequest, reason: "Invalid user ID")
//        }
//
//        return User.find(userId, on: req.db)
//            .unwrap(or: Abort(.notFound, reason: "User not found"))
//            .map { user in
//                return user.toDTO()
//            }
//    }
//
    func getUserData(req: Request) async throws -> UserStudyDataDTO{
        guard let userEmail = req.parameters.get("email") else {
            throw Abort(.badRequest)
        }
        
        guard let userStudyData = try await UserStudyData.query(on: req.db)
            .filter(\.$userEmail == userEmail)
            .first() else {
            throw Abort(.notFound, reason: "User study data not found")
        }
        
        return userStudyData.toDTO()
    }
    
    func updateUserData(req: Request) async throws -> UserStudyDataDTO{
        guard let userEmail = req.parameters.get("email") else {
            throw Abort(.badRequest)
        }
        
        let newStudyData: UserStudyDataDTO = try req.content.decode(UserStudyDataDTO.self)
                
        guard let userStudyData = try await UserStudyData.query(on: req.db)
            .filter(\.$userEmail == userEmail)
            .first() else {
            throw Abort(.notFound, reason: "User study data not found")
        }
        
//        userStudyData.honeyJar = newStudyData.honeyJar
//        userStudyData.score = newStudyData.score
//        userStudyData.heart = newStudyData.honeyComb
//        userStudyData.level = newStudyData.level
//        userStudyData.part = newStudyData.part
//        userStudyData.exp = newStudyData.exp
        
        if userStudyData.honeyJar != newStudyData.honeyJar {
                userStudyData.honeyJar = newStudyData.honeyJar
            }
        if userStudyData.score != newStudyData.score {
            userStudyData.score = newStudyData.score
        }
        if userStudyData.heart != newStudyData.honeyComb {
            userStudyData.heart = newStudyData.honeyComb
        }
        if userStudyData.level != newStudyData.level {
            userStudyData.level = newStudyData.level
        }
        if userStudyData.part != newStudyData.part {
            userStudyData.part = newStudyData.part
        }
        if userStudyData.exp != newStudyData.exp {
            userStudyData.exp = newStudyData.exp
        }
        
        try await userStudyData.save(on: req.db)
        
        return userStudyData.toDTO()
    }
    
    func updateUser(req: Request) async throws -> UserDTO {
        let updateData = try req.content.decode(UserDTO.self)
        
        let app: Application = req.application
        struct InputFile: Content{
            var file: File
        }
        
        let inputFile: InputFile? = try? req.content.decode(InputFile.self)
        
        var filePath: String? = nil
        if let inputFile = inputFile {
            let filename = inputFile.file.filename
            let path = app.directory.publicDirectory + filename
            filePath = filename
            
            if (!FileManager.default.fileExists(atPath: path)){
                try await app.fileio.openFile(path: path, mode: .write, flags: .allowFileCreation(posixMode: 0x744), eventLoop: req.eventLoop)
                    .tryFlatMap{handle in
                        req.application.fileio.write(fileHandle: handle, buffer: inputFile.file.data, eventLoop: req.eventLoop)
                            .flatMapThrowing{ _ in
                                try handle.close()
                            }
                    }
                    .get()
            }
        }
        
        
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == updateData.email)
            .first() else {
            throw Abort(.notFound, reason: "User with email \(updateData.email) not found")
        }
        
        if !updateData.username.isEmpty {
            user.username = updateData.username
        }
        user.phone_number = updateData.phoneNumber ?? user.phone_number
        
        if let filePath = filePath {
            user.profile_image = Environment.get("IP")! + filePath
        }
        user.date_of_birth = updateData.dateOfBirth ?? user.date_of_birth
        
        try await user.save(on: req.db)
        
        return UserDTO(
            email: user.email,
            username: user.username,
            phoneNumber: user.phone_number,
            dateOfBirth: user.date_of_birth,
            profileImageUrl: user.profile_image
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
