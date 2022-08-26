//
//  UserDiaryRepository.swift
//  Diary
//
//  Created by heerucan on 2022/08/26.
//

import Foundation
import RealmSwift

// 또한, 테이블이 2개 이상이면 UserDiary가 아닌 제네릭을 통해서 사용해볼 수 있기 때문.
// 이 프로토콜은 아래와 같은 메소드를 필수로 구현해!
protocol UserDiaryRepositoryType {
    func fetch(keyPath: String, ascending: Bool) -> Results<UserDiary>
    func fetchFilter(query: String) -> Results<UserDiary>
    func updateFavorite(item: UserDiary)
    func deleteItem(item: UserDiary)
    func addItme(item: UserDiary)
}

// 아래 클래스는 위 프로토콜을 채택하기에 해당 메소드를 필수로 구현해!
class UserDiaryRepository: UserDiaryRepositoryType {
    
    let localRealm = try! Realm()
    
    func addItme(item: UserDiary) {
        
    }
    
    func fetch(keyPath: String, ascending: Bool) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    func fetchFilter(query: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("title CONTAINS '"+query+"'" )
    }
    
    func updateFavorite(item: UserDiary) {
        do {
            /* realm update */
            try localRealm.write {
                /* 이거는 하나만 바뀜 */
                item.favorite = !item.favorite
                // item.favorite.toggle()
                
                /* 하나의 테이블에 특정 컬럼 전체를 변경
                 => 하나만 바꾸면 다른 것도 다 바뀜
                 self.tasks.setValue(true, forKey: "favorite") */
                
                /* 하나의 레코드에서 여러 컬럼들이 변경
                 => 루희야 이거 컬럼이야! 다른 레코드가 아님! 컬럼들이 바뀐다고!!
                 self.localRealm.create(UserDiary.self,
                 value: [
                 "objectId": self.tasks[indexPath.row].objectId,
                 "content": "내용 변경 테스트",
                 "title": "제목 변경 테스트"],
                 update: .modified)*/
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteItem(item: UserDiary) {
        do {
            // 사진을 먼저 지우고 task를 지우면 해결이 되는 이유를 이해하자!
            
            let task = item
            
            /* realm delete */
            try? localRealm.write {
                localRealm.delete(task)
                print("Delete 성공!")
            }
            
            removeImageFromDocument(fileName: "\(item.objectId).jpg")
            //                fetchRealmData() -> didSet 그리고 beginUpdates 때문에 해주지 않아도 된다.
        }
    }
    
    // ⭐️ Document에서 이미지 삭제하기
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
