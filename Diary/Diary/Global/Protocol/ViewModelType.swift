//
//  ViewModelType.swift
//  Diary
//
//  Created by heerucan on 2022/11/03.
//

import Foundation

protocol ViewModelType: AnyObject{
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
