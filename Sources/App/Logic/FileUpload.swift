//
//  FileUpload.swift
//  
//
//  Created by HoangDus on 26/10/2024.
//

import Vapor

struct FileUploadMiddleware: AsyncMiddleware{
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        let app: Application = request.application
        struct InputFile: Content{
            var file: File
        }
        let inputFile = try request.content.decode(InputFile.self)
        let path = app.directory.publicDirectory + inputFile.file.filename
        if (!FileManager.default.fileExists(atPath: path)){
            _ = app.fileio.openFile(path: path, mode: .write, flags: .allowFileCreation(posixMode: 0x744), eventLoop: request.eventLoop)
                .tryFlatMap{handle in
                    request.application.fileio.write(fileHandle: handle, buffer: inputFile.file.data, eventLoop: request.eventLoop)
                        .flatMapThrowing{ _ in
                            try handle.close()
                        }
                }
        }
        
        return try await next.respond(to: request)
    }
}
