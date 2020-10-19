//
//  EventViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation
import RxSwift
import RxCocoa

struct EventViewModel {
    
    private let event: Event
    
    var title: String {
        return event.title ?? "Evento sem título"
    }
    
    init(event: Event) {
        self.event = event
    }
}
