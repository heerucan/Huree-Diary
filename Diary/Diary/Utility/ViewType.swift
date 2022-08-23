//
//  ViewType.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

enum ViewType: String {
    case Write = "일기 작성하기"
    case Edit = "일기 수정하기"
    
    var textColor: UIColor {
        switch self {
        case .Write:
            return Constant.Color.placeholder
        case .Edit:
            return Constant.Color.black
        }
    }
}
