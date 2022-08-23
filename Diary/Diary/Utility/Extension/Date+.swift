//
//  Date+.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd hh:mm"
        return dateFormatter.string(from: self)
    }
}
