//
//  SearchParams.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

struct SearchParams {
    var page : Int
    var size : Int
    var query : String?
    var pages: Int
    
    init(query : String? = nil , page : Int = 1 , size : Int = 25, pages: Int = 0) {
        self.query = query
        self.page = page
        self.size = size
        self.pages = pages
    }
    
    var canLoadMore: Bool{
        return page < pages
    }
}

extension SearchParams {
    var  asJson: JSON {
        var info: JSON = ["page" : page , "per_page" : size]
        _ =  query != nil ?  info["text"] =  query! : ()
        return info
    }
}
