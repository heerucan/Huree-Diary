//
//  DiaryTextField.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

class DiaryTextField: UITextField {
    
    // MARK: - Enum
    
    enum FieldType {
        case title, date
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .title:
                return .default
            case .date:
                return .numberPad
            }
        }
        
        var placeholder: String {
            switch self {
            case .title:
                return Constant.Placeholder.title.rawValue
            case .date:
                return Constant.Placeholder.date.rawValue
            }
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: FieldType) {
        super.init(frame: .zero)
        self.keyboardType = type.keyboardType
        self.placeholder = type.placeholder
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        makeCornerStyle()
        borderStyle = .none
        textAlignment = .center
        tintColor = Constant.Color.point
        textColor = Constant.Color.black
        backgroundColor = Constant.Color.background
    }
}
