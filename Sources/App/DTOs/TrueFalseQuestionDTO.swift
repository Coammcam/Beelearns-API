//
//  TrueFalseQuestionDTO.swift
//  
//
//  Created by HoangDus on 31/10/2024.
//

import Vapor
import Fluent

struct TrueFalseQuestionDTO: Content{
    var content: String?
    var vietnameseMeaning: String?
    var answer: String?
    var correction: String?
    var topic: String?
}
