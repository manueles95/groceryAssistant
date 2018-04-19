//
//  QRCodeViewController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var totalTextField: UITextField!
    
    @IBAction func startFresh(_ sender: Any) {
        Model.deleteAll()
        updateView()
    }//end startFresh
    
//    @IBAction func showAllTest(_ sender: Any) {
//        Model.selectAllProducts()
//        showProducts()
//        showList()
//    }//edn showAllTest
    
    private func showProducts(){
        print("======")
        for product in Model.testItems{
            print("ID: " + String(product.id))
            print("NOMBRE: " + product.name)
            print("price: " + String(product.value))
            print("listName: " + product.listName)
        }//end for
        print("======")
    }//end showList
    
    private func showList(){
        print("======")
        for product in Model.listItems{
            print("NOMBRE: " + product.name)
        }//end for
        print("======")
    }//end showList
    
    private func showCart(){
        print("======")
        for product in Model.cartItems{
            print("ID: " + String(product.id))
            print("NOMBRE: " + product.name)
            print("price: " + String(product.value))
            print("listName: " + product.listName)
        }//end for
        print("======")
    }//end showList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createProductsTable = "CREATE TABLE IF NOT EXISTS Products (id TEXT PRIMARY KEY, name TEXT, price FLOAT, listName TEXT)"
        let createListTbale = "CREATE TABLE IF NOT EXISTS List (name TEXT PRIMARY KEY)"
        let createCartTable = "CREATE TABLE IF NOT EXISTS Cart (id TEXT PRIMARY KEY, name TEXT, price FLOAT, listName TEXT)"
        
        Model.createDB("testDB6")
        Model.openDB()
        Model.exec(createProductsTable)
        Model.exec(createCartTable)
        Model.exec(createListTbale)
        Model.initialize()
        updateView()
        
        // Do any additional setup after loading the view.
    }
    
    private func updateView(){
        totalTextField.text = Model.getCartTotal()
    }//end updateView

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

}
