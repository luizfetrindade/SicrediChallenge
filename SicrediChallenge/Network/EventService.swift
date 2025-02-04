//
//  EventService.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import Foundation
import RxSwift


protocol EventServiceProtocol {
    func fetchEvents(request: URLRequest) -> Observable<[Event]>
    func requestFromAPI(request: URLRequest) -> Observable<Event>
}

public class EventService: EventServiceProtocol {
    private lazy var jsonDecoder = JSONDecoder()
    
    private var urlSession: URLSession
    
    public init(config: URLSessionConfiguration) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func fetchEvents(request: URLRequest) -> Observable<[Event]> {
        
        return Observable.create { observer in 
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode([Event].self, from: _data)
                            observer.onNext(objs)
                        } else {
                            observer.onError(NSError.init(domain: "Bad Request", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with \(statusCode)"]))
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
    
    func requestFromAPI<ItemModel: Decodable>(request: URLRequest) -> Observable<ItemModel> {
        return Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            print("status: ", statusCode)
                            let objs = try self.jsonDecoder.decode(ItemModel.self, from: _data)
                            observer.onNext(objs)
                        } else {
                            observer.onError(NSError.init(domain: "Bad Request", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with \(statusCode)"]))
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
    
    func postCheckin(request: URLRequest) -> Observable<Int> {
        return Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        if (200...399).contains(statusCode) {
                            observer.onNext(statusCode)
                        } else {
                            observer.onError(NSError.init(domain: "Bad Request", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with \(statusCode)"]))
                        }
                    }
                }  else {
                    observer.onError(NSError.init(domain: "Bad Request", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to stabilsh conection"]))
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
