//
//  WordDTO.swift
//  
//
//  Created by HoangDus on 30/10/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

struct WordDTO: Content{
//    var id: ObjectId?
    var englishWord: String?
    var vietnameseMeaning: String?
}
