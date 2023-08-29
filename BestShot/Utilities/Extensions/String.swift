//
//  String.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

extension String {
    func asURL () -> URL?{
        return URL(string: self)
    }
}
