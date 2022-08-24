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
        case image
        case plus
        case close
        case menu
        case filter
        case heart
        case unselectedHome
        case selectedHome
        case unselectedSetting
        case selectedSetting
        
        var assets: UIImage? {
            switch self {
            case .photo:
                return UIImage(systemName: "photo.circle.fill")
            case .image:
                return UIImage(systemName: "photo.circle")
            case .plus:
                return UIImage(systemName: "plus")
            case .close:
                return UIImage(systemName: "xmark")
            case .menu:
                return UIImage(systemName: "ellipsis.circle")
            case .filter:
                return UIImage(systemName: "eyes")
            case .heart:
                return UIImage(systemName: "heart")
            case .unselectedHome:
                return UIImage(systemName: "book.closed")
            case .selectedHome:
                return UIImage(systemName: "book.closed.fill")
            case .unselectedSetting:
                return UIImage(systemName: "gearshape")
            case .selectedSetting:
                return UIImage(systemName: "gearshape.fill")
            }
        }
    }
    
    enum Color {
        static let background = UIColor.systemBackground
        static let border = UIColor.black.cgColor
        static let placeholder = UIColor.systemGray3
        static let point = UIColor.systemGreen
        static let black = UIColor.black
        static let lightGray = UIColor.systemGray5
    }
    
    enum Placeholder: String {
        case searchBar = "영어로 사진을 검색해주세요"
        case diary = "일기를 작성해주세요"
        case title = "제목을 작성해주세요"
        case date = "날짜를 선택해주세요"
        case filter = "찾고 싶은 일기의 키워드를 입력하세요"
    }
}
