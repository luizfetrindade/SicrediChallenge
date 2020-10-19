//
//  Person.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation

struct Person: Decodable {
    let picture: String
    let name, eventID, id: String

    enum CodingKeys: String, CodingKey {
        case picture, name
        case eventID = "eventId"
        case id
    }
}
