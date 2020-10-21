//
//  RequestFactory.swift
//  DesafioSicredi
//
//  Created by Luiz Felipe Trindade on 18/10/20.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

final class RequestFactory {
    
    static func request(httpMethod: HttpMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    static func makePostRequest(_  params: [String: Any]) -> URLRequest? {
        let url = APIEnvironment.shared.getUrl(for: .checkin, event: nil)
        let urlFinal = URL(string: url)!
        var requestFinal = request(httpMethod: .post, url: urlFinal)
        requestFinal.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return nil }

        requestFinal.httpBody = httpBody
        requestFinal.timeoutInterval = 20
        return requestFinal
    }
}
