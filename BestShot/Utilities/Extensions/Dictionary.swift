//
//  Dictionary.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

extension Dictionary {
    var asData: Data?{
        let json = try? JSONSerialization.data(withJSONObject: self)
        return json
    }
    var asQueryItems: [URLQueryItem]{
        self.map{URLQueryItem(name: String(describing: $0.key), value: String(describing: $0.value))}
    }
}
