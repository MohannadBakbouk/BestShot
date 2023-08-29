//
//  Photo.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

struct Photo : Codable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
    
    enum CodingKeys: String, CodingKey{
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case ispublic
        case isfriend
        case isfamily
    }
}

extension Photo {
    var url : String? {
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = "farm\(String(describing: farm)).static.flickr.com"
        comps.path = "/\(server)/\(id)_\(secret).jpg"
        return comps.url?.absoluteString
    }
}
