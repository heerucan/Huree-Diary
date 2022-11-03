//
//  ViewType.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

enum ViewType: String {
    case Write = "옷 작성하기"
    case Edit = "옷 수정하기"
    
    var textColor: UIColor {
        switch self {
        case .Write:
            return Constant.Color.placeholder
        case .Edit:
            return Constant.Color.black
        }
    }
    
    var title: String {
        switch self {
        case .Write:
            return "작성하기"
        case .Edit:
            return "수정하기"
        }
    }
}
