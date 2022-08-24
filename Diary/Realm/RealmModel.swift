//
//  RealmModel.swift
//  Diary
//
//  Created by heerucan on 2022/08/22.
//

import Foundation

import RealmSwift

// MARK: - UserDiary

/*
 UserDiary : 테이블이름
 @Persisted : 컬럼명
*/

class UserDiary: Object {
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var createdAt = Date() // 일기가 업로드 되는 실제 날짜
    @Persisted var updatedAt: String // 일기에 들어가는 날짜
    @Persisted var favorite: Bool // 즐겨찾기
    @Persisted var image: String?
    
    // PK, Primary Key : 중복되지 않은 Int, UUID or ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String,
                     content: String,
                     createdAt: Date,
                     updatedAt: String,
                     image: String?) {
        self.init()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.favorite = false
        self.image = image
    }
}
