//
//  EventDetailsViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 20/10/20.
//

import Foundation
import RxSwift
final class EventDetailsViewModel {
    
    lazy var eventService = EventService(config: .default)
    
    func checkin(_ params: [String: Any]) -> Observable<Int>{
        let request = RequestFactory.makePostRequest(params)
        return eventService.postCheckin(request: request!)
    }
}
