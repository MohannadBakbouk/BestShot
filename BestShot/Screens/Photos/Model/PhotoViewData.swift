//
//  PhotoViewData.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

struct PhotoViewData {
    let title : String
    let urlString : String
}

extension PhotoViewData{
    init(info: Photo){
        self.title = info.title
        self.urlString = info.url ?? ""
    }
}
