//
//  UIViewController+.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

extension UIViewController {
    typealias handler1 = ((UIAlertAction) -> Void)
    typealias handler2 = ((UIAlertAction) -> Void)
    typealias handler3 = ((UIAlertAction) -> Void)
    
    func showAlert(_ title: String,
                   _ message: String? = nil,
                   _ preferredStyle: UIAlertController.Style = .actionSheet,
                   button1: String, button2: String, button3: String, 
                   handler1: @escaping handler1,
                   handler2: @escaping handler2,
                   handler3: @escaping handler3) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action1 = UIAlertAction(title: button1, style: .default, handler: handler1)
        let action2 = UIAlertAction(title: button2, style: .default, handler: handler2)
        let action3 = UIAlertAction(title: button3, style: .default, handler: handler3)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func showAlertController(_ title: String) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }

    func showActivityController(backupURL: String) {
        // 도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertController("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("Huree-Diary.zip")
        let viewController = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil)
        transition(viewController, .present)
    }
}
