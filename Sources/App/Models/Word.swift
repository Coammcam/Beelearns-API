//
//  WordModel.swift
//  
//
//  Created by HoangDus on 24/10/2024.
//

import Fluent
import FluentMongoDriver
import Vapor

final class Word: Model{
    static let schema: String = "words"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "english_word")
    var englishWord: String?
    
    @Field(key: "vietnamese_meaning")
    var vietnameseMeaning: String?
    
    @Field(key: "topic")
    var topic: String
    
    @Field(key: "level")
    var level: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var deletedAt: Date?
    
    
    init() {}
    
    init(id: ObjectId? = nil, englishWord: String? = nil, vietnameseMeaning: String? = nil, topic: String, level: Int) {
        self.id = id
        self.englishWord = englishWord
        self.vietnameseMeaning = vietnameseMeaning
        self.topic = topic
        self.level = level
    }
    
    func toDTO() -> WordDTO{
        return WordDTO(englishWord: englishWord, vietnameseMeaning: vietnameseMeaning, topic: topic, level: level)
    }
}
