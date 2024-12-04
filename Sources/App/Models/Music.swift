//
//  Music.swift
//
//
//  Created by Nguyễn Hưng on 07/11/2024.
//

import Vapor
import Fluent

final class Music: Model, Content {
    static let schema = "music"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "duration")
    var duration: String
    
    @Field(key: "artist")
    var artist: String
    
    @Field(key: "link_on_youtube")
    var link_on_youtube: String
    
    @Timestamp(key: "create_at", on: .create)
    var createAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, title: String, image_url: String, description: String, duration: String, artist: String ,link_on_youtube: String, createAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.image_url = image_url
        self.description = description
        self.duration = duration
        self.artist = artist
        self.link_on_youtube = link_on_youtube
        self.createAt = createAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> MusicDTO {
        .init(
            title: self.title,
            image_url: self.image_url,
            description: self.description,
            duration: self.duration,
            artist: self.artist,
            link_on_youtube: self.link_on_youtube
        )
    }
}
