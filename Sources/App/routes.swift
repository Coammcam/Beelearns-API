import Fluent
import Vapor
import CoreXLSX
import Foundation

struct testObject: Equatable{
    var value1: String?
    var value2: String?
    var value3: String?
}

func routes(_ app: Application) throws {
    
    var statusMessage = ""
    var testObjects: [TestModel] = []
    
    struct AdminPageData: Encodable{
        var statusMessage = ""
        var testObjects: [TestModel] = []
    }
    
    app.get("admin") { req async throws in
        try await req.view.render("index", AdminPageData(statusMessage: statusMessage, testObjects: testObjects))
    }
    
    app.post("upload-data") { req throws in
        struct InputExcelSheet: Content{
            var file: File
        }

        let inputXlxs = try req.content.decode(InputExcelSheet.self)

        if(inputXlxs.file.extension != "xlsx"){
            statusMessage = "not an excel sheet"
            return req.redirect(to: "admin")
        }

        let path = app.directory.publicDirectory + inputXlxs.file.filename

        if (FileManager.default.fileExists(atPath: path)){
            testObjects = try parseXLSX(pathToXLSX: path)
            statusMessage = "done"
            for testObject in testObjects {
                _ = testObject.save(on: req.db)
            }
        }else{
            _ = app.fileio.openFile(path: path, mode: .write, flags: .allowFileCreation(posixMode: 0x744), eventLoop: req.eventLoop)
                .flatMap {handle in
                    req.application.fileio.write(fileHandle: handle, buffer: inputXlxs.file.data, eventLoop: req.eventLoop)
                        .flatMapThrowing { _ in
                            try handle.close()
                            statusMessage = "upload success"
                            testObjects = try parseXLSX(pathToXLSX: path)
                            for testObject in testObjects {
                                _ = testObject.save(on: req.db)
                            }
                        }
                }
        }
        return req.redirect(to: "admin")
    }
    
    app.post("upload-file") { req -> EventLoopFuture<String> in
        struct InputFile: Content{
            var file: File
        }
        
        let inputFile = try req.content.decode(InputFile.self)
        
        let path = app.directory.publicDirectory + inputFile.file.filename
        return app.fileio.openFile(path: path, mode: .write, flags: .allowFileCreation(posixMode: 0x744), eventLoop: req.eventLoop)
            .flatMap {handle in
                req.application.fileio.write(fileHandle: handle, buffer: inputFile.file.data, eventLoop: req.eventLoop)
                    .flatMapThrowing { _ in
                        try handle.close()
                        return inputFile.file.filename
                    }
            }
    }
    
    try app.register(collection: TestModelController(app: app))
}
