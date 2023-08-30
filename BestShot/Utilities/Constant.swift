//
//  Constant.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import CoreData

enum ApiInfo {
    static let content = "application/json; charset=utf-8"
    static let baseUrl = "https://www.flickr.com/services/rest/"
    static let key = "9480a18b30ba78893ebd8f25feaabf17"
    static let format = "json"
}

enum ErrorMessages{
    static let  internet = "Please make sure you are connected to the internet"
    static let  server = "an internal error occured in server side please try again later"
    static let  general = "Something went wrong"
    static let  parsing = "an internal error occured while parsing the request please try again later"
    static let  anInternal = "an internal error occured"
    static let  notFound = "the url you have requested is not exited"
    static let  hostNameNotFound =  "the host you have requested is not existed"
}

enum Images {
    static let clock = "clock"
    static let exclamationmark = "exclamationmark.circle.fill"
}

enum DefaultSettings   {
    static let modelName = "QueryModel"
    static let modelBundleIdentifier = "com.mohannad.BestShot"
}

enum StorageType  {
    static let  memory = NSInMemoryStoreType
    static let  disk = NSSQLiteStoreType
}
