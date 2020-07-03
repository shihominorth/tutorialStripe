//
//  AddEditProductVC.swift
//  ArtableAdmin
//
//  Created by 北島　志帆美 on 2020-07-02.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class AddEditProductVC: UIViewController {
    
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    
    var selectedCategory: Category!
    var productToEdit: Product?
    
    var name = ""
    var price = 0.0
    var productDescrition = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTouchesRequired = 1
        productImageview.clipsToBounds = true
        productImageview.isUserInteractionEnabled = true
        productImageview.addGestureRecognizer(tap)
        
        
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            addButton.setTitle("Save Change", for: .normal)
            
            if let url = URL(string: product.imgUrl) {
                productImageview.contentMode = .scaleAspectFit
                productImageview.kf.setImage(with: url)
            }
        }
        
    }
    
    
    @objc func imgTapped() {
        launchImgPicker()
    }

    @IBAction func addbuttonClicked(_ sender: Any) {
        uploadImageTheDocument()
    }
    
    
    func uploadImageTheDocument() {
        
        guard let image = productImageview.image,
            let name = productNameTxt.text,
            let description = productDescTxt.text,
            let priceString = productPriceTxt.text,
            let price = Double(priceString) else {
          
                simpleAlert(title: "Error", msg: "please fill out all required fields")
                return
                
        }
        
        
        self.name = name
        self.productDescrition = description
        self.price = price
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("productImages/\(name).jpg")
        
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
//                self.uploardDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploardDocument(url: String) {
           
           var docRef:DocumentReference?
        var category = Product.init(name: name,
                                    id: "",
                                    category: selectedCategory.id,
                                    price: price,
                                    productDescription: productDescrition,
                                    imgUrl: url,
                                    timeStamp: Timestamp(),
                                    stock: 0)
           
           if let productToEdit = productToEdit {
               docRef = Firestore.firestore().collection("products").document(category.id)
//               category.id = categoryToEdit.id
            category.id = selectedCategory.id
           } else {
               docRef = Firestore.firestore().collection("products").document()
               category.id = docRef!.documentID
               
           }
       
        let data = Product.modelToData(productToEdit!)
           
        docRef?.setData(data, merge: true, completion: { (url, error) in
               
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

extension AddEditProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImageview.contentMode = .scaleAspectFill
        productImageview.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
