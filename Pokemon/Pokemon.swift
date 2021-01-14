//
//  Pokemon.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit

class Pokemon: NSObject {
    var name:String
    var id:String
    
    var url:String?
    var urlImage:String?
    
    var height: Int?
    var weight: Int?
    var baseExperiente: Int?
    var abilities:[String]?
    var forms:[String]?
    var types:[String]?
    var stats:[String:Int]?
    
    init(id:String, name:String) {
        self.id = id
        self.name = name
    }
}
