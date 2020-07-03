//
//  Product.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-29.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import Foundation
import Firebase

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imgUrl: String
    var timeStamp: Timestamp
    var stock: Int
    //    var favorite: Bool
    
    
    init(
        name:String,
        id:String,
        category:String,
        price:Double,
        productDescription:String,
        imgUrl:String,
        timeStamp:Timestamp,
        stock:Int
    ) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imgUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    init(data: [String: Any]) {
        
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        price = data["price"] as? Double ?? 0.0
        productDescription = data["productDescription"] as? String ?? ""
        imgUrl = data["imgUrl"] as? String ?? ""
        timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        stock = data["stock"] as? Int ?? 0
        
    }
    
    func modelToData(product: Product) -> [String: Any] {
        let data:[String: Any] = [
            
            "name" : product.name,
            "id" : product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "imgUrl": product.imgUrl,
            "timeStamp": product.timeStamp,
            "stock": product.stock
        
            ]
    }
}
