//
//  WriteViewController.swift
//  Diary
//
//  Created by heerucan on 2022/08/21.
//

import UIKit

import PhotosUI
import RealmSwift

final class WriteViewController: BaseViewController {
        
    // MARK: - Realm
    
    let repository = UserDiaryRepository() // realm 테이블에 데이터를 CRUD할 때, realm 테이블 경로에 접근
    
    // MARK: - Property
    
    var viewType: ViewType = .Write
    let writerView = WriteView()
    var objectId: ObjectId?
    
    lazy var closeButton = UIBarButtonItem(image: Constant.Image.close.assets,
                                           style: .done,
                                           target: self,
                                           action: #selector(touchupCloseButton))
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = writerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationItem.title = viewType.rawValue
        navigationItem.rightBarButtonItem = closeButton
        writerView.saveButton.setTitle(viewType.rawValue, for: .normal)
        writerView.diaryTextView.textColor = viewType.textColor
        writerView.imageButton.addTarget(self, action: #selector(touchupImageButton(_:)), for: .touchUpInside)
        writerView.saveButton.addTarget(self, action: #selector(touchupSaveButton), for: .touchUpInside)
        writerView.datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        guard let objectId = objectId else { return }
        writerView.photoImageView.image = loadImageFromDocument(fileName: "\(objectId).jpg")
    }
    
    override func configureDelegate() {
        writerView.diaryTextView.delegate = self
    }
    
    private func changeTextViewColor() {
        if writerView.diaryTextView.text == Constant.Placeholder.diary.rawValue {
            writerView.diaryTextView.textColor = Constant.Color.placeholder
        } else {
            writerView.diaryTextView.textColor = Constant.Color.black
        }
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func presentPHPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    // MARK: - @objc
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        writerView.dateTextField.text = sender.date.toString()
    }
    
    @objc func touchupCloseButton() {
        let presentingViewController = HomeViewController()
        transition(presentingViewController, .presentedViewDismiss)
    }
    
    @objc func touchupImageButton(_ sender: UIButton) {
        showAlert("이미지 가져오기", button1: "카메라", button2: "갤러리", button3: "검색") { _ in
            self.presentImagePicker()
        } handler2: { _ in
            self.presentPHPhotoPicker()
        } handler3: { _ in
            let viewController = SearchImageViewController()
            viewController.imageCompletionHandler = { url in
                self.writerView.photoImageView.kf.setImage(with: url)
            }
            self.transition(viewController, .push)
        }
    }
    
    // ⭐️ Realm + 이미지 도큐먼트 저장 및 수정
    @objc func touchupSaveButton() {
        guard let title = writerView.titleTextField.text,
              let date = writerView.dateTextField.text,
              let content = writerView.diaryTextView.text else { return }
        
        // Create Record
        let task = UserDiary(title: title, content: content, createdAt: Date(), updatedAt: date, image: nil)
        
        if title.isEmpty || date.isEmpty ||
            content == Constant.Placeholder.diary.rawValue {
            showAlertController("일기를 완성해주세요 🐜")
        } else {
            do {
                try repository.localRealm.write {
                    if viewType == .Write {
                        repository.localRealm.add(task)
                        print("Create Realm 성공!", task)
                        transition(self, .dismiss)
                    } else {
                        guard let objectId = objectId else { return }
                        self.repository.localRealm.create(
                            UserDiary.self,
                            value:["objectId": objectId,
                                   "content": content,
                                   "title": title,
                                   "updatedAt": date],
                            update: .modified)
                        print("Update Realm 성공!")
                        transition(self, .dismiss)
                    }
                }
            } catch let error {
                print(error)
            }
            
            if let image = writerView.photoImageView.image {
                if viewType == .Write {
                    saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
                } else {
                    guard let objectId = objectId else { return }
                    saveImageToDocument(fileName: "\(objectId).jpg", image: image)
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension WriteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Constant.Color.placeholder {
            textView.text = ""
        }
        changeTextViewColor()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.Placeholder.diary.rawValue
        }
        changeTextViewColor()
    }
}

// MARK: - PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension WriteViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, err) in
                    DispatchQueue.main.async {
                        self.writerView.photoImageView.image = image as? UIImage
                    }
                }
            }
        }
    }
    
    // UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.transition(self, .dismiss)
            return
        }
        self.writerView.photoImageView.image = image
        picker.transition(self, .dismiss)
    }
}
