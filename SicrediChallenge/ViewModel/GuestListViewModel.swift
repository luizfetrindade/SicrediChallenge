//
//  GuestViewModel.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 22/10/20.
//

import Foundation
import RxCocoa
import RxSwift

struct GuestListViewModel {
    private let person: [Person]

    func getPicAt(_ index: Int) -> String? {
        if person.count > index && !person.isEmpty {
            return person[index].picture
        }
        return nil
    }
    
    var guestCount: Int {
        person.count
    }
    
    init(person: [Person]) {
        self.person = person
    }
}
