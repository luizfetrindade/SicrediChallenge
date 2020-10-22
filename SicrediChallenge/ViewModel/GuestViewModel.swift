//
//  GuestViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 22/10/20.
//

import Foundation
import RxSwift
import Kingfisher
import RxCocoa

struct GuestViewModel {
    
    private let person: Person
    
    var name: String {
        person.name
    }
    
    init(person: Person) {
        self.person = person
    }
}
