//
//  TestModel.swift
//  
//
//  Created by Hoang McDuck on 23/10/2024.
//

import Fluent
import Vapor
import struct Foundation.UUID

final class TestModel: Model, Content{
    static let schema: String = "testmodels"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "value1")
    var value1: String?
    @Field(key: "value2")
    var value2: String?
    @Field(key: "value3")
    var value3: String?

    init(){}

    init(id: UUID? = nil, value1: String? = nil, value2: String? = nil, value3: String? = nil) {
        self.id = id
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
    }
    
}
