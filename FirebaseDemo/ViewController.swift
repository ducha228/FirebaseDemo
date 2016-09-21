//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by DucHa on 9/21/16.
//  Copyright © 2016 DucHa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var items = [GroceryItem]()
    let groceryRef = FIRDatabase.database().reference(withPath: "grocery-items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        groceryRef.observe(.value, with: { snapshot in
            self.items.removeAll()
            for item in snapshot.children {
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                self.items.append(groceryItem)
            }
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addDidPush(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Grocery", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField = alert.textFields?.first, let text = textField.text, text.characters.count > 0 else {
                return
            }
            let groceryItem = GroceryItem(name: text, createdDate: Date())
            let groceryItemRef = self.groceryRef.child(text)
            groceryItemRef.setValue(groceryItem.toDic())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "GroceryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let grocery = items[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        cell.textLabel?.text = grocery.name
        cell.detailTextLabel?.text = dateFormatter.string(from: grocery.createdDate)
        
        return cell
    }
}
