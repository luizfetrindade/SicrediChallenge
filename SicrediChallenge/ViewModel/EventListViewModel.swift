//
//  EventListViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import Foundation
import RxSwift

fileprivate extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}

final class EventListViewModel {
    let title =  "Eventos"
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService(config: .default)) {
        self.eventService = eventService
    }
    
    static var shared = EventListViewModel()
    
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
        
        return requestObservable.fetchEventDetails(request: request).map  {
            EventViewModel(event: $0)
        }
    }
}
