//
//  QueryObject.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

class QueryObject{
    let text: String
    let date: Date
    
    init(text: String, date: Date = Date()) {
        self.text = text
        self.date = date
    }
}
