//
//  SettingViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/24.
//

import UIKit

import Zip

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    lazy var backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.addTarget(self, action: #selector(touchupBackupButton(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var restoreButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구하기", for: .normal)
        view.addTarget(self, action: #selector(touchupRestoreButton(_:)), for: .touchUpInside)
        return view
    }()
    
    let lineView = UIView()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDocumentZipFile()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = "환경설정"
        lineView.backgroundColor = Constant.Color.lightGray
        [backupButton, restoreButton].forEach {
            $0.backgroundColor = Constant.Color.point
            $0.makeCornerStyle()
        }
    }
    
    override func configureLayout() {
        view.addSubviews([backupButton, restoreButton, lineView, tableView])
        
        backupButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(backupButton.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(19)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).offset(20)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchupBackupButton(_ sender: UIButton) {
        var urlPaths = [URL]()
        
        // 도큐먼트 위치 확인
        guard let path = documentDirectoryPath() else {
            showAlertController("😱 도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        // 근데 realmFile이 없을 수 있어서 유효한 지 확인이 필요
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertController("백업할 파일이 없습니다.")
            return
        }
        
        // 실제로 파일이 있으면, urlPaths에 추가
        urlPaths.append(URL(string: realmFile.path)!)
        
        // 백업 파일이 있으면 압축 : realm file의 URL
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "Huree-Diary")
            print("저장 위치:", zipFilePath)
            // ActivityViewController 띄우기
            showActivityController(backupURL: "Huree-Diary.zip")

        } catch {
            showAlertController("🤯 압축을 실패했습니다!!")
        }
    }
    
    @objc func touchupRestoreButton(_ sender: UIButton) {
        print("복구")
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // 여러개 선택 X
        transition(documentPicker, .present)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.id, for: indexPath) as? HomeTableViewCell
        else { return UITableViewCell() }
        cell.titleLabel.text = "TEST"
        return cell
    }
}

// MARK: - UIDocumentPickerDelegate

extension SettingViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐먼트 피커를 닫았다")
    }
    
    // 문서 선택 후 뭘 해줄 것임?
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 선택한 파일url을 가져옴
        guard let selectedFileURL = urls.first else {
            showAlertController("🥵 선택한 파일에 오류가 있습니다!!")
            return
        }
        
        // 도큐먼트 위치 확인
        guard let path = documentDirectoryPath() else {
            showAlertController("😱 도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        // 복구파일을 우리 앱에 다시 넣어줄 경로 = 도큐먼트 경로 + 선택한 파일 url의 마지막 path
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        
        // 도큐먼트 위치에 해당 파일이 있으면
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("Huree-Diary.zip")
            
            do {
                
                // 어떤 파일을?, 어디에 압축풀까?, 덮어씌워줄까?, 비번을 설정할까?, 얼마나 진행되고 있는지?, 다 풀어주고 나면 뭐할까?
                // 기존 default.realm 파일을 덮어씌워줌
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("진행 정도:", progress)
                    
                }, fileOutputHandler: { unzippedFile in
                    print("복구 파일:", unzippedFile)
                    self.showAlertController("🥳 복구가 완료되었습니다.", type: .moreAction)
                })
                
            } catch {
                showAlertController("복구한 파일이 없습니다.")
            }
            
        } else { // 파일이 없으면 -> 파일앱에 있는 걸 이동시켜 copy하는 과정이 필요
            
            do {
                
                // 파일 앱에서 선택한 파일을 Document 폴더에 복사
                // at : 원래 있던 파일 -> to : 여기에 복사하겟당!!~
                // 무제파일 -> 무제파일1 -> 무제파일2 이렇게 계속 생성되잖아,,? 동일한 파일이 있으면?
                // => 동일한 파일이 있으면 덮어주는 게 default임
                // sandboxFileURL이라는 경로에 넣어줄 것을 의미함
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("Huree-Diary.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("진행 정도:", progress)
                    
                }, fileOutputHandler: { unzippedFile in
                    print("복구 파일:", unzippedFile)
                    self.showAlertController("😚 복구가 완료되었습니다><")
                })
                
            } catch {
                showAlertController("압축 해제에 실패했습니다ㅠㅠ")
            }
        }
    }
}
