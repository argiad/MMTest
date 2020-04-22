//
//  ViewController.swift
//  MMTest
//
//  Created by Artem Mkrtchyan on 4/22/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let owner = Owner (id: 0, name: "My self")
    
    private var list: [ItemExtensions] = []
    
    @IBOutlet weak var itemTypeSelector: UISegmentedControl!
    @IBOutlet weak var mainList: UITableView!
    
    @IBAction func createNewItem(_ sender: Any) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ItemObject", in: dbContext)!
        let _object = NSManagedObject(entity: entity, insertInto: dbContext) as? ItemObject
        do {
            switch itemTypeSelector.selectedSegmentIndex {
            case 0:
                _object?.object = Book(owner: owner, id: 0, name: "Bla Bla Bla", priceX10: 100, ISBN: "989898989")
            case 1:
                _object?.object = Car(owner: owner, id: 1, name: "My Car", priceX10: 1000000, VIN: "WBY2Z2C50GV676221")
            case 2:
                _object?.object = Phone(owner: owner, id: 2, name: "my Phone", priceX10: 88800, IMEI: "990000862471854")
            default:
                return
            }
            
            
            try dbContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        list = fetchItems()
        mainList.reloadData()
    }
    
    @IBAction func clearAll(_ sender: Any) {
        deleteAll()
        list = fetchItems()
        mainList.reloadData()
    }
    
    @IBAction func exportToJSON(_ sender: Any) {
        list.forEach { item in
            
            switch item  {
            case is Phone:
                if let json = try? JSONEncoder().encode(item as! Phone) {
                    print(String(data: json, encoding: .utf8) ?? "")
                }
            case is Car:
                if let json = try? JSONEncoder().encode(item as! Car) {
                    print(String(data: json, encoding: .utf8) ?? "")
                }
            case is Book:
                if let json = try? JSONEncoder().encode(item as! Book) {
                    print(String(data: json, encoding: .utf8) ?? "")
                }
            default:
                break
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTypeSelector.removeAllSegments()
        ItemType.allCases.enumerated().forEach { index, type in
            itemTypeSelector.insertSegment(withTitle: type.rawValue, at: index, animated: false)
        }
        itemTypeSelector.selectedSegmentIndex = 0
        
        mainList.delegate = self
        mainList.dataSource = self
        
        list = fetchItems()
        mainList.reloadData()
        
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = list[indexPath.row].type.rawValue
        return cell
    }
    
    
}


extension ViewController {
    
    func fetchItems() -> [ItemExtensions] {
        var list:[ItemExtensions] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemObject")
        
        var results: [ItemObject] = []
        do {
            results = try dbContext.fetch(fetchRequest) as! [ItemObject]
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        for item in results {
            if let object = item.object {
                list.append(object)
            }
        }
        
        return list
    }
    
    
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemObject")
        
        var results: [ItemObject] = []
        do {
            results = try dbContext.fetch(fetchRequest) as! [ItemObject]
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        
        results.forEach{ item in
            dbContext.delete(item)
        }
        
    }
    
}
