//
//  CombinedQuestionDTO.swift
//
//
//  Created by Nguyễn Hưng on 19/11/2024.
//

import Vapor

struct CombinedQuestionDTO: Content {
    var words: [WordDTO]
    var trueFalseQuestions: [TrueFalseQuestionDTO]
    var grammarQuestions: [GrammarQuestionDTO]
}
