//
//  Model.swift
//  Grocery-Assistant
//
//  Created by Manuel Escobar on 3/11/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import SQLite3

class Model {
    
    static var dbPointer: OpaquePointer? = nil
    static var statementPointer: OpaquePointer? = nil
    static var dbURL : URL? = nil
    
    static var listItems = [ListItem]()
    static var cartItems = [CartItem]()
    static var testItems = Array<Product>()
    static var dbInitialized = false
    
    public static func createDB(_ aName: String){
        Model.dbURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(aName + ".sqlite")
        print("DB cerated at: ")
        print(Model.dbURL!)
    }//end createDB
    
    public static func openDB(){
        
        if sqlite3_open(Model.dbURL!.path, &Model.dbPointer) != SQLITE_OK{
            print("Error opening database")
        }//end if
        else{
            print("DB Opened.")
        }//end else
    }//end openDB
    
    public static func exec(_ aQuery: String){
        var errorMessage: String
        
        if sqlite3_exec(Model.dbPointer, aQuery, nil, nil, nil) != SQLITE_OK{
            errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error executing SQL statement \(errorMessage)")
        }//end if
        else{
            print("SQL statment executed: ")
            print(aQuery)
        }//end else
    }//end exec
    
    static func initialize(){
        
        if !dbInitialized{
            initializeDataBases()
        }//end if
        
    }//end initialize
    
    static func initializeDataBases(){
        loadProducts("Products")
        dbInitialized = true
    }//end initializeDatabases

    //////////////// GET METHODS
    public static func getListResultSet() -> Array<ListItem>{
        var resultSet: Array<ListItem>
        var name: String
        var stmt: OpaquePointer?
        
        resultSet = []
        
        let selectQuery = "SELECT * FROM List"
        
        if sqlite3_prepare(Model.dbPointer, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            name = String(cString: sqlite3_column_text(stmt,0))
            resultSet.append(ListItem(String(describing: name)))
        }//end while
        return resultSet
    }//end getListResultSet
    
    public static func getCartResultSet() -> Array<CartItem>{
        var resultSet: Array<CartItem>
        var id: String
        var name: String
        var value: Double
        var listName: String
        var stmt: OpaquePointer?
        resultSet = []
        
        let selectQuery = "SELECT * FROM Cart"
        
        if sqlite3_prepare(Model.dbPointer, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            id = String(cString: sqlite3_column_text(stmt,0))
            name = String(cString: sqlite3_column_text(stmt,1))
            value =  sqlite3_column_double(stmt, 2)
            listName = String(cString: sqlite3_column_text(stmt,3))
            resultSet.append(CartItem(String(describing: id), String(describing: name), Double(value), String(describing: listName)))
        }//end while
        return resultSet
    }//end getCartResultSet
    
    public static func getProductResultSet() -> Array<Product>{
        var resultSet: Array<Product>
        var id: String
        var name: String
        var value: Double
        var listName: String
        var stmt: OpaquePointer?
        resultSet = []
        
        let selectQuery = "SELECT * FROM Products"
        
        if sqlite3_prepare(Model.dbPointer, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        
        print("//////////////////// quiero ver que pedo con el getProductresult set")
        while sqlite3_step(stmt) == SQLITE_ROW {
            id = String(cString: sqlite3_column_text(stmt,0))
            name = String(cString: sqlite3_column_text(stmt,1))
            value =  sqlite3_column_double(stmt, 2)
            listName = String(cString: sqlite3_column_text(stmt,3))
            resultSet.append(Product(String(describing: id), String(describing: name), Double(value), String(describing: listName)))
            
        }//end while
        return resultSet
    }//end getCartResultSet
    
    public static func getProductName(_ id: String) -> String{
        var result: String
        var stmt: OpaquePointer?
        result = ""
        
        let selectQuery = "SELECT name FROM Products WHERE id = '\(id)'"
        if sqlite3_prepare(Model.dbPointer, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        while sqlite3_step(stmt) == SQLITE_ROW{
            result = String(cString: sqlite3_column_text(stmt, 0))
        }//end while
        return result
    }
    /////////////// INSERT METHODS
    public static func insertIntoProducts(_ id: String, _ name: String, _ price: Double, _ listName: String){
        let insertProduct = "INSERT INTO Products (id, name, price, listName) values ('\(id)', '\(name)', \(price), '\(listName)')"
        
        Model.exec(insertProduct)
    }//end insertIntoProducts
    
    public static func insertIntoList(_ name: String){
        let insertListProduct = "INSERT INTO List (name) values ('\(name)')"
        Model.exec(insertListProduct)
    }//end insertIntoList
    
    public static func insertIntoCart(_ id: String, _ name: String, _ price: Double, _ listName: String){
        let insertCartProduct = "INSERT INTO Cart (id, name, price, listName) values ('\(id)', '\(name)', \(price), '\(listName)')"
        Model.exec(insertCartProduct)
        
    }//end insertIntoCart
    
    public static func insertScannedProduct(_ id: String){
        var name: String
        var price: Double
        var listName: String
        var stmt: OpaquePointer?
        
        let query = "SELECT name, price, listname FROM Products WHERE id = '\(id)'"
        
        if sqlite3_prepare(Model.dbPointer, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            name = String(cString: sqlite3_column_text(stmt,0))
            price =  sqlite3_column_double(stmt, 1)
            listName = String(cString: sqlite3_column_text(stmt,2))
            insertIntoCart(id, name, price, listName)
        }//end while
        
        removeScannedItemFromList(id)
    }//end insertScannedProduct
    
    static func removeScannedItemFromList(_ id: String){
        let deleteQuery = "DELETE FROM List WHERE name = (SELECT listName FROM Products WHERE id = '\(id)')"
        exec(deleteQuery)
    }//end removeScannedItemFromList

    static func selectAllProducts(){
        testItems.removeAll()
        testItems = getProductResultSet()
    }//end updateList
    
    static func selectAllList(){
        listItems.removeAll()
        listItems = getListResultSet()
    }//end selectAllCart
    
    static func selectAllCart(){
        cartItems.removeAll()
        cartItems = getCartResultSet()
        
    }//end select AllCart
    
    public static func getCartTotal() -> String{
        var total: Double
        var stmt: OpaquePointer?
        
        total = 0
        let totalQuery = "SELECT sum(price) FROM Cart"
        
        if sqlite3_prepare(Model.dbPointer, totalQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing insert \(errmsg)")
        }//end if
        
        while sqlite3_step(stmt) == SQLITE_ROW{
            total = sqlite3_column_double(stmt, 0)
        }//end while
        return String(total)
    }//end getCartTtoal
    
    static func updateList(){
        listItems = getListResultSet()
    }//end updateList
    
    static func updateCart(){
        cartItems = getCartResultSet()
    }//end updateCart
    
    //////////////////// REMOVE AND DELETE METHODS
    static func removeFromCart(_ id: String){
        let deleteQuery = "DELETE FROM Cart WHERE id = '\(id)'"
        exec(deleteQuery)
        
    }//end removeFromCart
    
    static func removeFromList(_ name: String){
        let deleteQuery = "DELETE FROM List WHERE name = '\(name)'"
        exec(deleteQuery)
    }//end removeFromList
    
    static func deleteAllFromList(){
        let deleteQuery = "DELETE FROM List"
        exec(deleteQuery)
    }//edn deleteAllFromList
    
    static func deleteAllFromCart(){
        let deleteQuery = "DELETE FROM Cart"
        exec(deleteQuery)
    }//end deleteAllFromCart
    
    public static func deleteAll() {
        deleteAllFromCart()
        deleteAllFromList()
    }//end deleteAll
    
    static func loadProducts(_ afile: String){
        
        var file: UDLAPstringFile
        file = UDLAPstringFile(afile)
        file.open()
        
        var i: Int
        var id: String
        var name: String
        var price: Double
        var listName: String
        
        
        i = 0
        print("////////////////////AQUI ES PARA VER QUE SI FUNCIONE EL LEER UDLAP STRING FILE")
        while(i < file.size()){
            id = file.get(i)!
            name = file.get(i+1)!
            price = Double(file.get(i+2)!)!
            listName = file.get(i+3)!
            
            Model.insertIntoProducts(id, name, price, listName)
            
            i = i + 5
        }//end while
        print("////////////////////AQUI ES PARA VER QUE SI FUNCIONE EL LEER UDLAP STRING FILE")
    }//end readFile
    
}//end Model
