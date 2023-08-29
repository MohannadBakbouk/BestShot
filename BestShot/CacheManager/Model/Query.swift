//
//  Query.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import CoreData

extension Query{
    override func populate(with value: AnyObject){
        guard let info = value as? QueryObject else { return}
        self.text = info.text
        self.date = info.date
    }
}
