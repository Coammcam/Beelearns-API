//
//  MovieDTO.swift
//  
//
//  Created by HoangDus on 09/11/2024.
//

import Vapor

struct MovieDTO: Content{
    var title: String?
    var description: String?
    var duration: String?
    var genre: String?
    var rating: String?
    var year: String?
}
