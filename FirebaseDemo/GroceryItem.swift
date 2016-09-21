//
//  GroceryItem.swift
//  FirebaseDemo
//
//  Created by DucHa on 9/21/16.
//  Copyright © 2016 DucHa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct GroceryItem {
    var name: String
    var createdDate: Date
    
    init(name : String, createdDate : Date) {
        self.name = name
        self.createdDate = createdDate
    }
    
    init(snapshot: FIRDataSnapshot) {
        name = (snapshot.value as! [String : AnyObject])["name"] as? String ?? ""
        let createdDateStr = (snapshot.value as! [String : AnyObject])["created_date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        createdDate = (createdDateStr != nil) ? dateFormatter.date(from: createdDateStr!)! : Date()
    }
    
    func toDic() -> AnyObject {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let dic = ["name" : name, "created_date" : dateFormatter.string(from: createdDate)]
        return dic as AnyObject
    }
}
