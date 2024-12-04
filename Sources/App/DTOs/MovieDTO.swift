//
//  MovieDTO.swift
//  
//
//  Created by HoangDus on 09/11/2024.
//

import Vapor

struct MovieDTO: Content{
    var title: String?
    var banner: String?
    var poster: String?
    var description: String?
    var duration: String?
    var genre: String?
    var rating: String?
    var year: String?
    var trailer: String?
    
    func toModel() -> Movie {
        let model = Movie()
        
        model.title = self.title ?? ""
        model.banner = self.banner ?? ""
        model.poster = self.poster ?? ""
        model.description = self.description ?? ""
        model.duration = self.duration ?? ""
        model.genre = self.genre ?? ""
        model.rating = self.rating ?? ""
        model.year = self.year ?? ""
        model.trailer = self.trailer ?? ""
        
        return model
    }
}
