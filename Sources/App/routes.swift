import Fluent
import Vapor
import CoreXLSX
import Foundation

func routes(_ app: Application) throws {
    
    var statusMessage = ""
//    struct AdminPageData: Encodable{
//        var statusMessage = ""
//        var testObjects = []
//    }
    
    app.get("admin") { req async throws in
//        try await req.view.render("index", AdminPageData(statusMessage: statusMessage, testObjects: testObjects))
        try await req.view.render("index", ["statusMessage": statusMessage])
    }
    
    app.post("upload-data") { req throws in
        struct InputExcelSheet: Content{
            var file: File
        }
        
//        print(req.peerAddress?.hostname)
//        print(req.peerAddress?.ipAddress)
        
        let inputXlxs = try req.content.decode(InputExcelSheet.self)
        
        let xlsxData = Data(buffer: inputXlxs.file.data)
        
        if(inputXlxs.file.extension != "xlsx"){
            statusMessage = "not an excel sheet"
            return req.redirect(to: "admin")
        }

        _ = try parseXLSX(_: Word.self, XLSXData: xlsxData).create(on: req.db)
        statusMessage = "done"
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
    try app.register(collection: WordController())
}
