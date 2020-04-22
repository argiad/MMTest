//
//  DataStruct.swift
//  MMTest
//
//  Created by Artem Mkrtchyan on 4/22/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import Foundation
import CoreData

struct Owner: Codable {
    let id: Int
    let name: String
}

protocol Item {
    
    var id: Int {get set}
    var name: String {get set}
    var priceX10: Int {get set}
    
}

protocol ItemExtensions: Item, Codable {
    var type:ItemType {get}
    var owner: Owner {get set}
}

enum ItemType: String, Codable, CaseIterable {
    case Book, Car, Phone
}

struct Book: Item, ItemExtensions {
    
    var type: ItemType = .Book
    
    var owner: Owner
    
    var id: Int
    var name: String
    var priceX10: Int
    
    let ISBN: String
    
}

struct Car: Item, ItemExtensions {
    
    var type: ItemType = .Car
    
    var owner: Owner
    
    var id: Int
    var name: String
    var priceX10: Int
    
    var VIN: String
}

struct Phone: Item, ItemExtensions {
    
    var type: ItemType = .Phone
    
    
    var owner: Owner
    
    var id: Int
    var name: String
    var priceX10: Int
    
    var IMEI: String
    
}

//class ItemObject: NSManagedObject, Item {
//    
//    @NSManaged var id: Int
//    @NSManaged var name: String
//    @NSManaged var priceX10: Int
//    
//    @NSManaged var objectData: Data
//    @NSManaged var type:String
//    
//    var object: ItemExtensions? {
//        get {
//            switch ItemType.init(rawValue: self.type) {
//            case .Book:
//                return try? JSONDecoder().decode(Book.self, from: self.objectData )
//            case .Car:
//                return try? JSONDecoder().decode(Car.self, from: self.objectData )
//            case .Phone:
//                return try? JSONDecoder().decode(Phone.self, from: self.objectData )
//            default:
//                return nil
//            }
//        }
//        
//        set {
//            if let itemProtocol = newValue {
//                self.id = Int(itemProtocol.id)
//                self.name = itemProtocol.name
//                self.priceX10 = Int(itemProtocol.priceX10)
//                
//                self.type = itemProtocol.type.rawValue
//                
//                switch itemProtocol.type {
//                case .Book:
//                    self.objectData = try! JSONEncoder().encode(newValue as! Book)
//                case .Car:
//                    self.objectData = try! JSONEncoder().encode(newValue as! Car)
//                case .Phone:
//                    self.objectData = try! JSONEncoder().encode(newValue as! Phone)
//                }
//            }
//        }
//    }
//    
//}


