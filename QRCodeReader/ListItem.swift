//
//  ListItem.swift
//  Grocery-Assistant
//
//  Created by Manuel Escobar on 3/11/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class ListItem{
    var name: String
    
    init(_ aName: String){
        name = aName
    }//end init
    
    func getName() -> String{
        return name
    }//end getName
}
