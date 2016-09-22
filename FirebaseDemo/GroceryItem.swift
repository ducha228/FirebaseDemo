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
    var creator: String
    var ref: FIRDatabaseReference?
    
    init(name : String, createdDate : Date, creator : String) {
        self.name = name
        self.createdDate = createdDate
        self.creator = creator
        ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        name = (snapshot.value as! [String : AnyObject])["name"] as? String ?? ""
        let createdDateStr = (snapshot.value as! [String : AnyObject])["created_date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        createdDate = (createdDateStr != nil) ? dateFormatter.date(from: createdDateStr!)! : Date()
        creator = (snapshot.value as! [String : AnyObject])["creator"] as? String ?? ""
        ref = snapshot.ref
    }
    
    func toDic() -> AnyObject {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let dic = ["name" : name, "created_date" : dateFormatter.string(from: createdDate), "creator" : creator]
        return dic as AnyObject
    }
}
