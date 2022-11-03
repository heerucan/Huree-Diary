//
//  URLType.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import Foundation

enum URLType {
    static let baseURL = "https://api.unsplash.com"
    case search
    case image
    
    var endpoint: String {
        switch self {
        case .search:
            return URLType.baseURL + "/search/photos/?per_page=50"
        case .image:
            return URLType.baseURL + "/photos/?per_page=50"
        }
    }
    
    static func makeURL(_ type: URLType, _ page: Int, _ query: String? = nil) -> String {
        if let query = query {
            return type.endpoint + "&page=\(page)&query=\(query)&client_id=" + APIKey.accesskey
        } else {
            return type.endpoint + "&page=\(page)&client_id=" + APIKey.accesskey
        }
    }
}
