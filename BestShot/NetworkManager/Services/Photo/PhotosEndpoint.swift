//
//  PhotosEndpoint.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

enum PhotosEndpoint: Endpoint{
    case searchPhotos(info: SearchParams)
    case fetchImage(url: URL)
    
    var action: String {
        switch self {
         case .searchPhotos: return "flickr.photos.search"
         case .fetchImage: return ""
      }
    }
    
    var params : JSON{
        switch self {
          case .searchPhotos(let searchParams):
            var params: JSON = ["method": action]
            _ = [authParams, searchParams.asJson].map{params.merge(dict: $0)}
            return params
          case .fetchImage: return [:]
        }
    }
    
    var method: Method {
        switch self {
          case .searchPhotos: return .Get
          case .fetchImage:   return .Get
        }
    }
    
    var path: String{
        switch self {
          case .searchPhotos: return ApiInfo.baseUrl
          case .fetchImage(let url): return url.absoluteString
        }
    }
}
