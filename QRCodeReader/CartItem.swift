//
//  CartItem.swift
//  Grocery-Assistant
//
//  Created by Manuel Escobar on 3/11/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class CartItem{
    var id: String
    var name: String
    var value: Double
    var listName: String
    
    init(_ anId: String, _ aName: String, _ aValue: Double, _ aListName: String){
        id = anId
        name = aName
        value = aValue
        listName = aListName
    }//end init
    
    func getId() -> String {
        return id
    }//end getId
    
    
    func getListName() -> String{
        return listName
    }//end getListName
    
    func getName() -> String{
        return name
    }
    
    func getPriceString() -> String{
        return String(value)
    }
    
    func getPrice() -> Double{
        return value
    }//end getPrice
    
    
    
}//end CartItem
