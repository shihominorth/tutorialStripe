//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by 北島　志帆美 on 2020-06-27.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem?.isEnabled = false
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryButton
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func addCategory() {
        
        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
    }


}

