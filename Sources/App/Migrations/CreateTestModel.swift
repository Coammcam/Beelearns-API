//
//  CreateTestModel.swift
//  
//
//  Created by Hoang McDuck on 23/10/2024.
//

import Foundation
import Fluent

struct createTestModel: AsyncMigration{
    func prepare(on database: Database) async throws {
        database.schema("testmodels")
            .id()
            .field("value1", .string, .required)
            .field("value2", .string, .required)
            .field("value3", .string, .required)
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("testmodels").delete()
    }
}
