//
//  Topic.swift
//  Beelearns-API
//
//  Created by Nguyễn Hưng on 30/12/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

final class Topic: Model {
    static let schema = "topics"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: ObjectId? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    func toDTO() -> TopicDTO {
        .init(
            name: self.name
        )
    }
    
    
}

