//
//  IPAController.swift
//  
//
//  Created by HoangDus on 09/11/2024.
//

import Fluent
import Vapor

struct IPAController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let IPAs = routes.grouped("IPA")
        IPAs.get(use: getAll)
    }
    
    func getAll(req: Request) async throws -> [IPADTO]{
        let IPAs = try await IPA.query(on: req.db).all().map{
            IPA in IPA.toDTO()
        }
        return IPAs
    }
}
