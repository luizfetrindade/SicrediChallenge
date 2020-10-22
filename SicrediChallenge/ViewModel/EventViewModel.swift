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
    private let guestViewModel: GuestListViewModel
    
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
    
    var guest: GuestListViewModel {
        return GuestListViewModel.init(person: event.people!)
    }
    
    var latitude: Double? {
        event.latitude
    }
    
    var longitude: Double? {
        event.longitude
    }

    
    init(event: Event, guest: GuestListViewModel) {
        self.event = event
        self.guestViewModel = guest
    }
}
