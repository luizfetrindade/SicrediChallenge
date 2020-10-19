//
//  EventAPIClient.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation
import RxCocoa
import RxSwift

class EventAPIClient {
    static var shared = EventAPIClient()
    
    lazy var requestObservable = EventService(config: .default)
    
    func getEvent(_ id: String) throws -> Observable<Event> {
        
        let urlFinal = APIEnvironment.shared.getUrl(for: .events, event: id)
        
        var request = URLRequest(url: URL(string: urlFinal)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestObservable.fetchEvent(request: request).map {
            EventViewModel(event: $0)   
        }
    }
}

