//
//  EventViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation
import RxSwift
import Kingfisher
import RxCocoa

struct EventViewModel {
    
    private let event: Event
    
    var title: String {
        event.title ?? "Evento sem título"
    }
    
    var id: String {
        event.id ??  "\(UUID.init())"
    }
    
    var description: String {
        event.eventDescription ?? "Evento sem descrição."
    }
    
    var date: Int? {
        event.date
    }
    
    var image: URL? {
        guard event.image == nil else {
           return URL(string: event.image!)
        }
        return nil
    }
    
    var guests: [Person]? {
        event.people
    }
    
    var latitude: Double? {
        event.latitude
    }
    
    var longitude: Double? {
        event.longitude
    }

    
    init(event: Event) {
        self.event = event
    }
}
