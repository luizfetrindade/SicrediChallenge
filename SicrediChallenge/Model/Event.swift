//
//  Event.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation

struct Event: Decodable {
    let people: [Person]?
    let date: Int?
    let eventDescription: String?
    let image: String?
    let longitude, latitude, price: Double?
    let title, id: String?

    enum CodingKeys: String, CodingKey {
        case people, date
        case eventDescription = "description"
        case image, longitude, latitude, price, title, id
    }
}
