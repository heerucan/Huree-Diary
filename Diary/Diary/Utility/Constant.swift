//
//  Constant.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

struct Constant {
    private init() { }
    enum Image {
        case photo
        case plus
        
        var assets: UIImage? {
            switch self {
            case .photo:
                return UIImage(systemName: "photo.circle.fill")
            case .plus:
                return UIImage(systemName: "plus")
            }
        }
    }
    
    enum Color {
        static let background = UIColor.systemBackground
        static let border = UIColor.black.cgColor
        static let placeholder = UIColor.systemGray3
        static let point = UIColor.systemGreen
        static let black = UIColor.black
    }
    
    enum Placeholder: String {
        case diary = "일기를 작성해주세요"
        case title = "제목을 작성해주세요"
        case date = "날짜를 작성해주세요"
    }
}
