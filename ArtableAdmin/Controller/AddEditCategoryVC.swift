//
//  AddCategoryVC.swift
//  ArtableAdmin
//
//  Created by 北島　志帆美 on 2020-07-01.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    var categoryToEdit: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTouchesRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addButton.setTitle("Save Chagnge", for: .normal)
            
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFit
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped() {
        launchImgPicker()
    }
    
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        uploardImageTheDocument()
    }
    
    func uploardImageTheDocument() {
        
        guard let image = categoryImg.image, let categoryName = nameTxt.text else {
            simpleAlert(title: "Error", msg: "Must add category and name.")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("categoryImages/categoryName.jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            
            if let error = error {
                debugPrint(error)
                self.handleError(error: error, msg: "Unable to upload image.")
                self.activityIndicator.stopAnimating()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    debugPrint(error)
                    self.handleError(error: error, msg: "Unable to retrieve image.")
                    
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                guard let url = url else { return }
                self.uploardDocument(url: url.absoluteString)
            })
        }
        
    }
    
    func uploardDocument(url: String) {
        
        var docRef:DocumentReference?
        var category = Category.init(name: nameTxt.text!, id: "", imgUrl: url, isActive: true, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            docRef = Firestore.firestore().collection("categories").document(category.id)
            category.id = categoryToEdit.id
        } else {
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef!.documentID
            
        }
    
        let data = Category.modelToData(category)
        
        docRef!.setData(data, merge: true, completion: { (url, error) in
            
            if let error = error {
                handleError(error: error, msg: "Unable to upload new category.")
                return
            }
            self.navigationController?.popViewController(animated: true)
            
        })
    }
    
    func handleError(error: Error, msg: String) {
        
        debugPrint(error)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
//        return
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
