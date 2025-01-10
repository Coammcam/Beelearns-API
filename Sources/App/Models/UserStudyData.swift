//
//  UserData.swift
//  
//
//  Created by HoangDus on 28/12/2024.
//

import Fluent
import FluentMongoDriver
import Vapor

final class UserStudyData: Model {
    static let schema = "user_study_data"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "user_email")
    var userEmail: String
    
    @Field(key: "score")
    var score: Int

    @Field(key: "exp")
    var exp: Int
    
    @Field(key: "part")
    var part: Int
    
    @Field(key: "level")
    var level: Int
    
    @Field(key: "heart")
    var heart: Int
    
    @Field(key: "honey_jar")
    var honeyJar: Int
    
    init() {}
    
    init(id: ObjectId? = nil,
         userEmail: String,
         score: Int = 0,
         exp: Int = 0,
         part: Int = 1,
         level: Int = 1,
         heart: Int = 5,
         honeyJar: Int = 100
    ) {
        self.id = id
        self.userEmail = userEmail
        self.score = score
        self.exp = exp
        self.part = part
        self.level = level
        self.heart = heart
        self.honeyJar = honeyJar
    }
    
    func toDTO() -> UserStudyDataDTO{
        return UserStudyDataDTO(score: score, exp: exp, part: part, level: level, honeyComb: heart, honeyJar: honeyJar)
    }
}

