//
//  SignInViewController.swift
//  GroupTalk
//
//  Created by youngjun goo on 27/01/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cancelButton: RoundedWhiteButton!
    @IBOutlet weak var continueButton: RoundedWhiteButton!
    
    var activityView: UIActivityIndicatorView!
    
    @IBAction func touchUpProfileAdding(_ sender: UITapGestureRecognizer) {
        profileImagePicker()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        doSignUp()
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var colorString: String! = nil
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        self.ref = Database.database().reference()
        
        
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setUpLayout() {
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        colorString = remoteConfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: colorString)
        // signUpButton.backgroundColor = UIColor(hex: colorString)
    }
    
}

extension SignUpViewController {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func doSignUp() {
        
        if emailTextField.text! == "" {
            showAlert(message: "이메일을 입력해주세요.")
            return
        }
        
        if pwdTextField.text! == "" {
            showAlert(message: "비밀 번호를 입력해 주세요.")
            return
        }
        
        if nameTextField.text! == "" {
            showAlert(message: "이름을 입력해 주세요.")
            return
        }
        
        signUp(email: emailTextField.text!, password: pwdTextField.text!, name: nameTextField.text!)
    }
    
    func setContinueButton(enable: Bool) {
        if enable {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        
        setContinueButton(enable: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("Urser Created")
                
                
            }
        }
        
    }
    
    
    func profileImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //선택한 사진을 수정 할 수 있는 여부를 정하는 값
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let changedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = changedImage //편집된 사진을 뷰에 present
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
    }
    
    
    
}
