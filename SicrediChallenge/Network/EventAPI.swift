//
//  EventAPI.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventAPIProtocol {
    func requestAPI(request: URLRequest) -> Observable<Event>
}

public class EventAPI: EventAPIProtocol {
    private lazy var jsonDecoder = JSONDecoder()
    
    private var urlSession: URLSession
    
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func requestAPI<T: Decodable>(request: URLRequest) -> Observable<T> {
        
        return Observable.create { observer in
            
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let _data = data ?? Data()
                        
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode(T.self, from: _data)
                            
                            observer.onNext(objs)
                        } else {
                            observer.onError(NSError.init(domain: "Bad Request", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request failed"]))
                        }
                    } catch let error {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
