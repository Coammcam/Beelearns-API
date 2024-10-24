//
//  TestModelController.swift
//  
//
//  Created by Hoang McDuck on 23/10/2024.
//

import Fluent
import Vapor

struct TestModelController: RouteCollection{
    
    let app: Application
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let testModels = routes.grouped("testmodels")
        testModels.get(use: index)
//        testModels.post(use: createTestModelFromXLSX)
    }

    @Sendable
    func index(req: Request) async throws -> [TestModel]{
        return try await TestModel.query(on: req.db).all()
    }

//    @Sendable
//    func createTestModelFromXLSX(req: Request) async throws -> [TestModel]{
//        struct InputExcelSheet: Content{
//            var file: File
//        }
//
//        let inputXlxs = try req.content.decode(InputExcelSheet.self)
//
//        if(inputXlxs.file.extension != "xlsx"){
////            statusMessage = "not an excel sheet"
//            _ = req.redirect(to: "admin")
//        }
//
//        let path = app.directory.publicDirectory + inputXlxs.file.filename
//        var testObjects: [TestModel] = []
//
//        if (FileManager.default.fileExists(atPath: path)){
//            testObjects = try parseXLSX(path: path)
//            return testObjects
//        }else{
//            _ = app.fileio.openFile(path: path, mode: .write, flags: .allowFileCreation(posixMode: 0x744), eventLoop: req.eventLoop)
//                .flatMap {handle in
//                    req.application.fileio.write(fileHandle: handle, buffer: inputXlxs.file.data, eventLoop: req.eventLoop)
//                        .flatMapThrowing { _ in
//                            try handle.close()
////                            statusMessage = "upload success"
//                        }
//                }
//        }
////        statusMessage = "upload ok"
//        _ = req.redirect(to: "admin")
//        testObjects = try parseXLSX(path: path)
//        return testObjects
//    }
}
