//
//  SearchPhotoResponse.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

struct SearchPhotosResponse : Codable {
    let results: SearchPhotoResults?
    let stat: String
    
    enum CodingKeys: String, CodingKey{
        case results = "photos"
        case stat
    }
}

struct  SearchPhotoResults : Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total:  Int
    let items: [Photo]
    
    enum CodingKeys: String, CodingKey{
        case page
        case pages
        case perpage
        case total
        case items = "photo"
    }
}
