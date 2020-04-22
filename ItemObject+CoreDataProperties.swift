//
//  ItemObject+CoreDataProperties.swift
//  MMTest
//
//  Created by Artem Mkrtchyan on 4/22/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemObject> {
        return NSFetchRequest<ItemObject>(entityName: "ItemObject")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var priceX10: Int64
    @NSManaged public var type: String?
    @NSManaged public var objectData: Data?
    
    var object: ItemExtensions? {
        get {
            switch ItemType.init(rawValue: self.type!) {
            case .Book:
                return try? JSONDecoder().decode(Book.self, from: self.objectData! )
            case .Car:
                return try? JSONDecoder().decode(Car.self, from: self.objectData! )
            case .Phone:
                return try? JSONDecoder().decode(Phone.self, from: self.objectData! )
            default:
                return nil
            }
        }
        
        set {
            if let itemProtocol = newValue {
                self.id = Int64(itemProtocol.id)
                self.name = itemProtocol.name
                self.priceX10 = Int64(itemProtocol.priceX10)
                
                self.type = itemProtocol.type.rawValue
                
                switch itemProtocol.type {
                case .Book:
                    self.objectData = try! JSONEncoder().encode(newValue as! Book)
                case .Car:
                    self.objectData = try! JSONEncoder().encode(newValue as! Car)
                case .Phone:
                    self.objectData = try! JSONEncoder().encode(newValue as! Phone)
                }
            }
        }
    }
    
}
