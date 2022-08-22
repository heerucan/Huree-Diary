//
//  ImageManager.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import Foundation

import Alamofire
import SwiftyJSON

struct ImageManager {
    private init() { }
    static let shared = ImageManager()
    typealias imageCompletion = ((JSON) -> Void)
    typealias searchCompletion = ((JSON) -> Void)
    
    // MARK: - GET Unsplash Image
    
    func requestImage(page: Int, imageCompletion: @escaping imageCompletion) {
        
        let url = URLType.makeURL(.image, page)
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let imageList = json.arrayValue.map { $0["urls"]["full"].stringValue }
                print(imageList)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - GET Search Image by query
    
    func requestSearch(page: Int, query: String, imageCompletion: @escaping imageCompletion) {
        
        let url = URLType.makeURL(.image, page, query)
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
