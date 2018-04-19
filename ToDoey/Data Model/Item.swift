//
//  Item.swift
//  ToDoey
//
//  Created by Anthony Shaw on 4/16/18.
//  Copyright © 2018 Anthony Shaw. All rights reserved.
//

import Foundation
// you can just use Codable in place of Encodable, Decodable

class Item: Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
