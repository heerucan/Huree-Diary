//
//  BaseViewMethod.swift
//  Diary
//
//  Created by heerucan on 2022/11/03.
//

import Foundation

protocol BaseViewMethodType: AnyObject {
    func configureUI()
    func configureLayout()
    func setupDelegate()
}
