//
//  APIEnviorment.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import Foundation

enum APIEnvironmentEndpoints: String {
    case eventDetails = "/events/"
    case checkin = "/checkin"
    case events  = "/events"
}

struct APIEnvironment {
    static let shared = APIEnvironment()
    
    let baseURL = "http://5f5a8f24d44d640016169133.mockapi.io/api"
    
    func getUrl(for endpoint: APIEnvironmentEndpoints, event: String?) -> String {
        guard let event = event else {
            return baseURL + endpoint.rawValue
        }
        return baseURL + endpoint.rawValue + event
    }
}

