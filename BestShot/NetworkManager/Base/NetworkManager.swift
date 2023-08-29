//
//  NetworkManager.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkManager: NetworkManagerProtocol {
   
    func request<T>(endpoint: Endpoint, method: Method) -> Observable<T> where T: Codable {
        guard var url = endpoint.path.asURL() else {return Observable.error(NetworkError.invalidUrl)}
        _ =  method == .Get && endpoint.params.count > 0 ? url.append(queryItems: endpoint.params.asQueryItems) : ()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(ApiInfo.content, forHTTPHeaderField: "Content-Type")
        request.httpBody = method != .Get ? endpoint.params.asData : nil
        return call(request: request)
    }
    
    func call<T>(request: URLRequest) -> Observable<T> where T: Codable {
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                guard let data = data , error == nil else {
                    let error = NetworkError.convert((response as? HTTPURLResponse)?.statusCode) ?? NetworkError.convert(error)
                    return observer.onError(error)
                }
                /* I did use this function also to fetch the photo's Data
                 so just return it when the T's type is data */
                guard T.self != Data.self else {
                    observer.onNext(data as! T)
                    return observer.onCompleted()
                }
                
                guard let info = try? JSONDecoder().decode(T.self, from: data) else {
                    return  observer.onError(NetworkError.parse)
                }
                observer.onNext(info)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {task.cancel()}
        }.retry(3)
    }
}
