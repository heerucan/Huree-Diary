//
//  UIViewController+.swift
//  Diary
//
//  Created by heerucan on 2022/08/23.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [UIAlertAction] = [],
                   cancelTitle: String? = "취소",
                   preferredStyle: UIAlertController.Style = .actionSheet) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        transition(alert, .present)
    }
    
    enum OKType {
        case ok
        case moreAction
    }
    
    func showAlertController(_ title: String, type: OKType = .ok) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        switch type {
        case .ok:
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(ok)
        case .moreAction:
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let viewController = TabBarViewController()
                sceneDelegate?.window?.rootViewController = viewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            alert.addAction(ok)
        }        
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
