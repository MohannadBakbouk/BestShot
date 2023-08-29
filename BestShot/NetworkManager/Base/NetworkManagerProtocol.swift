//
//  NetworkManagerProtocol.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import RxSwift

public typealias JSON = [String : Any]

protocol NetworkManagerProtocol{
    func request<T: Codable>(endpoint: Endpoint, method: Method) -> Observable<T>
    func call<T: Codable>(request: URLRequest) -> Observable<T>
}
