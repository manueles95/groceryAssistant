//
//  ListViewController.swift
//  Grocery-Assistant
//
//  Created by Manuel Escobar on 3/19/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell{
    
    @IBOutlet weak var itemName: UILabel!
}//end class

class ListViewController: UITableViewController{
    
    
    @IBAction func addListItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Insert new Product", message: "Insert the name of the prodcut to add", preferredStyle: .alert)
        alert.addTextField{(textField) in textField.text = ""}
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction!) in
            let textField = alert.textFields![0]
            Model.insertIntoList(textField.text!)
            self.updateView()
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }//end addListItem
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()

    }//end viewDidLoad
    
    private func updateView(){
        Model.updateList()
        tableView.reloadData()
    }//end updateView
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }//end viewWillAppear
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.listItems.count
    }//end tableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        cell.itemName?.text = Model.listItems[indexPath.row].getName()
        return cell
    }//end tableView
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Model.removeFromList(Model.listItems[indexPath.row].getName())
            Model.updateList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }//end if
    }//end function
    
}//end class
