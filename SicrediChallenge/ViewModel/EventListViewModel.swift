//
//  EventListViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import Foundation
import RxSwift

final class EventListViewModel {
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService(config: .default)) {
        self.eventService = eventService
    }
    
    lazy var requestObservable = EventService(config: .default)
    
    func fetchEvents() throws -> Observable<[EventViewModel]> {
        let urlFinal = APIEnvironment.shared.getUrl(for: .events, event: nil)
        
        var request = URLRequest(url: URL(string: urlFinal)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.fetchEvents(request: request).map  {
            $0.map{
                EventViewModel(event: $0)
            }
        }
    }
    
    func fetchEventDetails(_ id: String) throws -> Observable<EventViewModel> {
        let urlFinal = APIEnvironment.shared.getUrl(for: .eventDetails, event: id)
        
        var request = URLRequest(url: URL(string: urlFinal)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestFromAPI(request: request).map  {
            EventViewModel(event: $0)
        }
    }
}
