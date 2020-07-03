//
//  ViewController.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-27.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var loginBarbutton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories:[Category] = []
    
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpCollectionView()
        setUpInitialAnonymousUser()
//        setUpNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        fetchDocument()
        //        fetchCollection()
        setCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous{
            loginBarbutton.title = "Logout"
        } else {
            loginBarbutton.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    
    func setUpNavigationBar() {
        guard let font = UIFont(name: "futura", size: 26) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        db = Firestore.firestore()
        
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
    }
    
    func setUpInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            
            
            Auth.auth().signInAnonymously(completion: {(result, error) in
                
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                    
                }
            })
        }
    }
    
    func setCategoriesListener() {
        listener = db.categories.addSnapshotListener { snap, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach { (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                    
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                
                case .removed:
                    self.onDocumentRemoved(change: change)
                
                default:
                    break
                }
            }
        }
    }
    
 
    
    func presetnVC() {
        let storyBoard = UIStoryboard(name: StoryBoard.loginStoryBoard, bundle: nil)
        let viewcontroller = storyBoard.instantiateViewController(identifier: StoryBoardID.loginStoryBoardID)
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    @IBAction func loginInOutAction(_ sender: UIBarButtonItem) {
        
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if user.isAnonymous {
            presetnVC()
        } else {
            
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presetnVC()
                    
                }
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toProductVC {
            if let destination = segue.destination as? ProductVC {
                destination.category = selectedCategory
            }
        }
    }
    
   
    
    
    @IBAction func goBackAction(_ sender: Any) {
        
        let VC = UIStoryboard(name: StoryBoard.loginStoryBoard, bundle: nil).instantiateViewController(identifier: StoryBoardID.loginStoryBoardID)
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
         let newIndex = Int(change.newIndex)
         categories.insert(category, at: newIndex)
         self.collectionView.reloadData()
     }
     
     func onDocumentModified(change: DocumentChange, category: Category) {
         
         if change.oldIndex == change.newIndex {
             let index = Int(change.newIndex)
             categories[index] = category
             collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
         } else {
             let oldIndex = Int(change.oldIndex)
             let newIndex = Int(change.newIndex)
             
             categories.remove(at: oldIndex)
             categories.insert(category, at: newIndex)
             
             collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
         }
     }
     
     func onDocumentRemoved(change: DocumentChange) {
         
         let oldIndex = Int(change.oldIndex)
         categories.remove(at: oldIndex)
         self.collectionView.reloadItems(at: [IndexPath(item: oldIndex, section: 0)])
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
//            if indexPath.row == 1 {
                cell.categoryImg.image = #imageLiteral(resourceName: "bg_cat3")
//            }
            
            cell.configureCell(category: categories[indexPath.item])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toProductVC, sender: self)
    }
    
    
    
}

//func fetchDocument() {
//       let docRef = Firestore.firestore().collection("categories").document("")
//       
//       listener = docRef.addSnapshotListener { (snap, error) in
//           
//           self.categories.removeAll()
//           guard let data = snap?.data() else { return }
//           
//           let newCategory = Category.init(data: data)
//           
//           self.categories.append(newCategory)
//           self.collectionView.reloadData()
//       }
//   }
//   


//   func fetchCollection() {
//       let collectionRef = db.collection("categories")
//
//        listener = collectionRef.addSnapshotListener { (snap, error) in
//
//           self.categories.removeAll()
//           guard let documents = snap?.documents else { return }
//
//           for doc in documents {
//               let data = doc.data()
//               let newCategory = Category.init(data: data)
//
//               self.categories.append(newCategory)
//               self.collectionView.reloadData()
//           }
//       }
//}
