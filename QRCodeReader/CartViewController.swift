//
//  CartViewController.swift
//  Grocery-Assistant
//
//  Created by Manuel Escobar on 3/19/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell{
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
}

class CartViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Model.updateCart()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }//end viewWillAppear
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            Model.removeFromCart(Model.cartItems[indexPath.row].getId())
            Model.updateCart()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }//end if
    }//end tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.cartItems.count
    }//end tableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        
        cell.itemName?.text = Model.cartItems[indexPath.row].getName()
        cell.itemPrice?.text = Model.cartItems[indexPath.row].getPriceString()
        
        return cell
    }//end tableView
}//end class
