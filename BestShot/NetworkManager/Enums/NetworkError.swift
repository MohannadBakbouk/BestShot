//
//  NetworkError.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation

enum NetworkError: Int,  Error {
    case forbidden
    case notFound
    case server
    case parse
    case invalidUrl
    case internetOffline
    case invalidHostname
    case errorOccured
    
    var message : String {
        switch self {
            case .internetOffline:  return ErrorMessages.internet
            case .server: return ErrorMessages.server
            case .errorOccured: return ErrorMessages.general
            case .parse: return ErrorMessages.parsing
            case .notFound : return ErrorMessages.notFound
            case .invalidHostname: return ErrorMessages.hostNameNotFound
            default: return ErrorMessages.anInternal
        }
    }
    
    static func convert(_ error : Error?) -> NetworkError{
        guard let mapped = error as? URLError else {
            return .errorOccured
            
        }
        switch mapped.code {
          case .notConnectedToInternet : return .internetOffline
          case .timedOut: return .internetOffline
          case .cannotDecodeContentData: return .parse
          case .cannotDecodeRawData: return .parse
          case .appTransportSecurityRequiresSecureConnection: return .invalidUrl
          case .cannotFindHost : return .invalidHostname
          default: return .errorOccured
        }
    }
    
    static func convert(_ code : Int?) -> NetworkError?{
        return code == 403 ? .forbidden : code == 404 ? .notFound :  code == 500 ? .server : nil
    }
}
