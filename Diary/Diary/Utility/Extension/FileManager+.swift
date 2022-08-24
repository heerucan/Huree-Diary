//
//  FileManager+.swift
//  Diary
//
//  Created by heerucan on 2022/08/24.
//

import UIKit

extension UIViewController {
    // ⭐️ Realm에 데이터도 저장하고 + Document에 이미지 저장
    func saveImageToDocument(fileName: String, image: UIImage) {
        /* Document 경로
         FileManager : 파일 처리와 관련된 대부분의 작업을 수행하고 싱글톤
        */
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        // Document 경로에서 세부 파일 경로를 지정, 이미지 저장할 위치
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        // image 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        /* 데이터가 잘 저장될 때까지 쭉 시도를 하다가 실패할 경우도 있잖아?
         근데 사용자는 무조건 저장하고 싶잖아
         1GB 이미지 다운로드하고 있는데 -> 용량이 부족할 경우에, catch문으로 들어갈 수 있고..
         1GB 이미지를 가져오고 싶은데 -> iCloud 연결이 갑자기 끊길 경우...
        */
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("파일 저장 오류!", error)
        }
    }
    
    // ⭐️ Document에서 이미지 가져오기
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        
        // Document 경로에서 세부 파일 경로를 지정, 이미지 저장할 위치
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            let image = Constant.Image.photo.assets
            return image
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
