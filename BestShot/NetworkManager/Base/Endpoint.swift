//
//  Endpoint.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
protocol Endpoint{
    var action: String {get}
    var path: String{get}
    var params: JSON {get}
    var authParams: JSON{get}
}

extension Endpoint{
    var authParams:JSON {
        return ["api_key": ApiInfo.key,
                "format": ApiInfo.format ,
                "nojsoncallback": "1"]
    }
}
