//
//  PhotoViewData.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import UIKit

struct PhotoViewData {
    let title : String
    let urlString : String
    let width: CGFloat
    let height: CGFloat
    let image: UIImage?
}

extension PhotoViewData{
    init(info: Photo){
        self.title = info.title
        self.urlString = info.url ?? ""
        self.width = info.image?.size.width ?? 200
        self.height = info.image?.size.height ?? 200
        self.image = info.image
    }
}
