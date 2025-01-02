//
//  CreateTopic.swift
//  Beelearns-API
//
//  Created by Nguyễn Hưng on 30/12/2024.
//

import Fluent

struct CreateTopic: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("topics")
            .id()
            .unique(on: "name")
            .field("name", .string, .required)
            .create()
            
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("topics").delete()
    }
}
