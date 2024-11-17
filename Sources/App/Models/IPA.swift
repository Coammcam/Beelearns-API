//
//  IPA.swift
//  
//
//  Created by HoangDus on 07/11/2024.
//

import Fluent
import FluentMongoDriver
import Vapor


final class IPA: Model {
    static let schema: String = "ipas"
    
    @ID(custom: .id)
    var id: ObjectId?
    @Field(key: "symbol")
    var symbol: String
    @Field(key: "sound_in_mp3_url")
    var soundInMp3URL: String
    @Field(key: "example_word")
    var exampleWord: String
    @Field(key: "vietnamese_meaning")
    var vietnameseMeaning: String
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    
    init() {}
    
    init(id: ObjectId? = nil, symbol: String, soundInMp3URL: String, exampleWord: String, vietnameseMeaning: String) {
        self.id = id
        self.symbol = symbol
        self.soundInMp3URL = soundInMp3URL
        self.exampleWord = exampleWord
        self.vietnameseMeaning = vietnameseMeaning
    }
    
    func toDTO() -> IPADTO{
        return IPADTO(symbol: symbol, soundInMp3URL: soundInMp3URL, exampleWord: exampleWord, vietnameseMeaning: vietnameseMeaning)
    }
}
