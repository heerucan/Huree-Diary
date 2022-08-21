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
        
        var placeholder: String {
            switch self {
            case .title:
                return "제목을 입력해주세요"
            case .date:
                return "날짜를 입력해주세요"
            }
        }
    }
    
    // MARK: - Initializer
    
    init(_ type: FieldType) {
        super.init(frame: .zero)
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
        tintColor = .systemOrange
        textColor = .black
    }
}
